import 'package:caravan/models/trip.dart';
import 'package:caravan/providers/chat_provider.dart';
import 'package:caravan/services/database_service.dart';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmaps;

class TripDetailsProvider extends ChangeNotifier {
  Trip? _tripDetails;
  final List<Trip> _availableTrips = [];

  Set<gmaps.Polyline>? onGoingTripPolylines;

  set onGoingTripPolylinesSet(Set<gmaps.Polyline> polylines) {
    onGoingTripPolylines = polylines;
    notifyListeners();
  }

  Set<gmaps.Polyline>? get onGoingTripPolylineSet => onGoingTripPolylines;

  Trip? get tripDetails => _tripDetails;
  List<Trip> get availableTrips => _availableTrips;

  TripDetailsProvider() {
    logger.i("TripDetailsProvider initialized");
    initializeTripsListener();
  }

  void initializeTripsListener() {
    logger.i("Listening for trips");
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
    DatabaseService().updateTripStatus(tripId, status);

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

  void reset() {
    _tripDetails = null;
  }
}
