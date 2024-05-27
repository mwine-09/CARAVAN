import 'package:caravan/models/chat_room.dart';
import 'package:caravan/providers/chat_provider.dart';
import 'package:caravan/providers/user_profile.provider.dart';
import 'package:caravan/screens/more%20screens/messaging_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProfileProvider = Provider.of<UserProfileProvider>(context);
    return Scaffold(
      appBar: AppBar(
          title: Text(
            'Chats',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5),
          ),
          iconTheme: const IconThemeData(
            color: Colors.white,
          )),
      body: Consumer<ChatProvider>(
        builder: (context, chatProvider, child) {
          if (chatProvider.chatrooms.isEmpty) {
            chatProvider.loadChatrooms(userProfileProvider.userProfile.userID!);

            if (chatProvider.chatrooms.isEmpty) {
              return Center(
                child: Text('No chats yet',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.white, fontWeight: FontWeight.bold)),
              );
            }
          }
          return ListView.builder(
            itemCount: chatProvider.chatrooms.length,
            itemBuilder: (context, index) {
              ChatRoom chatRoom = chatProvider.chatrooms[index];
              return Column(
                children: [
                  ListTile(
                    splashColor: Colors.grey,
                    leading: const CircleAvatar(
                      radius: 25,
                      backgroundImage: AssetImage('assets/default_profile.jpg'),
                    ),
                    title: Text(
                      chatRoom.title ?? 'No title',
                      style: const TextStyle(color: Colors.white),
                    ),
                    subtitle: Row(
                      children: [
                        if (chatRoom.lastMessageSenderID ==
                            userProfileProvider.userProfile.userID)
                          const Icon(Icons.done),
                        Text(
                          '  ${chatRoom.lastMessage}',
                          style: const TextStyle(
                            color: Color.fromARGB(167, 255, 255, 255),
                          ),
                        ),
                      ],
                    ),
                    trailing: Text(
                      DateFormat('h:mm a')
                          .format(chatRoom.lastMessageTime.toDate()),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: const Color.fromARGB(255, 0, 132, 239),
                          fontSize: 12,
                          fontFamily: 'Roboto'),
                    ),
                    onTap: () {
                      chatProvider.openChatroom(chatRoom.id);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatScreen(chatRoom: chatRoom),
                        ),
                      );
                      // Navigate to the chat room screen
                    },
                  ),
                  const Divider(
                    indent: 80,
                    endIndent: 20,
                    color: Color.fromARGB(90, 158, 158, 158),
                  )
                ],
              );
            },
          );
        },
      ),
    );
  }
}
