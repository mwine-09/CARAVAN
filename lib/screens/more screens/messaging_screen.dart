import 'package:caravan/components/message_widget.dart';
import 'package:caravan/models/chat_room.dart';
import 'package:caravan/models/message.dart';
import 'package:caravan/models/trip.dart';
import 'package:caravan/providers/chat_provider.dart';
import 'package:caravan/services/chat_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  // final UserProfile selectedDriver;
  final ChatRoom chatRoom;

  const ChatScreen({super.key, required this.chatRoom});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final textController = TextEditingController();
  late Trip trip;
  late ScrollController scrollController;
  late FirebaseAuth _firebaseAuth;
  late String _senderID;
  late ChatProvider chatProvider;
  late Stream<List<Message>> messagesStream;

  @override
  void initState() {
    super.initState();

    scrollController = ScrollController();
    chatProvider = Provider.of<ChatProvider>(context, listen: false);
    _firebaseAuth = FirebaseAuth.instance;
    _senderID = _firebaseAuth.currentUser!.uid;
    messagesStream = chatProvider.getMessagesStream(widget.chatRoom.id);
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  void sendMessage(String message) {
    ChatService()
        .sendMessage(chatProvider.getOtherUserId(widget.chatRoom.id), message);
    textController.clear();
  }

  Widget _messageBuildItem(Message message) {
    var alignment = message.senderID == _senderID
        ? Alignment.centerRight
        : Alignment.centerLeft;
    return Container(
      alignment: alignment,
      child: MessageWidget(
        message: message,
      ),
    );
  }

  String capitalize(String s) {
    return s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);
  }

  Widget _buildMessageList() {
    return StreamBuilder<List<Message>>(
      stream: messagesStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
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
          final messages = snapshot.data!;
          logger.i('Messages: $messages');
          WidgetsBinding.instance.addPostFrameCallback((_) {
            // Scroll to the bottom of the list after the frame is built
            if (scrollController.hasClients) {
              scrollController
                  .jumpTo(scrollController.position.maxScrollExtent);
            }
          });
          return ListView.builder(
            controller: scrollController,
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
    var sendMessageIconColor = Colors.grey[600];

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
              capitalize(widget.chatRoom.title ?? 'No title'),
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
              onPressed: () {},
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              Expanded(
                child: _buildMessageList(),
              ),
              Container(
                // height: 50,
                margin: const EdgeInsets.all(8),
                child: TextField(
                  cursorColor: Colors.black,
                  // cursorHeight: 10,
                  maxLines: 4,
                  minLines: 1,
                  // textAlignVertical: TextAlignVertical.center,
                  style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                  controller: textController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color.fromARGB(255, 226, 226, 226),
                    hintStyle:
                        const TextStyle(color: Color.fromARGB(179, 0, 0, 0)),
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
