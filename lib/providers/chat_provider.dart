import 'dart:async';
import 'dart:convert';
import 'package:caravan/models/chat_room.dart';
import 'package:caravan/models/message.dart';
import 'package:caravan/services/database_service.dart';
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
  StreamSubscription<QuerySnapshot>? _chatroomsSubscription;

  List<ChatRoom> get chatrooms {
    _chatrooms.sort((a, b) {
      return b.lastMessageTime.compareTo(a.lastMessageTime);
    });
    return _chatrooms;
  }

  void listenToChatrooms(String uid) {
    if (firebaseAuth.currentUser == null) {
      return;
    }

    final userID = uid;

    logger.d("Listening to chatrooms of $userID");

    _chatroomsSubscription?.cancel(); // Cancel any existing subscription

    _chatroomsSubscription = firebaseFirestore
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

      await Future.wait(_chatrooms.map((chatroom) async {
        try {
          List<String> userIds = chatroom.id.split('_');
          String senderID = userIds.firstWhere((id) => id != userID);

          logger.i('Getting username for $senderID');
          String username = await getUsername(senderID);
          logger.e('Got username for $senderID: $username');
          chatroom.title = username;

          String photoUrl =
              await DatabaseService().getUserProfilePictureUrl(senderID);
          chatroom.photoUrl = photoUrl;
        } catch (e) {
          logger.e('Error getting username: $e');
        }
      }));

      for (var chatRoom in _chatrooms) {
        await fetchMessages(chatRoom);
      }
      saveChatrooms();

      notifyListeners();
    }, onError: (error) {
      logger.e('Error listening to chatrooms: $error');
    });
  }

  ChatRoom getChatroom(String otherUserId) {
    logger.d('Getting chatroom with user ID: $otherUserId');

    final currentUserId = FirebaseAuth.instance.currentUser!.uid;

    List<String> userIds = [currentUserId, otherUserId];
    userIds.sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
    logger.i("Sorted user IDs: $userIds");

    String chatroomId = userIds.join('_');
    logger.d('Getting chatroom with ID: $chatroomId');
    notifyListeners();

    return _chatrooms.firstWhere(
      (chatroom) => chatroom.id == chatroomId,
      orElse: () => ChatRoom(
        id: '',
        lastMessage: '',
        lastMessageSenderID: '',
        members: [],
        lastMessageTime: Timestamp.now(),
        messages: [],
      ),
    );
  }

  bool hasChatroom(String otherUserId) {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;

    List<String> userIds = [currentUserId, otherUserId];
    userIds.sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));

    String chatroomId = userIds.join('_');

    return _chatrooms.any((chatroom) => chatroom.id == chatroomId);
  }

  Future<void> createChatroom(String otherUserId) async {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;

    List<String> userIds = [currentUserId, otherUserId];
    userIds.sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
    String chatroomId = userIds.join('_');

    await FirebaseFirestore.instance.collection('chats').doc(chatroomId).set({
      'members': userIds,
      'lastMessage': 'Send a message to chat!',
      'lastMessageSenderID': '',
      'lastMessageTime': Timestamp.now(),
    });
    notifyListeners();
  }

  void openChatroom(String chatRoomId) {
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
      List<Message> messages = querySnapshot.docs.map((doc) {
        return Message(
          senderID: doc["senderID"],
          receiverID: doc["receiverID"],
          message: doc["message"],
          createdAt: doc["createdAt"],
        );
      }).toList();
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

  Future<bool> checkChatroomExists(String chatRoomId) async {
    final snapshot =
        await firebaseFirestore.collection('chats').doc(chatRoomId).get();
    return snapshot.exists;
  }

  Stream<List<Message>> getMessagesStream(String chatRoomId) {
    logger.i('Getting messages for chatroom: $chatRoomId');
    notifyListeners();
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
    _chatroomsSubscription?.cancel(); // Cancel the chatrooms subscription
    _chatrooms = [];
    notifyListeners();
  }
}
