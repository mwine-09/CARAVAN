import 'package:caravan/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatService extends ChangeNotifier {
// get current user from firebase

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

// send a message
  Future<void> sendMessage(String receiverID, String messageContent) async {
    // get the current user id
    final senderID = _firebaseAuth.currentUser!.uid;

    // get the timestamp

    final Timestamp timestamp = Timestamp.now();

    // create a new message

    Message message = Message(
      senderID: senderID,
      receiverID: receiverID,
      message: messageContent,
      createdAt: timestamp,
    );

    // create a new chat whose id is the concatenation of the two user ids joined by "_"
    // create a list of ids first
    List<String> ids = [senderID, receiverID];
    ids.sort();
    String chatID = ids.join('_');

    // add the message to the chat
    try {
      await _firebaseFirestore
          .collection('chats')
          .doc(chatID)
          .collection('messages')
          .add(message.toMap());
    } catch (e) {
      print(e);
    }
  }

//get message returns a query snapshot
Stream <QuerySnapshot> getMessages (String receiverID){

  // get the current user id
  final senderID = _firebaseAuth.currentUser!.uid;

  // create a list of ids first
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
  
}
