import 'package:caravan/models/chat_room.dart';
import 'package:caravan/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatService extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<void> sendMessage(String receiverID, String messageContent) async {
    final senderID = _firebaseAuth.currentUser!.uid;
    final Timestamp timestamp = Timestamp.now();

    Message message = Message(
      senderID: senderID,
      receiverID: receiverID,
      message: messageContent,
      createdAt: timestamp,
    );

    List<String> ids = [senderID, receiverID];
    ids.sort();
    String chatID = ids.join('_');
    print("$senderID is sending a message to $receiverID");

    print("We are adding a message to $chatID");

    try {
      // Add the message to the chat
      await _firebaseFirestore
          .collection('chats')
          .doc(chatID)
          .collection('messages')
          .add(message.toMap());

      // Update the chat document with the last message information
      await _firebaseFirestore.collection('chats').doc(chatID).set({
        'members':
            FieldValue.arrayUnion(ids), // Add members if they don't exist
        'lastMessage': messageContent,
        'lastMessageSenderID': senderID,
        'lastMessageTime': timestamp,
      }, SetOptions(merge: true)); // Merge the new data with existing data
    } catch (e) {
      print(e);
    }
  }

  Stream<QuerySnapshot> getMessages(String receiverID) {
    final senderID = _firebaseAuth.currentUser!.uid;

    print("The receiver id is $receiverID");
    print("The sender id is $senderID");

    List<String> ids = [senderID, receiverID];
    ids.sort();
    print("This the list of the $ids"); // Debugging (Optional
    String chatID = ids.join('_');
    print("Getting messages for chatroom $chatID");

    return _firebaseFirestore
        .collection('chats')
        .doc(chatID)
        .collection('messages')
        .orderBy('createdAt')
        .snapshots();
  }

  Stream<List<ChatRoom>> getChatRoomsForUser() {
    final userID = _firebaseAuth.currentUser!.uid;
    print("getting chat rooms for user id $userID");

    return _firebaseFirestore
        .collection('chats')
        .where('members', arrayContains: userID)
        .snapshots()
        .map((querySnapshot) => querySnapshot.docs.map((doc) {
              List<String> members = List<String>.from(doc['members']);
              members.remove(
                  userID); // Remove current user from the list of members
              String title = members
                  .join(', '); // Return the remaining member as the title

              return ChatRoom(
                id: doc.id,
                title: title,
                lastMessage: doc['lastMessage'] ?? 'No messages',
              );
            }).toList());
  }

  Future getUsername(String userId) {
    return _firebaseFirestore
        .collection('users')
        .doc(userId)
        .get()
        .then((snapshot) {
      if (snapshot.exists) {
        return snapshot.data()!['username'];
      } else {
        return 'Unknown User';
      }
    }).catchError((e) {
      print('Error getting username: $e');
      throw e;
    });
  }
}
