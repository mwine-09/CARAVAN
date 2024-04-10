import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:caravan/models/message.dart';
import 'package:caravan/models/trip.dart';
import 'package:caravan/providers/trips_provider.dart';
import 'package:caravan/providers/user_provider.dart';
import 'package:caravan/services/database_service.dart';
import 'package:caravan/components/message_widget.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final textController = TextEditingController();
  late Stream<List<Message>> messagesStream;
  late String receiverID;

  @override
  void initState() {
    super.initState();
    final tripProvider =
        Provider.of<TripDetailsProvider>(context, listen: false);
    final Trip trip = tripProvider.tripDetails!;
    receiverID = trip.driverID;

    messagesStream = DatabaseService().getMessagesStream(receiverID);
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  void sendMessage(String text) {
    Timestamp now = Timestamp.now();
    DatabaseService().sendMessage(
      receiverId: receiverID,
      messageContent: text,
      timestamp: now,
    );

    // Update the messagesStream with the new message
    messagesStream = messagesStream.map((messages) {
      return List.from(messages)
        ..add(Message(
          id: 'new_message_id', // Generate a unique message ID here
          text: text,
          createdAt: now,
          isMe: true, // Assuming the current user sent the message
        ));
    });

    textController.clear();
  }

  String capitalize(String s) {
    return s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of(context, listen: false);
    final TripDetailsProvider tripProvider =
        Provider.of(context, listen: false);
    final Trip trip = tripProvider.tripDetails!;
    receiverID = trip.driverID;

    print("The receiver id is $receiverID");

    String username = userProvider.getUsername();
    var sendMessageIconColor = Colors.grey[600];

    return Scaffold(
      appBar: AppBar(
        // add a trailing icon for calls

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
            Text(capitalize(username),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2.0)),

            // add a trailing icon for calls

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
                child: Container(
                  color: Colors.black,
                  padding: const EdgeInsets.all(8),
                  child: StreamBuilder<List<Message>>(
                    stream: messagesStream,
                    builder: (context, snapshot) {
                      print("The snapshot is ${snapshot.data}");
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                            child: CircularProgressIndicator(
                          color: Color.fromARGB(255, 198, 193, 193),
                        ));
                      } else if (snapshot.hasError) {
                        return Center(
                            child: Text('Error: ${snapshot.error}',
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 20)));
                      } else {
                        List<Message>? messages = snapshot.data;
                        print(messages);
                        return ListView.builder(
                          itemCount: messages?.length ?? 0,
                          itemBuilder: (context, index) {
                            return MessageWidget(message: messages![index]);
                          },
                        );
                      }
                    },
                  ),
                ),
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
                        borderRadius: BorderRadius.all(Radius.circular(40))),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.send, color: sendMessageIconColor),
                      onPressed: () {
                        if (textController.text.isNotEmpty) {
                          sendMessage(textController.text);
                          // change the color of the send icon
                          setState(() {
                            sendMessageIconColor =
                                const Color.fromARGB(255, 210, 210, 210);
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
