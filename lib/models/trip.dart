import 'dart:convert';
import 'package:caravan/models/request.dart';
import 'package:caravan/models/user_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// Enum for Trip Status
enum TripStatus {
  scheduled,
  confirmed,
  started,
  completed,
  cancelled,
}

class Trip {
  String? id;
  String? createdBy;
  String? location;
  String? destination;
  int? availableSeats;
  DateTime? dateTime;
  TripStatus? tripStatus;
  DateTime? statusTimestamp;
  List<LatLng>? polylinePoints;
  UserProfile? driver;
  List<Request>? requests;
  List<UserProfile>? passengers;

  LatLng? destinationCoordinates;
  LatLng? pickupCoordinates;

  Trip(
      {this.id,
      this.createdBy,
      this.location,
      this.destination,
      this.availableSeats,
      this.dateTime,
      this.tripStatus,
      this.statusTimestamp,
      this.destinationCoordinates,
      this.pickupCoordinates,
      this.polylinePoints,
      this.requests,
      this.driver,
      this.passengers});

  // Getters for the fields
  String? get getId => id;
  String? get getCreatedBy => createdBy;
  String? get getLocation => location;
  String? get getDestination => destination;
  int? get getAvailableSeats => availableSeats;
  DateTime? get getDateTime => dateTime;
  TripStatus? get getTripStatus => tripStatus;
  DateTime? get getStatusTimestamp => statusTimestamp;
  List<LatLng>? get getPolylinePoints => polylinePoints;
  UserProfile? get getDriver => driver;
  List<Request>? get getRequests => requests;
  List<UserProfile>? get getPassengers => passengers;
  LatLng? get getDestinationCoordinates => destinationCoordinates;
  LatLng? get getPickupCoordinates => pickupCoordinates;
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'createdBy': createdBy,
      'location': location,
      'destination': destination,
      'passengers': passengers,
      'availableSeats': availableSeats,
      'dateTime': dateTime?.toIso8601String(),
      'tripStatus':
          tripStatus?.toString().split('.').last, // Convert enum to string
      'statusTimestamp': statusTimestamp?.toIso8601String(),
      'polylinePoints': polylinePoints
          ?.map((point) =>
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
      // passengers: map['passengers'],
      dateTime: DateTime.parse(map['dateTime']),
      tripStatus: TripStatus.values
          .firstWhere((e) => e.toString() == 'TripStatus.${map['tripStatus']}'),
      statusTimestamp: DateTime.parse(map['statusTimestamp']),
      polylinePoints: (map['polylinePoints'] as List)
          .map((point) => LatLng(point['latitude'], point['longitude']))
          .toList(),
    );
  }

  factory Trip.fromDocument(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Trip(
      id: data['id'],
      createdBy: data['createdBy'],
      location: data['location'],
      destination: data['destination'],
      availableSeats: data['availableSeats'],
      dateTime: DateTime.parse(data['dateTime']),
      tripStatus: TripStatus.values.firstWhere(
          (e) => e.toString() == 'TripStatus.${data['tripStatus']}'),
      statusTimestamp: DateTime.parse(data['statusTimestamp']),
      polylinePoints: (data['polylinePoints'] as List)
          .map((point) => LatLng(point['latitude'], point['longitude']))
          .toList(),
    );
  }

  @override
  String toString() {
    return 'Trip(id: $id, createdBy: $createdBy, location: $location, destination: $destination, availableSeats: $availableSeats, dateTime: $dateTime, tripStatus: $tripStatus, statusTimestamp: $statusTimestamp, destinationCoordinates: $destinationCoordinates, pickupCoordinates: $pickupCoordinates, polylinePoints: $polylinePoints, driver: $driver, requests: $requests)';
  }

  List<String> getNullFields() {
    List<String> nullFields = [];
    if (id == null) nullFields.add('id');
    if (createdBy == null) nullFields.add('createdBy');
    if (location == null) nullFields.add('location');
    if (destination == null) nullFields.add('destination');
    if (availableSeats == null) nullFields.add('availableSeats');
    if (dateTime == null) nullFields.add('dateTime');
    if (tripStatus == null) nullFields.add('tripStatus');
    if (statusTimestamp == null) nullFields.add('statusTimestamp');
    if (destinationCoordinates == null) {
      nullFields.add('destinationCoordinates');
    }
    if (pickupCoordinates == null) nullFields.add('pickupCoordinates');
    if (polylinePoints == null) nullFields.add('polylinePoints');
    if (driver == null) nullFields.add('driver');
    if (requests == null) nullFields.add('requests');
    return nullFields;
  }

  String toJson() => json.encode(toMap());

  static Trip fromJson(String source) => fromMap(json.decode(source));
}
