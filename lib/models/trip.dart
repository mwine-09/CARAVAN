import 'dart:convert';

import 'package:caravan/models/user_profile.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Trip {
  String? id;
  String? createdBy;
  String? location;
  String? destination;
  int? availableSeats;
  DateTime? dateTime;
  String? tripStatus;
  List<LatLng>? polylinePoints;
  UserProfile? driver;
  Trip({
    this.id,
    this.createdBy,
    this.location,
    this.destination,
    this.availableSeats,
    this.dateTime,
    this.tripStatus,
    this.polylinePoints,
    this.driver,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'createdBy': createdBy,
      'location': location,
      'destination': destination,
      'availableSeats': availableSeats,
      'dateTime': dateTime!.toIso8601String(),
      'tripStatus': tripStatus,
      'polylinePoints': polylinePoints!
          .map((point) =>
              {'latitude': point.latitude, 'longitude': point.longitude})
          .toList(),
    };
  }

  static Trip fromMap(Map<String, dynamic> map) {
    return Trip(
      id: map['id'],
      createdBy: map['createdBy'],
      location: map['location'],
      destination: map['destination'],
      availableSeats: map['availableSeats'],
      dateTime: DateTime.parse(map['dateTime']),
      tripStatus: map['tripStatus'],
      polylinePoints: (map['polylinePoints'] as List)
          .map((point) => LatLng(point['latitude'], point['longitude']))
          .toList(),
    );
  }

  String toJson() => json.encode(toMap());

  static Trip fromJson(String source) => fromMap(json.decode(source));
}
