import 'package:caravan/models/trip.dart';
import 'package:caravan/services/database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TripDetailsProvider extends ChangeNotifier {
  Trip? _tripDetails;
  final List<Trip> _availableTrips = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Trip? get tripDetails => _tripDetails;
  List<Trip> get availableTrips => _availableTrips;

  TripDetailsProvider() {
    DatabaseService().fetchTrips().listen((trips) {
      _availableTrips.clear();
      _availableTrips.addAll(trips);
      notifyListeners();
    });
  }

  void setTripDetails(Trip trip) {
    _tripDetails = trip;
    notifyListeners();
  }

  Future<void> updateTripStatus(String tripId, TripStatus status) async {
    await _firestore.collection('trips').doc(tripId).update({
      'tripStatus': status.toString().split('.').last,
      'statusTimestamp':
          DateTime.now().toIso8601String(), // Update timestamp to current time
    });

    // If _tripDetails is not null and matches the tripId, update its status locally
    if (_tripDetails != null && _tripDetails!.id == tripId) {
      _tripDetails!.tripStatus = status;
      _tripDetails!.statusTimestamp = DateTime.now();
    }

    notifyListeners();
  }

  Future<void> scheduleTrip(String tripId) async {
    await updateTripStatus(tripId, TripStatus.scheduled);
  }

  Future<void> confirmTrip(String tripId) async {
    await updateTripStatus(tripId, TripStatus.confirmed);
  }

  Future<void> startTrip(String tripId) async {
    await updateTripStatus(tripId, TripStatus.started);
  }

  Future<void> completeTrip(String tripId) async {
    await updateTripStatus(tripId, TripStatus.completed);
  }

  Future<void> cancelTrip(String tripId) async {
    await updateTripStatus(tripId, TripStatus.cancelled);
  }
}
