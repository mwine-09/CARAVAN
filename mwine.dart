import 'dart:async';

import 'package:caravan/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class GoogleMapsView extends StatefulWidget {
  const GoogleMapsView({super.key});

  @override
  State<GoogleMapsView> createState() => _GoogleMapsViewState();
}

class _GoogleMapsViewState extends State<GoogleMapsView> {
  final locationController = Location();
  static const googlePlex = LatLng(0.3254716, 32.5665353);
  static const destination = LatLng(-0.6934700, 30.3019000);

  LatLng? currentPosition;

  Map<PolylineId, Polyline> polylines = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) async => await initializeMap());
  }

// initialise map method
  Future<void> initializeMap() async {
    await fetchLocationUpdates();
    print("The current position is $currentPosition");
    final coordinates = await fetchPolylinePoints();
    generatePolyLineFromPoints(coordinates);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: const CameraPosition(
          target: googlePlex,
          zoom: 10,
        ),
        markers: {
          Marker(
              markerId: const MarkerId('marker_1'),
              position: currentPosition ?? googlePlex),
          const Marker(markerId: MarkerId('marker_2'), position: googlePlex),
          const Marker(markerId: MarkerId('marker_2'), position: destination),
        },
        polylines: Set<Polyline>.of(polylines.values),
// CameraPosition
      ), // GoogleMap
    );
  }

  Future<void> fetchLocationUpdates() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;
    print("Fetch location is running");
    serviceEnabled = await locationController.serviceEnabled();
    print(serviceEnabled);
    if (!serviceEnabled) {
      serviceEnabled = await locationController.requestService();
      print("Service is enabled now");
    } else {
      return;
    }

    permissionGranted = await locationController.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await locationController.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    locationController.onLocationChanged.listen((LocationData currentLocation) {
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
}
