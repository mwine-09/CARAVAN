import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String senderID;
  String receiverID;

  String message;

  Timestamp createdAt;
  Message({
    required this.senderID,
    required this.receiverID,
    required this.message,
    required this.createdAt,
  });
  // Getters
  String get getSenderID => senderID;
  String get getReceiverID => receiverID;
  String get getMessage => message;
  Timestamp get getCreatedAt => createdAt;

  // Setters
  set setSenderID(String senderID) => this.senderID = senderID;
  set setReceiverID(String receiverID) => this.receiverID = receiverID;
  set setMessage(String message) => this.message = message;
  set setCreatedAt(Timestamp createdAt) => this.createdAt = createdAt;

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

  factory Message.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return Message(
      senderID: data['senderID'],
      receiverID: data['receiverID'],
      message: data['message'],
      createdAt: data['createdAt'],
    );
  }
}
