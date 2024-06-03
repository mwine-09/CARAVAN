import 'dart:convert';

import 'package:caravan/models/user_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  List<Request>? requests;
  Trip({
    this.id,
    this.createdBy,
    this.location,
    this.destination,
    this.availableSeats,
    this.dateTime,
    this.tripStatus,
    this.polylinePoints,
    this.requests,
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
      requests: map['requests'],
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

class Request {
  String? tripId;
  String? passengerId;
  String? status; // 'pending', 'accepted', 'declined'
  // other request details
  DateTime? timestamp;

  Request({this.tripId, this.passengerId, this.status, this.timestamp
      // other request details
      });

  factory Request.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Request(
        tripId: data['tripId'],
        passengerId: data['passengerId'],
        status: data['status'],
        timestamp: data['timestamp']
        // other request details
        );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'tripId': tripId,
      'passengerId': passengerId,
      'status': status,
      'timestamp': timestamp
      // other request details
    };
  }
}
