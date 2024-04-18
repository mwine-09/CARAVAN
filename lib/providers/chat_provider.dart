import 'package:caravan/models/chat_room.dart';
import 'package:caravan/models/message.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';

final logger = Logger();

class ChatProvider with ChangeNotifier {
  final _firebaseAuth = FirebaseAuth.instance;
  final _firebaseFirestore = FirebaseFirestore.instance;
  List<ChatRoom> _chatrooms = [];

  List<ChatRoom> get chatrooms => _chatrooms;

  ChatProvider() {
    _listenToChatrooms();
  }

  void _listenToChatrooms() {
    final userID = _firebaseAuth.currentUser!.uid;

    _firebaseFirestore
        .collection('chats')
        .where('members', arrayContains: userID)
        .snapshots()
        .listen((querySnapshot) async {
      _chatrooms = querySnapshot.docs.map((doc) {
        return ChatRoom(
          id: doc.id,
          lastMessage: doc['lastMessage'],
          lastMessageSenderID: doc['lastMessageSenderID'],
          lastMessageTime: doc['lastMessageTime'],
          members: List<String>.from(doc['members']),
        );
      }).toList();

      // set the title of the chatroom to the username of the other user
      await Future.wait(_chatrooms.map((chatroom) async {
        try {
          List<String> userIds = chatroom.id.split('_');
          String senderID = userIds.firstWhere((id) => id != userID);

          logger.i('Getting username for $senderID');
          String username = await getUsername(senderID);
          logger.e('Got username for $senderID: $username');
          chatroom.title = username;
        } catch (e) {
          logger.e('Error getting username: $e');
        }
      }));

      // get messages for each chatroom

      for (var chatRoom in _chatrooms) {
        await fetchMessages(chatRoom);
      }

      notifyListeners();
    }, onError: (error) {
      logger.e('Error listening to chatrooms: $error');
    });
  }

  Future<String> getUsername(String userId) async {
    try {
      final snapshot =
          await _firebaseFirestore.collection('users').doc(userId).get();
      if (snapshot.exists) {
        return snapshot.data()!['username'];
      } else {
        return 'Unknown User';
      }
    } catch (e) {
      logger.e('Error getting username: $e');
      rethrow;
    }
  }

  Future<void> fetchMessages(ChatRoom chatRoom) async {
    try {
      final querySnapshot = await _firebaseFirestore
          .collection('chats')
          .doc(chatRoom.id)
          .collection('messages')
          .orderBy('timestamp', descending: true)
          .get();

      chatRoom.messages = querySnapshot.docs.map((doc) {
        return Message(
          senderID: doc["senderID"],
          receiverID: doc["receiverID"],
          message: doc["message"],
          createdAt: doc["createdAt"],
        );
      }).toList();
    } catch (e) {
      logger.e('Error fetching messages: $e');
      rethrow;
    }
  }
}
