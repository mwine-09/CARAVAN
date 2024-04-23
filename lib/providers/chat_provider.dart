import 'dart:convert';

import 'package:caravan/models/chat_room.dart';
import 'package:caravan/models/message.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

final logger = Logger();

class ChatProvider with ChangeNotifier {
  static final firebaseAuth = FirebaseAuth.instance;
  static final firebaseFirestore = FirebaseFirestore.instance;
  static List<ChatRoom> _chatrooms = [];

  List<ChatRoom> get chatrooms {
    _chatrooms.sort((a, b) {
      return b.lastMessageTime.compareTo(a.lastMessageTime);
    });
    return _chatrooms;
  }

  void listenToChatrooms(String uid) {
    final userID = uid;

    firebaseFirestore
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
      saveChatrooms();

      notifyListeners();
    }, onError: (error) {
      logger.e('Error listening to chatrooms: $error');
    });
  }

  void stopListeningToChatrooms() {
    _chatrooms = [];
    notifyListeners();
  }

  ChatRoom? getChatroom(String otherUserId) {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;

    // Sort the user IDs
    List<String> userIds = [currentUserId, otherUserId];
    userIds.sort();

    // Join the user IDs with an underscore to create the chatroom ID
    String chatroomId = userIds.join('_');
    logger.i('Getting chatroom with ID: $chatroomId');

    // Find the chatroom in the list of chatrooms
    return _chatrooms.firstWhere((chatroom) => chatroom.id == chatroomId,
        orElse: () => ChatRoom(
            id: '',
            lastMessage: '',
            lastMessageSenderID: '',
            members: [],
            lastMessageTime: Timestamp.now(),
            messages: []));
  }

  bool hasChatroom(String otherUserId) {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;

    // Sort the user IDs
    List<String> userIds = [currentUserId, otherUserId]..sort();

    // Join the user IDs with an underscore to create the chatroom ID
    String chatroomId = userIds.join('_');

    // Check if the chatroom exists in the list of chatrooms
    return _chatrooms.any((chatroom) => chatroom.id == chatroomId);
  }

  Future<void> createChatroom(String otherUserId) async {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;

    // Sort the user IDs
    List<String> userIds = [currentUserId, otherUserId]..sort();

    // Join the user IDs with an underscore to create the chatroom ID
    String chatroomId = userIds.join('_');

    await firebaseFirestore.collection('chats').doc(chatroomId).set({
      'members': userIds,
      'lastMessage': 'Send a message to chat!',
      'lastMessageSenderID': '',
      'lastMessageTime': Timestamp.now(),
    });
  }

  void openChatroom(String chatRoomId) {
    // Start listening for new messages in the chatroom
    _listenToMessages(chatRoomId);
    logger.e('Opening chatroom: $chatRoomId');
  }

  void _listenToMessages(String chatRoomId) {
    firebaseFirestore
        .collection('chats')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .listen((querySnapshot) {
      // Handle the received messages
      List<Message> messages = querySnapshot.docs.map((doc) {
        return Message(
          senderID: doc["senderID"],
          receiverID: doc["receiverID"],
          message: doc["message"],
          createdAt: doc["createdAt"],
        );
      }).toList();
      // Update the chatroom's messages
      ChatRoom chatRoom =
          _chatrooms.firstWhere((chatroom) => chatroom.id == chatRoomId);
      chatRoom.messages = messages;
      notifyListeners();
    }, onError: (error) {
      logger.e('Error listening to messages: $error');
    });
  }

  Future<String> getUsername(String userId) async {
    try {
      final snapshot =
          await firebaseFirestore.collection('users').doc(userId).get();
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
      final querySnapshot = await firebaseFirestore
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

  Stream<List<Message>> getMessagesStream(String chatRoomId) {
    logger.i('Getting messages for chatroom: $chatRoomId');
    return firebaseFirestore
        .collection('chats')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('createdAt')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Message.fromDocumentSnapshot(doc);
      }).toList();
    });
  }

  String getOtherUserId(String chatId) {
    final userId = firebaseAuth.currentUser!.uid;
    List<String> userIds = chatId.split('_');
    return userIds.firstWhere((id) => id != userId);
  }

  Future<void> saveChatrooms() async {
    logger.e("Saving chatrooms to shared preferences  ");
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('chatrooms',
        jsonEncode(_chatrooms.map((chatroom) => chatroom.toJson()).toList()));

    logger.e("Done saving chatrooms to shared preferences");
  }

  Future<void> loadChatrooms(String uid) async {
    logger.e('Loading chatrooms from shared preferences');
    listenToChatrooms(uid);
    final prefs = await SharedPreferences.getInstance();
    String? chatroomsString = prefs.getString('chatrooms');
    if (chatroomsString != null) {
      _chatrooms = (jsonDecode(chatroomsString) as List)
          .map((i) => ChatRoom.fromJson(i))
          .toList();

      for (var chatroom in _chatrooms) {
        logger.i(
            'Chatroom: ${chatroom.id} ${chatroom.lastMessage} ${chatroom.lastMessageSenderID} ${chatroom.lastMessageTime} ${chatroom.members} ${chatroom.messages}');
      }

      logger.e('Chatrooms loaded from shared preferences: $_chatrooms');
      notifyListeners();
    }
  }

  void reset() {
    _chatrooms = [];

    notifyListeners();
  }
}
