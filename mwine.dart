import 'package:caravan/components/message_widget.dart';
// import 'package:caravan/models/message.dart';
import 'package:caravan/services/database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class Message {
  final int id;
  final String text;
  final String createdAt;
  final bool isMe;

  Message({
    required this.id,
    required this.text,
    required this.createdAt,
    required this.isMe,
  });
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  // create a text controller
  final textController = TextEditingController();
  final List<Message> messages = [
    Message(
      id: 1,
      text: 'Hi, I saw your ride offer. Is the seat still available?',
      createdAt: '10:00 AM',
      isMe: false,
    ),
    Message(
      id: 2,
      text: 'Yes, the seat is still available. Are you interested?',
      createdAt: '10:01 AM',
      isMe: true,
    ),
    Message(
      id: 3,
      text:
          'Yes, I would like to book a seat. Can you please share the details?',
      createdAt: '10:02 AM',
      isMe: false,
    ),
    Message(
      id: 4,
      text: 'Sure! I will pick you up at 8:00 AM from your location.',
      createdAt: '10:03 AM',
      isMe: true,
    ),
    Message(
      id: 5,
      text: 'That works for me. How much will the ride cost?',
      createdAt: '10:04 AM',
      isMe: false,
    ),
    Message(
      id: 6,
      text: 'The ride will cost 20. Is that okay with you?',
      createdAt: '10:05 AM',
      isMe: true,
    ),
    Message(
      id: 7,
      text: 'Yes, that sounds good. See you tomorrow!',
      createdAt: '10:06 AM',
      isMe: false,
    ),
  ];

  late AnimationController slideInputController;
  late Animation<Offset> slideInputAnimation;

  @override
  void initState() {
    slideInputController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    slideInputAnimation = Tween<Offset>(
      begin: const Offset(0, 0),
      end: const Offset(-2, 0),
    ).animate(slideInputController);
    super.initState();
  }

  @override
  void dispose() {
    slideInputController.dispose();
    super.dispose();
  }

  // void sendMessage(String text) {
  //   setState(() {
  //     messages.insert(
  //       0,
  //       Message(
  //         id: messages.length + 1,
  //         text: text,
  //         createdAt: 'Just now',
  //         isMe: true,
  //       ),
  //     );
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    // final theme = Theme.of(context);

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
            const Text(
              'John Doe',
              style: TextStyle(color: Colors.white),
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
                  child: ListView.builder(
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      return MessageWidget(message: messages[index]);
                    },
                  ),
                ),
              ),
              SlideTransition(
                position: slideInputAnimation,
                child: Card(
                  margin: EdgeInsets.zero,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: textController,
                            onEditingComplete: () {
                              print(textController.value);
                            },
                            decoration: InputDecoration(
                              hintStyle: const TextStyle(
                                  color: Color.fromARGB(179, 0, 0, 0)),
                              hintText: 'Type a message...',
                              border: const OutlineInputBorder(),
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.send),
                                onPressed: () {
                                  Timestamp now = Timestamp.now();

                                  if (textController.text.isNotEmpty) {
                                    // use firebase to send message
                                    DatabaseService().sendMessage(
                                        receiverId:
                                            '3Kvyg4rpBBfuI3UwRdvHqax8kyh2',
                                        messageContent: textController.text,
                                        timestamp: now);

                                    print("message sent");
                                    // sendMessage(textController.text);
                                    textController.clear();
                                  }
                                },
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
