import 'dart:async';

import 'package:caravan/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:location/location.dart' as location;
import 'package:caravan/services/location_service.dart';
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
            // child is a modal for searching for destination locations
            child: Container(
              padding: const EdgeInsets.all(10),
              color: Colors.white,
              child: Column(
                children: [
                  TextField(
                    onChanged: (value) {
                      setState(() {
                        searchText = value;
                      });
                      getLocationSuggestion(value);
                    },
                    decoration: const InputDecoration(
                      hintText: 'Search for a location',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  if (locationSuggestions.isNotEmpty)
                    Column(
                      children: locationSuggestions
                          .map((location) => ListTile(
                                title: Text(location),
                                onTap: () {
                                  // auto fill the search bar with the selected location and search for it
                                  setState(() {
                                    searchText = location;
                                  });
                                  _searchLocation(location);

                                  print("The search text is $searchText");

                                  setState(() {
                                    locationSuggestions.clear();
                                  });

                                  // close the modal
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
      // Get place details using the location name
      Map<String, dynamic> placeDetails =
          await LocationService().getPlace(location);

      LocationService().getDirection('Kampala', 'Kigali, Rwanda');

      // Extract coordinates from the place details
      Map<String, double> coordinates =
          LocationService().extractCoordinates(placeDetails);
      double? latitude = coordinates["lat"];
      double? longitude = coordinates["lng"];

      // Update the destination with the new coordinates
      setState(() {
        destination = LatLng(latitude!, longitude!);

        // Refresh the map
        initializeMap();
      });

      print("Latitude: $latitude, Longitude: $longitude");

      // Use the latitude and longitude to update the map markers
      // For example, set the end point marker to the new location
    } catch (e) {
      // Handle any errors that occur during the search
      print("An error occurred while searching for location");
      print(e);
    }
  }
}
