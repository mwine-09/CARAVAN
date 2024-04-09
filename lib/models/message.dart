import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  Message({
    required this.id,
    required this.text,
    required this.createdAt,
    required this.isMe,
  });

  String id;
  String? text;

  Timestamp createdAt;
  bool isMe;

  Message copyWith({
    required String id,
    String? text,
    required Timestamp createdAt,
    required bool isMe,
    required textColor,
  }) =>
      Message(
        id: id,
        text: text,
        isMe: isMe,
        createdAt: createdAt,
      );

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        id: json["id"],
        text: json["text"],
        isMe: json["isMe"],
        createdAt: json["createdAt"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "text": text,
        "isMe": isMe,
        "createdAt": createdAt,
      };
}
