import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

enum RequestStatus {
  pending,
  accepted,
  declined,
}

class Request {
  String? tripId;
  String? passengerId;
  String? driverId;
  RequestStatus? status;
  DateTime? timestamp;
  LatLng? pickupCoordinates;
  String? pickupLocationName;
  LatLng? destinationCoordinates;
  String? destinationLocationName;

  Request({
    this.tripId,
    this.passengerId,
    this.driverId,
    this.status,
    this.timestamp,
    this.pickupCoordinates,
    this.pickupLocationName,
    this.destinationCoordinates,
    this.destinationLocationName,
  });

  factory Request.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Request(
      tripId: data['tripId'],
      passengerId: data['passengerId'],
      driverId: data['driverId'],
      status: _parseStatus(data['status']),
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      pickupCoordinates: data['pickupCoordinates'] != null
          ? LatLng(data['pickupCoordinates']['latitude'],
              data['pickupCoordinates']['longitude'])
          : null,
      pickupLocationName: data['pickupLocationName'],
      destinationCoordinates: data['destinationCoordinates'] != null
          ? LatLng(data['destinationCoordinates']['latitude'],
              data['destinationCoordinates']['longitude'])
          : null,
      destinationLocationName: data['destinationLocationName'],
    );
  }
  List<String> getNullFields() {
    List<String> nullFields = [];
    if (tripId == null) nullFields.add('tripId');
    if (passengerId == null) nullFields.add('passengerId');
    if (driverId == null) nullFields.add('driverId');
    if (status == null) nullFields.add('status');
    if (timestamp == null) nullFields.add('timestamp');
    if (pickupCoordinates == null) nullFields.add('pickupCoordinates');
    if (pickupLocationName == null) nullFields.add('pickupLocationName');
    if (destinationCoordinates == null) {
      nullFields.add('destinationCoordinates');
    }
    if (destinationLocationName == null) {
      nullFields.add('destinationLocationName');
    }
    return nullFields;
  }

  Map<String, dynamic> toFirestore() {
    return {
      'tripId': tripId,
      'passengerId': passengerId,
      'status': status?.toString().split('.').last,
      'timestamp': timestamp,
      'pickupCoordinates': pickupCoordinates != null
          ? {
              'latitude': pickupCoordinates!.latitude,
              'longitude': pickupCoordinates!.longitude,
            }
          : null,
      'pickupLocationName': pickupLocationName,
      'destinationCoordinates': destinationCoordinates != null
          ? {
              'latitude': destinationCoordinates!.latitude,
              'longitude': destinationCoordinates!.longitude,
            }
          : null,
      'destinationLocationName': destinationLocationName,
    };
  }

  static RequestStatus? _parseStatus(String? status) {
    if (status == null) return null;
    return RequestStatus.values.firstWhere(
        (e) => e.toString().toLowerCase() == 'requeststatus.$status');
  }
}
