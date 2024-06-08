import 'dart:async';
import 'package:geolocator/geolocator.dart';

class TripService {
  StreamSubscription<Position>? _positionStreamSubscription;

  void startLocationUpdates(Function(Position) onLocationUpdate) {
    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10, // Minimum distance (in meters) for updates
    );

    _positionStreamSubscription = Geolocator.getPositionStream(
      locationSettings: locationSettings,
    ).listen((Position position) {
      // This function will be called whenever the location changes
      onLocationUpdate(position);

      // Update the location to Firestore or any other storage as needed
      updateLocationInFirestore(position);
    });
  }

  void stopLocationUpdates() {
    _positionStreamSubscription?.cancel();
  }

  Future<void> updateLocationInFirestore(Position position) async {
    // Implement your Firestore update logic here
    // For example:
    // await FirebaseFirestore.instance.collection('users').doc(userId).update({
    //   'currentLocation': GeoPoint(position.latitude, position.longitude),
    // });
  }
}
