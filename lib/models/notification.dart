import 'package:cloud_firestore/cloud_firestore.dart';

class MyNotification {
  String? id;
  final String type;
  final String message;
  String? requestId;
  String status; // "read" or "unread"
  final DateTime timestamp;

  MyNotification(
      {this.id,
      required this.type,
      required this.message,
      required this.status,
      required this.timestamp,
      this.requestId});

  String? get getId => id;
  String? get getRequestId => requestId;
  String get getType => type;
  String get getMessage => message;
  String get getStatus => status;
  DateTime get getTimestamp => timestamp;

  factory MyNotification.fromDocument(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return MyNotification(
      id: doc.id,
      type: data['type'],
      message: data['message'],
      status: data['status'],
      timestamp: data['timestamp'].toDate(),
      requestId: data['requestId'],
    );
  }
}
