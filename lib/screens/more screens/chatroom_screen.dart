import 'package:caravan/models/chat_room.dart';
import 'package:caravan/screens/more%20screens/messaging_screen.dart';
import 'package:caravan/services/database_service.dart';
// import 'package:caravan/screens/more%20screens/messaging_screen.dart';
import 'package:flutter/material.dart';
import 'package:caravan/services/chat_service.dart';
// import 'package:caravan/models/chat_room.dart';

class ChatListScreen extends StatelessWidget {
  final ChatService _chatService = ChatService();

  ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text('Chats',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                )),
      ),
      body: FutureBuilder(
        future: _chatService.getChatRoomsForUser(),
        builder: (context, AsyncSnapshot<List<ChatRoom>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color.fromARGB(255, 255, 255, 255),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                      )),
            );
          } else {
            List<ChatRoom> chatRooms = snapshot.data!;
            print(chatRooms.length);
            return ListView.builder(
              itemCount: chatRooms.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    chatRooms[index].title,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: Colors.white),
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
                  onTap: () async {
                    final userProfile = await DatabaseService()
                        .getUserProfile(chatRooms[index].title);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatScreen(
                          selectedDriver: userProfile,
                        ),
                      ),
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
