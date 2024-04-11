import 'package:caravan/models/chat_room.dart';
import 'package:caravan/models/user_profile.dart';
import 'package:caravan/screens/more%20screens/messaging_screen.dart';
import 'package:caravan/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:caravan/services/chat_service.dart';

class ChatListScreen extends StatelessWidget {
  final ChatService _chatService = ChatService();

  ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          'Chats',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
        ),
      ),
      body: StreamBuilder<List<ChatRoom>>(
        stream: _chatService.getChatRoomsForUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color.fromARGB(255, 255, 255, 255),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                    ),
              ),
            );
          } else if (snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'No chat rooms available',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: Colors.white, fontSize: 18),
              ),
            );
          } else {
            List<ChatRoom> chatRooms = snapshot.data!;
            return ListView.builder(
              itemCount: chatRooms.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    chatRooms[index].title,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: const Color.fromARGB(255, 171, 39, 39)),
                  ),
                  subtitle: Text(chatRooms[index].lastMessage,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: Colors.white)),
                  leading: const Icon(Icons.person, color: Colors.white),
                  trailing:
                      const Icon(Icons.arrow_forward_ios, color: Colors.white),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  onTap: () {
                    // print(
                    // "We are now at index $index and we are passing user id ${chatRooms[index].title}");
                    UserProfile userProfile;
                    DatabaseService()
                        .getUserProfile(chatRooms[index].title)
                        .then(
                      (value) {
                        userProfile = value;

                        print(
                            "We are getting a userprofile for id ${chatRooms[index].title}");
                        print(
                            "We are passing the userprofile ${chatRooms[index].title} to the chat screen");
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatScreen(
                              selectedDriver: userProfile,
                              receiverID: chatRooms[index].title,
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
