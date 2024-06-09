import 'package:cloud_firestore/cloud_firestore.dart';

class History {
  final String type;
  final DateTime timestamp;
  final int amount;
  String? recepient;

  History({
    required this.type,
    required this.timestamp,
    required this.amount,
    this.recepient,
  });

  factory History.fromSnapshot(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return History(
      type: data['type'],
      timestamp: data['timestamp'].toDate(),
      amount: data['amount'],
      recepient: data['recepient'],
    );
  }
}
