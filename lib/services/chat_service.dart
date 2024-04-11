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

    List<String> ids = [senderID, receiverID];
    ids.sort();
    String chatID = ids.join('_');

    return _firebaseFirestore
        .collection('chats')
        .doc(chatID)
        .collection('messages')
        .orderBy('createdAt')
        .snapshots();
  }

Stream<List<ChatRoom>> getChatRoomsForUser() {
  final userID = _firebaseAuth.currentUser!.uid;

  return _firebaseFirestore
      .collection('chats')
      .where('members', arrayContains: userID)
      .snapshots()
      .map((querySnapshot) => querySnapshot.docs.map((doc) {
            List<String> members = List<String>.from(doc['members']);
            members.remove(userID); // Remove current user from the list of members
            String title =
                members.join(', '); // Return the remaining member as the title

            return ChatRoom(
              id: doc.id,
              title: title,
              lastMessage: doc['lastMessage'] ?? 'No messages',
            );
          }).toList());
}

}
