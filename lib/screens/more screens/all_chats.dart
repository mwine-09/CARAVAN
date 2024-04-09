import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AllChats extends StatelessWidget {
  const AllChats({super.key});

  @override
  Widget build(BuildContext context) {
    // UserProvider _userProvider = Provider.of(context, listen: false);
    String? receiverId = FirebaseAuth.instance.currentUser?.uid;
    // Assuming you have a method to get the receiver ID

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Chats',
          style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('messages')
            .where('receiverId', isEqualTo: receiverId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          List<QueryDocumentSnapshot> messages = snapshot.data!.docs;

          // Group messages by senderId to create a chat list
          Map<String, List<QueryDocumentSnapshot>> chatMap = {};
          for (var message in messages) {
            print(message.data());
            String senderId = message['senderId'];
            if (!chatMap.containsKey(senderId)) {
              chatMap[senderId] = [];
            }
            chatMap[senderId]!.add(message);
          }

          return ListView.builder(
            itemCount: chatMap.length,
            itemBuilder: (context, index) {
              String senderId = chatMap.keys.elementAt(index);
              String senderName =
                  'Sender $index'; // Replace with actual sender name

              // Get the last message from the chat
              QueryDocumentSnapshot lastMessage = chatMap[senderId]!.last;
              String lastMessageContent = lastMessage['content'];

              return ListTile(
                horizontalTitleGap: 20,
                leading: const CircleAvatar(
                  backgroundImage: AssetImage('assets/default_profile.jpg'),
                ),
                title: Text(senderName),
                subtitle: Text(lastMessageContent),
                onTap: () {
                  // Handle chat item tap
                },
              );
            },
          );
        },
      ),
    );
  }
}
