import 'package:google_maps_flutter/google_maps_flutter.dart';

class TripRequest {
  String? source;
  String? destination;
  DateTime? departureTime;
  int? numberOfPassengers;
  LatLng? destinationCoordinates;
  LatLng? pickupCoordinates;

  TripRequest({
    this.source,
    this.destination,
    this.departureTime,
    this.numberOfPassengers,
    this.destinationCoordinates,
    this.pickupCoordinates,
  });
}
