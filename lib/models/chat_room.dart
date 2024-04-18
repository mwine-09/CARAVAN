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
}
