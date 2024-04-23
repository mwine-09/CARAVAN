import 'package:caravan/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRoom {
  final String id;
  String? title;
  final String lastMessage;
  final String lastMessageSenderID;
  final Timestamp lastMessageTime;
  final List<String> members;
  List<Message> messages;

  ChatRoom({
    required this.id,
    this.title,
    this.messages = const [],
    required this.lastMessage,
    required this.lastMessageSenderID,
    required this.lastMessageTime,
    required this.members,
  });

  set setMessages(List<Message> newMessages) {
    messages = newMessages;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'lastMessage': lastMessage,
      'lastMessageSenderID': lastMessageSenderID,
      'lastMessageTime': lastMessageTime.toDate().toIso8601String(),
      'members': members,
      'messages': messages.map((message) => message.toJson()).toList(),
    };
  }

  factory ChatRoom.fromJson(Map<String, dynamic> json) {
    return ChatRoom(
      id: json['id'],
      title: json['title'],
      lastMessage: json['lastMessage'],
      lastMessageSenderID: json['lastMessageSenderID'],
      lastMessageTime:
          Timestamp.fromDate(DateTime.parse(json['lastMessageTime'])),
      members: List<String>.from(json['members']),
      messages: List<Message>.from(
          json['messages'].map((message) => Message.fromJson(message))),
    );
  }
}
