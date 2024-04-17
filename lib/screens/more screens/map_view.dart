import 'dart:async';
import 'dart:math';

import 'package:caravan/services/location_service.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as location;
import 'package:logger/logger.dart';

class GoogleMapsView extends StatefulWidget {
  const GoogleMapsView({super.key});

  @override
  State<GoogleMapsView> createState() => _GoogleMapsViewState();
}

class _GoogleMapsViewState extends State<GoogleMapsView> {
  late LatLng currentPosition = const LatLng(0, 0);
  final location.Location locationController1 = location.Location();
  static late LatLng pickupLocationCoordinates;
  static var pickupLocationName = '';
  final logger = Logger();

  // varible to hold the destinationCoordinates
  static late LatLng destinationCoordinates;
  static var destinationName = '';
  static List<LatLng> _routes = [];
  GoogleMapController? _mapController;
  String? searchText;
  List<String> locationSuggestions = [];
  static final Set<Marker> _markers = {};

  static Map<PolylineId, Polyline> polylines = {};

  final pickupController = TextEditingController();
  final destinationController = TextEditingController();

  static bool pickupFocus = true;
  // static bool isLoading = true;
  String pickupText = '';
  String destinationText = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    initializeMap();
  }

  @override
  void dispose() {
    pickupController.dispose();
    destinationController.dispose();
    super.dispose();
  }

  Future<void> initializeMap() async {
    final location.Location locationController = location.Location();
    bool serviceEnabled;
    location.PermissionStatus permissionGranted;

    serviceEnabled = await locationController.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await locationController.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await locationController.hasPermission();
    if (permissionGranted == location.PermissionStatus.denied) {
      permissionGranted = await locationController.requestPermission();
      if (permissionGranted != location.PermissionStatus.granted) {
        return;
      }
    }

    locationController.onLocationChanged
        .listen((location.LocationData currentLocation) {
      if (currentLocation.latitude != null &&
          currentLocation.longitude != null) {
        setState(() {
          currentPosition =
              LatLng(currentLocation.latitude!, currentLocation.longitude!);
        });
      }
    });

    location.LocationData? initialLocation =
        await locationController.getLocation();
    if (initialLocation.latitude != null && initialLocation.longitude != null) {
      setState(() {
        currentPosition =
            LatLng(initialLocation.latitude!, initialLocation.longitude!);
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Google Maps View'),
      // ),
      body: isLoading
          ? Center(
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(
                  color: Colors.white,
                ),
                const SizedBox(height: 20),
                Text(
                  "Getting things ready...",
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      fontSize: 14),
                )
              ],
            ))
          : Stack(
              children: [
                GoogleMap(
                  myLocationEnabled: true,
                  // mapType: MapType.hybrid,
                  initialCameraPosition:
                      CameraPosition(target: currentPosition, zoom: 15),
                  onMapCreated: (GoogleMapController controller) {
                    _mapController = controller;
                  },
                  markers: _markers,
                  polylines: polylines.values.toSet(),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height *
                        0.9, // Set the height to 60% of the screen height
                    child: DraggableScrollableSheet(
                      snap: true,
                      expand: false,
                      initialChildSize: 0.5, // Initial size of the bottom sheet
                      minChildSize: 0.4, // Minimum size of the bottom sheet
                      maxChildSize: 0.6, // Maximum size of the bottom sheet
                      builder: (BuildContext context,
                          ScrollController scrollController) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 30),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(20)),
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  children: [
                                    TextField(
                                      controller: pickupController,
                                      onChanged: (value) {
                                        if (mounted) {
                                          setState(() {
                                            pickupText = value;
                                            pickupFocus = true;
                                          });
                                        }
                                        LocationService()
                                            .getLocationSuggestions(value)
                                            .then((value) => {
                                                  if (mounted)
                                                    {
                                                      setState(() {
                                                        locationSuggestions =
                                                            value;
                                                      })
                                                    }
                                                });
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
                                        if (mounted) {
                                          setState(() {
                                            destinationText = value;
                                            pickupFocus = false;
                                          });
                                        }
                                        LocationService()
                                            .getLocationSuggestions(value)
                                            .then((value) => {
                                                  if (mounted)
                                                    {
                                                      setState(() {
                                                        locationSuggestions =
                                                            value;
                                                      })
                                                    }
                                                });
                                      },
                                      decoration: const InputDecoration(
                                        hintText:
                                            'Enter destinationCoordinates location',
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
                                            await _searchLocation(
                                                destinationText);
                                        pickupLocationName = pickupText;
                                        destinationName = destinationText;

                                        logger.i(
                                            "The destination is $destinationCoordinates and the pickup is $pickupLocationCoordinates");
                                        // Update the markers on the map

                                        setState(() {
                                          _markers.clear();
                                          _markers.add(
                                            Marker(
                                              markerId:
                                                  const MarkerId('pickup'),
                                              position: LatLng(
                                                  pickupLocationCoordinates
                                                      .latitude,
                                                  pickupLocationCoordinates
                                                      .longitude),
                                              infoWindow: const InfoWindow(
                                                  title: 'Pickup'),
                                            ),
                                          );
                                          _markers.add(
                                            Marker(
                                              markerId:
                                                  const MarkerId('destination'),
                                              position: LatLng(
                                                  destinationCoordinates
                                                      .latitude,
                                                  destinationCoordinates
                                                      .longitude),
                                              infoWindow: const InfoWindow(
                                                  title: 'Destination'),
                                            ),
                                          );
                                        });

                                        // Fetch the polyline points between the pickup and destination locations
                                        _routes = await LocationService()
                                            .fetchPolylines(pickupLocationName,
                                                destinationName);

                                        // Generate the polyline on the map
                                        await generatePolyLineFromPoints(
                                            _routes);

                                        _mapController!.animateCamera(
                                            CameraUpdate.newLatLngBounds(
                                                LatLngBounds(
                                                  southwest: LatLng(
                                                      pickupLocationCoordinates
                                                          .latitude,
                                                      pickupLocationCoordinates
                                                          .longitude),
                                                  northeast: LatLng(
                                                      destinationCoordinates
                                                          .latitude,
                                                      destinationCoordinates
                                                          .longitude),
                                                ),
                                                50));

                                        // Animate the camera to fit the bounds of the markers and polylines

                                        animateToBounds(
                                            pickupLocationCoordinates,
                                            destinationCoordinates);
                                      },
                                      child: const Text('Get Directions'),
                                    ),
                                    const SizedBox(height: 16),
                                    if (locationSuggestions.isNotEmpty)
                                      Column(
                                        children: locationSuggestions
                                            .map((location) => ListTile(
                                                  leading: const Icon(
                                                      Icons.location_on),
                                                  title: Text(location),
                                                  onTap: () {
                                                    // Auto-fill the search bar with the selected location and search for it
                                                    if (mounted) {
                                                      setState(() {
                                                        if (pickupFocus) {
                                                          pickupText = location;
                                                          pickupController
                                                              .text = location;
                                                        } else {
                                                          destinationText =
                                                              location;
                                                          destinationController
                                                              .text = location;
                                                        }
                                                        locationSuggestions
                                                            .clear();
                                                      });
                                                    }
                                                  },
                                                ))
                                            .toList(),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  void drawRoutesOnMap(List<LatLng> routes) {
    logger.i("We have started drawing on the map");
    const polylineId = PolylineId('routes');
    final polyline = Polyline(
      polylineId: polylineId,
      color: Colors.blue,
      points: routes,
      width: 3,
    );
    setState(() {
      polylines[polylineId] = polyline;
    });

    logger.i("We are done drawing on the map");
  }

  void updateMap(LatLng pickupLocation, LatLng destinationLocation) {
    setState(() async {
      pickupLocationCoordinates = pickupLocation;
      destinationCoordinates = destinationLocation;
      _markers.clear();
      _markers.add(
        Marker(
          markerId: const MarkerId('pickup'),
          position: pickupLocationCoordinates,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          infoWindow: const InfoWindow(title: 'Pickup'),
        ),
      );
      _markers.add(
        Marker(
          markerId: const MarkerId('Current Location'),
          position: currentPosition,
          icon: await BitmapDescriptor.fromAssetImage(
              const ImageConfiguration(size: Size(48, 48)),
              'assets/customMarkerNew.png',
              mipmaps: true),
          infoWindow: const InfoWindow(title: 'My Location'),
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
      drawRoutesOnMap(_routes);
      animateToBounds(pickupLocationCoordinates, destinationCoordinates);
    });
  }

  // generatePolyLinefromPoints
  Future<void> generatePolyLineFromPoints(List<LatLng> polylinePoints) async {
    const id = PolylineId('polyline');
    final polyline = Polyline(
        polylineId: id,
        color: Colors.blueAccent,
        points: polylinePoints,
        width: 4);
    if (mounted) {
      setState(() {
        polylines[id] = polyline;
      });
    }

    logger.i("Done putting on the map");
  }

  Future<LatLng> _searchLocation(String location) async {
    try {
      logger.i("Getting location");
      // Get place details using the location name
      Map<String, dynamic> placeDetails =
          await LocationService().getPlace(location);
      // logger.i(placeDetails);

      // Extract coordinates from the place details
      Map<String, double> coordinates =
          LocationService().extractCoordinates(placeDetails);
      double latitude = coordinates["lat"]!;
      double longitude = coordinates["lng"]!;

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
    setState(() async {
      // Clear existing markers
      _markers.clear();

      // Add new markers for pickup and destinationCoordinates
      _markers.add(
        Marker(
          markerId: const MarkerId('pickup'),
          position: pickupLocationCoordinates,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          infoWindow: const InfoWindow(title: 'Pickup'),
        ),
      );
      _markers.add(
        Marker(
          markerId: const MarkerId('Current Location'),
          position: currentPosition,
          icon: await BitmapDescriptor.fromAssetImage(
              const ImageConfiguration(size: Size(48, 48)),
              'assets/customMarkerNew.png',
              mipmaps: true),
          infoWindow: const InfoWindow(title: 'My Location'),
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
    logger.i("Markers have been updated");
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

  void animateToBounds(LatLng pickup, LatLng destination) async {
    LatLngBounds bounds = LatLngBounds(
      southwest: LatLng(min(pickup.latitude, destination.latitude),
          min(pickup.longitude, destination.longitude)),
      northeast: LatLng(max(pickup.latitude, destination.latitude),
          max(pickup.longitude, destination.longitude)),
    );

    // Calculate padding to ensure markers are fully visible
    double padding = 50.0;

    _mapController
        ?.animateCamera(CameraUpdate.newLatLngBounds(bounds, padding));

    // Add markers for pickup and destination
    updateMarkers(pickup, destination);
  }
}
