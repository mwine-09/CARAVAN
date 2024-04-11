import 'dart:async';

import 'package:caravan/models/user_profile.dart';
import 'package:caravan/services/chat_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:caravan/models/message.dart';
import 'package:caravan/models/trip.dart';
import 'package:caravan/providers/trips_provider.dart';
// import 'package:caravan/providers/user_provider.dart';
import 'package:caravan/components/message_widget.dart';

class ChatScreen extends StatefulWidget {
  final UserProfile selectedDriver;
  const ChatScreen({super.key, required this.selectedDriver});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final textController = TextEditingController();
  final ChatService chatService = ChatService();
  late Trip trip;
  late ScrollController scrollController;
  late Stream<List<Message>> messagesStream;
  late FirebaseAuth _firebaseAuth;
  late String _senderID;

  @override
  void initState() {
    super.initState();
    final tripProvider =
        Provider.of<TripDetailsProvider>(context, listen: false);
    trip = tripProvider.tripDetails!;
    scrollController = ScrollController();

    _firebaseAuth = FirebaseAuth.instance;
    _senderID = _firebaseAuth.currentUser!.uid;
  }

  void _animateToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 1),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  void sendMessage(String message) {
    Timestamp now = Timestamp.now();
    chatService.sendMessage(trip.driverID, message);
    textController.clear();
  }

  String capitalize(String s) {
    return s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);
  }

  Widget _messageBuildItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    var alignment = data['senderID'] == _senderID
        ? Alignment.centerRight
        : Alignment.centerLeft;
    // use the MessageWidget component
    return Container(
      alignment: alignment,
      child: MessageWidget(
        message: Message(
          message: data['message'],
          senderID: data['senderID'],
          receiverID: data['receiverID'],
          createdAt: data['createdAt'],
        ),
      ),
    );
  }

  Widget _buildMessageList() {
    return StreamBuilder(
      stream: chatService.getMessages(trip.driverID),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'No messages available',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Colors.white,
                    fontSize: 18,
                  ),
            ),
          );
        } else if (snapshot.hasError) {
          return Text(
            'Error: ${snapshot.error}',
            style: const TextStyle(
              color: Colors.white,
            ),
          );
        } else {
          final messages = snapshot.data!.docs;
          return ListView.builder(
            itemCount: messages.length,
            itemBuilder: (context, index) {
              return _messageBuildItem(messages[index]);
            },
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    UserProfile selectedDriver = widget.selectedDriver;
    String? username = selectedDriver.username;
    var sendMessageIconColor = Colors.grey[600];
    // messagesStream = DatabaseService().getMessagesStream(trip.driverID);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                shape: BoxShape.rectangle,
                image: const DecorationImage(
                  image: AssetImage('assets/default_profile.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              capitalize(username!),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2.0,
                  ),
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.call),
              onPressed: () {
                // Implement call functionality
              },
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Container(
          color: Colors.black,
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              Expanded(
                child: _buildMessageList(),
              ),
              Container(
                height: 40,
                margin: const EdgeInsets.all(8),
                child: TextField(
                  textAlignVertical: TextAlignVertical.center,
                  style: const TextStyle(color: Colors.white),
                  controller: textController,
                  decoration: InputDecoration(
                    hintStyle: const TextStyle(
                        color: Color.fromARGB(179, 139, 139, 139)),
                    hintText: 'Type a message...',
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(40)),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.send, color: sendMessageIconColor),
                      onPressed: () {
                        if (textController.text.isNotEmpty) {
                          sendMessage(textController.text);
                          setState(() {
                            sendMessageIconColor =
                                const Color.fromARGB(255, 255, 255, 255);
                          });
                        }
                      },
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                      borderSide:
                          BorderSide(color: Color.fromARGB(255, 223, 223, 223)),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
