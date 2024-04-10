import 'dart:async';
import 'dart:math';

import 'package:caravan/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:location/location.dart' as location;
import 'package:caravan/services/location_service.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;

class GoogleMapsView extends StatefulWidget {
  const GoogleMapsView({super.key});

  @override
  State<GoogleMapsView> createState() => _GoogleMapsViewState();
}

class _GoogleMapsViewState extends State<GoogleMapsView> {
  final location.Location locationController1 = location.Location();
  static var pickupLocationCoordinates = const LatLng(0.3254716, 32.5665353);
  static var pickupLocationName = 'Kampala, Uganda';

  // varible to hold the destinationCoordinates
  static var destinationCoordinates = const LatLng(-0.6934700, 30.3019000);
  static var destinationName = 'Kigali, Rwanda';
  GoogleMapController? _mapController;
  LatLng? currentPosition;
  String? searchText;
  List<String> locationSuggestions = [];
  final Set<Marker> _markers = {
    Marker(
      markerId: const MarkerId('marker_1'),
      position: pickupLocationCoordinates,
    ),
    // Marker(markerId: MarkerId('marker_2'), position: pickupLocationCoordinates),
    Marker(
        markerId: const MarkerId('marker_3'), position: destinationCoordinates),
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
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) async => await initializeMap());
  }

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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.white),
        automaticallyImplyLeading: true,
        elevation: 0,
      ),
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
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            // child is a modal for searching for destinationCoordinates locations
            child: Container(
              padding: const EdgeInsets.all(10),
              color: Colors.white,
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
                      hintText: 'Enter destinationCoordinates location',
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
                      updateMarkers(
                          pickupLocationCoordinates, destinationCoordinates);

                      // Fetch the polyline points between the pickup and destinationCoordinates locations
                      fetchPolylinePoints(
                              pickupLocationCoordinates, destinationCoordinates)
                          .then((polylinePoints) {
                        // Generate the polyline from the points
                        generatePolyLineFromPoints(polylinePoints);

                        // initialise the map
                        initializeMap();

                        // Move the camera to the pickup location

                        // animateToLocation(pickupLocationCoordinates, 10);

                        animateToBounds(
                            pickupLocationCoordinates, destinationCoordinates);
                      });
                    },
                    child: const Text('Get Directions'),
                  ),
                  const SizedBox(height: 16),
                  if (locationSuggestions.isNotEmpty)
                    Column(
                      children: locationSuggestions
                          .map((location) => ListTile(
                                leading: const Icon(Icons.location_on),
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
                                      destinationController.text = location;
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
          )
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
      return const LatLng(
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
          markerId: const MarkerId('pickup'),
          position: pickupLocationCoordinates,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          infoWindow: const InfoWindow(title: 'Pickup Location'),
        ),
      );
      _markers.add(
        Marker(
          markerId: const MarkerId('destinationCoordinates'),
          position: destinationCoordinates,
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          infoWindow: const InfoWindow(title: 'Destination'),
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
