import 'dart:async';
import 'dart:math';

import 'package:caravan/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
// import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:location/location.dart' as location;
import 'package:caravan/services/location_service.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;

// import 'package:caravan/services/location_service.dart';

class GoogleMapsView extends StatefulWidget {
  const GoogleMapsView({super.key});

  @override
  State<GoogleMapsView> createState() => _GoogleMapsViewState();
}

class _GoogleMapsViewState extends State<GoogleMapsView>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) async => await initializeMap());
    // add observer

    WidgetsBinding.instance.addObserver(this);
  }

  final location.Location locationController1 = location.Location();
  static var pickupLocationCoordinates;
  static var pickupLocationName = 'Kampala, Uganda';

  // varible to hold the destinationCoordinates
  static var destinationCoordinates;
  static var destinationName = 'Kigali, Rwanda';
  GoogleMapController? _mapController;
  static LatLng? currentPosition;
  String? searchText;
  List<String> locationSuggestions = [];
  static final Set<Marker> _markers = {
    Marker(
      markerId: const MarkerId('marker_1'),
      position: pickupLocationCoordinates,
    ),
    Marker(
        markerId: const MarkerId('marker_3'), position: destinationCoordinates),
    // marker for currentPosition
    Marker(
      markerId: const MarkerId('marker_2'),
      position: currentPosition ?? pickupLocationCoordinates,
    ),
  };

  Map<PolylineId, Polyline> polylines = {};

  final pickupController = TextEditingController();
  final destinationController = TextEditingController();

  static bool pickupFocus = true;

  String pickupText = '';
  String destinationText = '';

  Future<dynamic> getLocationSuggestion(String query) async {
    var key = LocationService().key;
    var url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$query&key=$key');

    var response = await http.get(url);

    if (response.statusCode == 200) {
      final places = json.decode(response.body);
      // print(places);

      if (places['predictions'].length > 0) {
        var result = {
          'places_prediction1': places['predictions'][0]['description'],
          'places_prediction2': places['predictions'][1]['description'],
          'places_prediction3': places['predictions'][2]['description'] ?? '',
          'places_prediction4': places['predictions'][3]['description'] ?? '',
        };

        // print(result);
        setState(() {
          locationSuggestions = List<String>.from(places['predictions']
              .map((prediction) => prediction['description']));
        });

        // print(result);
      } else {
        // print('No predictions found');
        setState(() {
          locationSuggestions.clear();
        });
      }
    } else {
      throw Exception('Failed to load predictions');
    }
  }

  @override
  void didChangeMetrics() {
    if (MediaQuery.of(context).viewInsets.bottom > 0) {
      // Keyboard is visible
      setState(() {
        // Set the maxChildSize to expand the sheet
        // Adjust this value based on your needs
        maxChildSize = 0.9;
      });
    } else {
      // Keyboard is not visible
      setState(() {
        // Set the maxChildSize back to its original value
        maxChildSize = 0.5;
      });
    }
  }

  double maxChildSize = 0.4;

  Future<void> initializeMap() async {
    await fetchLocationUpdates();
    // _animateToLocation();
    final coordinates = await fetchPolylinePoints(
        pickupLocationCoordinates, destinationCoordinates);
    generatePolyLineFromPoints(coordinates);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (controller) {
              _mapController = controller;
            },
            initialCameraPosition: CameraPosition(
              target: pickupLocationCoordinates,
              zoom: 10,
            ),
            markers: _markers,
            polylines: Set<Polyline>.of(polylines.values),
            onTap: (LatLng latLng) {
              setState(() {
                currentPosition = latLng;
              });
            },
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.4, // Initial size of the sheet
            minChildSize: 0.4, // Minimum size of the sheet
            maxChildSize: 1, // Maximum size of the sheet
            builder: (BuildContext context, ScrollController scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 5,
                      width: 100,
                      margin: EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 128, 128, 128),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          TextField(
                            controller: pickupController,
                            onChanged: (value) {
                              setState(() {
                                pickupText = value;
                                pickupFocus = true;
                              });
                              getLocationSuggestion(value);
                            },
                            decoration: const InputDecoration(
                              hintText: 'Enter pickup location',
                              border: OutlineInputBorder(),
                              suffixIcon: Icon(Icons.location_on),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: destinationController,
                            onChanged: (value) {
                              setState(() {
                                destinationText = value;
                                pickupFocus = false;
                              });
                              getLocationSuggestion(value);
                            },
                            decoration: const InputDecoration(
                              hintText: 'Enter destination location',
                              border: OutlineInputBorder(),
                              suffixIcon: Icon(Icons.location_on),
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () async {
                              // Get the coordinates of the pickup and destinationCoordinates locations
                              pickupLocationCoordinates =
                                  await _searchLocation(pickupText);
                              destinationCoordinates =
                                  await _searchLocation(destinationText);
                              // Update the markers on the map
                              updateMarkers(pickupLocationCoordinates,
                                  destinationCoordinates);

                              // Fetch the polyline points between the pickup and destinationCoordinates locations
                              fetchPolylinePoints(pickupLocationCoordinates,
                                      destinationCoordinates)
                                  .then((polylinePoints) {
                                // Generate the polyline from the points
                                generatePolyLineFromPoints(polylinePoints);

                                // initialise the map
                                initializeMap();

                                // Move the camera to the pickup location

                                // animateToLocation(pickupLocationCoordinates, 10);

                                animateToBounds(pickupLocationCoordinates,
                                    destinationCoordinates);
                              });
                            },
                            child: const Text('Get Directions'),
                          ),
                          SizedBox(height: 16),
                          if (locationSuggestions.isNotEmpty)
                            Column(
                              children: locationSuggestions
                                  .map((location) => ListTile(
                                        leading: Icon(Icons.location_on),
                                        title: Text(location),
                                        onTap: () {
                                          // Auto-fill the search bar with the selected location and search for it
                                          setState(() {
                                            if (pickupFocus) {
                                              pickupText = location;
                                              pickupLocationName = location;
                                              pickupController.text = location;
                                            } else {
                                              destinationText = location;
                                              destinationName = location;
                                              destinationController.text =
                                                  location;
                                            }
                                            locationSuggestions.clear();
                                          });
                                        },
                                      ))
                                  .toList(),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

// use awesome_place_search to create the modal for predictions

  Future<void> fetchLocationUpdates() async {
    bool serviceEnabled;
    location.PermissionStatus permissionGranted;
    print("Fetch location is running");
    serviceEnabled = await locationController1.serviceEnabled();
    print(serviceEnabled);
    if (!serviceEnabled) {
      serviceEnabled = await locationController1.requestService();
      print("Service is enabled now");
    } else {
      return;
    }

    permissionGranted = await locationController1.hasPermission();
    if (permissionGranted == location.PermissionStatus.denied) {
      permissionGranted = await locationController1.requestPermission();
      if (permissionGranted != location.PermissionStatus.granted) {
        return;
      }
    }

    locationController1.onLocationChanged
        .listen((location.LocationData currentLocation) {
      if (currentLocation.latitude != null &&
          currentLocation.longitude != null) {
        setState(() {
          currentPosition = LatLng(
            currentLocation.latitude!,
            currentLocation.longitude!,
          );
        });
      }
    });
  }

  Future<List<LatLng>> fetchPolylinePoints(
      LatLng pickup, LatLng destinationAddress) async {
    final polylinePoints = PolylinePoints();
    final result = await polylinePoints.getRouteBetweenCoordinates(
      googleMapsApiKey,
      PointLatLng(pickup.latitude, pickup.longitude),
      PointLatLng(destinationAddress.latitude, destinationAddress.longitude),
    );
    if (result.points.isNotEmpty) {
      return result.points
          .map((point) => LatLng(point.latitude, point.longitude))
          .toList();
    } else {
      debugPrint(result.errorMessage);
      return [];
    }
  }

  // generatePolyLinefromPoints
  Future<void> generatePolyLineFromPoints(List<LatLng> polylinePoints) async {
    const id = PolylineId('polyline');
    final polyline = Polyline(
        polylineId: id,
        color: Colors.blueAccent,
        points: polylinePoints,
        width: 3);
    setState(() {
      polylines[id] = polyline;
    });
  }

  Future<LatLng> _searchLocation(String location) async {
    try {
      // Get place details using the location name
      Map<String, dynamic> placeDetails =
          await LocationService().getPlace(location);

      // Extract coordinates from the place details
      Map<String, double> coordinates =
          LocationService().extractCoordinates(placeDetails);
      double latitude = coordinates["lat"]!;
      double longitude = coordinates["lng"]!;

      // print(LatLng(latitude, longitude));

      return LatLng(latitude, longitude);
    } catch (e) {
      // Handle any errors that occur during the search
      print("An error occurred while searching for location");
      print(e);
      return LatLng(
          0, 0); // Return a default value or handle the error as needed
    }
  }

  void updateMarkers(LatLng pickupLocation, LatLng destinationLocation) {
    setState(() {
      // Clear existing markers
      _markers.clear();

      // Add new markers for pickup and destinationCoordinates
      _markers.add(
        Marker(
          markerId: MarkerId('pickup'),
          position: pickupLocationCoordinates,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          infoWindow: InfoWindow(title: 'Pickup Location'),
        ),
      );
      _markers.add(
        Marker(
          markerId: MarkerId('destinationCoordinates'),
          position: destinationCoordinates,
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          infoWindow: InfoWindow(title: 'Destination'),
        ),
      );
    });
  }

  // animate to location
  void animateToLocation(LatLng location, double zoom) {
    if (_mapController != null) {
      // Create a CameraPosition with the given location and zoom level
      CameraPosition cameraPosition = CameraPosition(
        target: location,
        zoom: zoom,
      );

      // Animate the map camera to the specified position
      _mapController!
          .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    }
  }

  void animateToBounds(LatLng pickup, LatLng destination) {
    LatLngBounds bounds = LatLngBounds(
      southwest: LatLng(min(pickup.latitude, destination.latitude),
          min(pickup.longitude, destination.longitude)),
      northeast: LatLng(max(pickup.latitude, destination.latitude),
          max(pickup.longitude, destination.longitude)),
    );

    // Calculate padding to ensure markers are fully visible
    double padding = 50.0;

    // Animate the camera to fit the bounds with padding
    _mapController
        ?.animateCamera(CameraUpdate.newLatLngBounds(bounds, padding));
  }
}
