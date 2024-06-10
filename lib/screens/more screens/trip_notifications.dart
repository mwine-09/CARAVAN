import 'package:caravan/models/request.dart';
import 'package:caravan/providers/notification_provider.dart';
import 'package:caravan/screens/more%20screens/view_requests.dart';
import 'package:caravan/services/database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
// import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Logger logger = Logger();

class NotificationList extends StatelessWidget {
  NotificationList({super.key});
  User user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    final notificationProvider = Provider.of<NotificationProvider>(context);
    final notifications = notificationProvider.notifications;

    return ListView(
      // itemCount: notifications.length,
      children: notifications.map((notification) {
        return Card(
          elevation: 2,
          color: const Color.fromARGB(255, 255, 255, 255),
          child: ListTile(
            title: Text(
              notification.message,
              style: const TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0), fontSize: 14),
            ),
            subtitle: Text(
              notification.timestamp.toString(),
              style: const TextStyle(
                  fontSize: 13, color: Color.fromARGB(255, 0, 0, 0)),
            ),
            trailing: notification.status == 'unread'
                ? const Icon(
                    Icons.new_releases_rounded,
                    color: Colors.blueAccent,
                  )
                : null,
            onTap: () async {
              notificationProvider.markAsRead(
                  notification, FirebaseAuth.instance.currentUser!);

              var type = notification.getType;
              logger.i(type);
              logger.i(notification.requestId);
              if (type == 'request') {
                Request request = await DatabaseService()
                    .getRequestById(notification.requestId!);
                logger.d(request);

                String tripId = request.tripId!;
                logger.i("trip is is $tripId");

                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ViewRequestsScreen(
                              tripId: tripId,
                            )));
              }
              // Handle notification tap
            },
          ),
        );
      }).toList(),
    );
  }
}
