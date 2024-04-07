import 'package:caravan/models/trip.dart';
import 'package:flutter/material.dart';

class TripDetailsProvider extends ChangeNotifier {
  Trip? _tripDetails;

  Trip? get tripDetails => _tripDetails;

  void setTripDetails(Trip trip) {
    _tripDetails = trip;
    notifyListeners();
  }
}
