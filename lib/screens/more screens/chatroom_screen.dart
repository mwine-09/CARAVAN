import 'package:caravan/models/chat_room.dart';
import 'package:caravan/models/user_profile.dart';
import 'package:caravan/providers/chat_provider.dart';
import 'package:caravan/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
            'Chat Rooms',
            style: TextStyle(color: Colors.white),
          ),
          iconTheme: const IconThemeData(
            color: Colors.white,
          )),
      body: Consumer<ChatProvider>(
        builder: (context, chatProvider, child) {
          return ListView.builder(
            itemCount: chatProvider.chatrooms.length,
            itemBuilder: (context, index) {
              ChatRoom chatRoom = chatProvider.chatrooms[index];
              return ListTile(
                title: Text(
                  chatRoom.title!,
                  style: const TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  chatRoom.lastMessage,
                  style: const TextStyle(color: Colors.white),
                ),
                onTap: () {
                  // Navigate to the chat room screen
                },
              );
            },
          );
        },
      ),
    );
  }
}
