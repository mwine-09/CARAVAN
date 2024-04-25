import 'package:flutter/material.dart';

import 'package:caravan/services/location_service.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:location/location.dart' as location;

class LocationProvider with ChangeNotifier {
  final locationController = location.Location();
  LatLng? _currentPosition;
  String? _currentPositionName;
  bool _isLoading = true;

  LatLng? get currentPosition => _currentPosition;
  String? get currentPositionName => _currentPositionName;
  bool get isLoading => _isLoading;

  void setCurrentPositionName(String newName) {
    _currentPositionName = newName;
    notifyListeners();
  }

  LocationProvider() {
    _initLocationUpdates();
  }

  Future<void> _initLocationUpdates() async {
    logger.i('Initializing location updates');
    var permissionGranted = await locationController.hasPermission();
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
        _updateCurrentPosition(
          LatLng(currentLocation.latitude!, currentLocation.longitude!),
        );
      }
    });

    location.LocationData? initialLocation =
        await locationController.getLocation();
    if (initialLocation.latitude != null && initialLocation.longitude != null) {
      _updateCurrentPosition(
        LatLng(initialLocation.latitude!, initialLocation.longitude!),
      );
    }
  }

  void _updateCurrentPosition(LatLng newPosition) async {
    _currentPosition = newPosition;
    logger.i('Current Position: $_currentPosition');
    _currentPositionName = await LocationService()
        .getPlaceName(newPosition.latitude, newPosition.longitude);
    _isLoading = false;
    notifyListeners();
  }
}
