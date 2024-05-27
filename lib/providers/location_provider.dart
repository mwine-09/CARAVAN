import 'package:caravan/services/location_service.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as location;
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;

class LocationProvider with ChangeNotifier {
  final location.Location locationController = location.Location();
  LatLng? _currentPosition;
  String? _currentPositionName;
  LocationService locationService =
      LocationService.getInstance() as LocationService;

  LatLng? get currentPosition => _currentPosition;
  String? get currentPositionName => _currentPositionName;

  void setCurrentPositionName(String newName) {
    _currentPositionName = newName;
    notifyListeners();
  }

  LocationProvider() {
    _initLocationUpdates();
    _configureBackgroundGeolocation();
  }

  Future<void> _initLocationUpdates() async {
    try {
      await _enableLocationService();
      await _requestPermission();

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
      if (initialLocation.latitude != null &&
          initialLocation.longitude != null) {
        _updateCurrentPosition(
          LatLng(initialLocation.latitude!, initialLocation.longitude!),
        );
      }
    } catch (e) {
      print('Error initializing location updates: $e');
      // Handle the error as appropriate in your app
    }
  }

  Future<bool> _isLocationServiceEnabled() async {
    return await locationController.serviceEnabled();
  }

  Future<void> _enableLocationService() async {
    bool serviceEnabled = await _isLocationServiceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await locationController.requestService();
      if (!serviceEnabled) {
        throw Exception('Location service is disabled.');
      }
    }
  }

  Future<bool> _isPermissionGranted() async {
    location.PermissionStatus permission =
        await locationController.hasPermission();
    return permission == location.PermissionStatus.granted;
  }

  Future<void> _requestPermission() async {
    bool permissionGranted = await _isPermissionGranted();
    if (!permissionGranted) {
      location.PermissionStatus permission =
          await locationController.requestPermission();
      if (permission != location.PermissionStatus.granted) {
        throw Exception('Location permissions are denied');
      }
    }
  }

  void _updateCurrentPosition(LatLng newPosition) async {
    _currentPosition = newPosition;
    _currentPositionName = await locationService.getPlaceName(
        newPosition.latitude, newPosition.longitude);
    notifyListeners();
  }

// background location updates

  void _configureBackgroundGeolocation() {
    bg.BackgroundGeolocation.onLocation((bg.Location location) {
      print('[location] - $location');
      _updateCurrentPosition(
        LatLng(location.coords.latitude, location.coords.longitude),
      );
    });

    bg.BackgroundGeolocation.onMotionChange((bg.Location location) {
      print('[motionchange] - $location');
      _updateCurrentPosition(
        LatLng(location.coords.latitude, location.coords.longitude),
      );
    });

    bg.BackgroundGeolocation.ready(bg.Config(
      desiredAccuracy: bg.Config.DESIRED_ACCURACY_HIGH,
      distanceFilter: 10.0,
      stopOnTerminate: false,
      startOnBoot: true,
      debug: true,
      logLevel: bg.Config.LOG_LEVEL_VERBOSE,
      reset: true,
    ));
  }

  void startBackgroundGeolocation() {
    bg.BackgroundGeolocation.start();
  }

  void stopBackgroundGeolocation() {
    bg.BackgroundGeolocation.stop();
  }
}
