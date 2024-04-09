import 'package:intl/intl.dart';

import '../models/message.dart';
import 'package:flutter/material.dart';

class MessageWidget extends StatelessWidget {
  final Message message;
  const MessageWidget({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (message.isMe) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            constraints: BoxConstraints(maxWidth: 250),
            padding: EdgeInsets.all(8),
            margin: EdgeInsets.only(right: 8, bottom: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Color.fromARGB(255, 12, 12, 12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(message.text!,
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: Colors.white)),
                SizedBox(
                  height: 4,
                ),
                Text(DateFormat('h:mm a').format(message.createdAt.toDate()),
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: Colors.white)),
              ],
            ),
          ),
        ],
      );
    } else {
      return Row(
        children: [
          Container(
            constraints: BoxConstraints(maxWidth: 250),
            padding: EdgeInsets.all(8),
            margin: EdgeInsets.only(left: 8, bottom: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Color.fromARGB(255, 24, 24, 24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message.text!,
                  style:
                      theme.textTheme.bodySmall?.copyWith(color: Colors.white),
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  DateFormat('h:mm a').format(message.createdAt.toDate()),
                  style:
                      theme.textTheme.bodySmall?.copyWith(color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      );
    }
  }
}
