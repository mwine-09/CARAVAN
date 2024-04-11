import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  Message({
    required this.senderID,
    required this.receiverID,
    required this.message,
    required this.createdAt,
  });

  String senderID;
  String receiverID;

  String message;

  Timestamp createdAt;

  // to map
  Map<String, dynamic> toMap() {
    return {
      'senderID': senderID,
      'receiverID': receiverID,
      'message': message,
      'createdAt': createdAt,
    };
  }

  Message copyWith({
    required String senderID,
    required String message,
    required Timestamp createdAt,
    required messageColor,
  }) =>
      Message(
        senderID: senderID,
        receiverID: receiverID,
        message: message,
        createdAt: createdAt,
      );

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        senderID: json["senderID"],
        receiverID: json["receiverID"],
        message: json["message"],
        createdAt: json["createdAt"],
      );

  Map<String, dynamic> toJson() => {
        "senderID": senderID,
        "receiverID": receiverID,
        "message": message,
        "createdAt": createdAt,
      };
}
