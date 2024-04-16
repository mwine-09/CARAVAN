import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

import '../models/message.dart';
import 'package:flutter/material.dart';

class MessageWidget extends StatefulWidget {
  final Message message;
  const MessageWidget({super.key, required this.message});

  @override
  State<MessageWidget> createState() => _MessageWidgetState();
}

class _MessageWidgetState extends State<MessageWidget> {
  late FirebaseAuth _firebaseAuth;

  @override
  Widget build(BuildContext context) {
    _firebaseAuth = FirebaseAuth.instance;
    String senderID = _firebaseAuth.currentUser!.uid;

    final theme = Theme.of(context);

    if (widget.message.senderID == senderID) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            constraints: const BoxConstraints(maxWidth: 250),
            padding: const EdgeInsets.all(8),
            margin: const EdgeInsets.only(right: 8, bottom: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: const Color.fromARGB(255, 12, 12, 12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(widget.message.message,
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: Colors.white, fontSize: 14)),
                const SizedBox(
                  height: 4,
                ),
                Text(
                    DateFormat('h:mm a')
                        .format(widget.message.createdAt.toDate()),
                    style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.white,
                        fontSize: 12,
                        fontFamily: 'Roboto')),
              ],
            ),
          ),
        ],
      );
    } else {
      return Row(
        children: [
          Container(
            constraints: const BoxConstraints(maxWidth: 250),
            padding: const EdgeInsets.all(8),
            margin: const EdgeInsets.only(left: 8, bottom: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: const Color.fromARGB(255, 24, 24, 24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.message.message,
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: Colors.white, fontSize: 14),
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  DateFormat('h:mm a')
                      .format(widget.message.createdAt.toDate()),
                  style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.white, fontSize: 12, fontFamily: 'Roboto'),
                ),
              ],
            ),
          ),
        ],
      );
    }
  }
}
