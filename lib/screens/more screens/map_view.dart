import 'dart:async';

import 'package:caravan/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:location/location.dart' as location;
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:caravan/services/location_service.dart';

class GoogleMapsView extends StatefulWidget {
  const GoogleMapsView({super.key});

  @override
  State<GoogleMapsView> createState() => _GoogleMapsViewState();
}

class _GoogleMapsViewState extends State<GoogleMapsView> {
  final location.Location locationController1 = location.Location();
  static const googlePlex = LatLng(0.3254716, 32.5665353);

  // varible to hold the destination
  static var destination = const LatLng(-0.6934700, 30.3019000);

  LatLng? currentPosition;
  String? searchText;
  List<String> locationSuggestions = [];

  Map<PolylineId, Polyline> polylines = {};
  Future<dynamic> getLocationSuggestion(String query) async {
    var key = LocationService().key;
    var url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$query&key=$key');

    var response = await http.get(url);

    if (response.statusCode == 200) {
      final places = json.decode(response.body);

      // var result = {
      //   'places_prediction1': places['predictions'][0]['description'],
      //   'places_prediction2': places['predictions'][1]['description'],
      //   'places_prediction3': places['predictions'][2]['description'] ?? '',
      //   'places_prediction4': places['predictions'][3]['description'] ?? '',
      // };
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
    final coordinates = await fetchPolylinePoints();
    generatePolyLineFromPoints(coordinates);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: googlePlex,
              zoom: 10,
            ),
            markers: {
              const Marker(
                markerId: MarkerId('marker_1'),
                position: googlePlex,
              ),
              const Marker(
                  markerId: MarkerId('marker_2'), position: googlePlex),
              Marker(
                  markerId: const MarkerId('marker_3'), position: destination),
            },
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
            child: SizedBox(
                height: 300,
                width: double.infinity,
                child: Container(
                  // round the top two corners
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),

                  padding: const EdgeInsets.all(8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: SizedBox(
                      height: 120,
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 50, 50, 50),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          children: [
                            const SizedBox(height: 10),
                            const Text(
                              'Enter your destination',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                leadingDistribution:
                                    TextLeadingDistribution.even,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            SizedBox(
                              height: 50,
                              width: 280,
                              child: TextField(
                                onChanged: (value) {
                                  setState(() {
                                    searchText = value;
                                  });
                                },
                                decoration: const InputDecoration(
                                  // text color is whitE

                                  hintText: 'Enter a location',
                                  hintStyle: TextStyle(color: Colors.white),
                                  border: OutlineInputBorder(),
                                  // prefix with a car icon
                                  prefixIcon:
                                      Icon(Icons.search, color: Colors.white),
                                ),
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                            const SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _searchLocation(searchText!);
                                  print(searchText! + " was searched");
                                });
                              },
                              child: const Text('Search'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )),
          )
        ],
      ),
    );
  }

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

  Future<List<LatLng>> fetchPolylinePoints() async {
    final polylinePoints = PolylinePoints();
    final result = await polylinePoints.getRouteBetweenCoordinates(
      googleMapsApiKey,
      PointLatLng(googlePlex.latitude, googlePlex.longitude),
      PointLatLng(destination.latitude, destination.longitude),
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

  void _searchLocation(String location) async {
    try {
      List<Location> locations = await locationFromAddress(location);
      if (locations.isNotEmpty) {
        Location firstLocation = locations.first;
        double latitude = firstLocation.latitude;
        double longitude = firstLocation.longitude;
        setState(() {
          destination = LatLng(latitude, longitude);

          //refresh the map
          initializeMap();
        });

        print(latitude);
        print(longitude);

        // Use the latitude and longitude to update the map markers

        // For example, set the end point marker to the new location
      } else {
        // Handle case where no location was found
        print("Location was not found");
      }
    } catch (e) {
      // Handle any errors that occur during geocoding
      print("Mwine error occurred while searching for location");
      print(e);
    }
  }
}
