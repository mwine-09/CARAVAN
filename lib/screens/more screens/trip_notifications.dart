import 'package:caravan/models/notification.dart';
import 'package:caravan/models/user_profile.dart';
import 'package:caravan/providers/notification_provider.dart';
import 'package:caravan/providers/user_profile.provider.dart';
import 'package:caravan/screens/more%20screens/view_requests.dart';
import 'package:caravan/services/location_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
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

    return ListView.separated(
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        final notification = notifications[index];
        return ListTile(
          title: Text(
            notification.message,
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
          subtitle: Text(
            notification.timestamp.toString(),
            style: const TextStyle(fontSize: 13),
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
            logger.i(notification.getRequestId);
            if (type == 'request') {
              DocumentSnapshot requestSnapshot = await FirebaseFirestore
                  .instance
                  .collection("requests")
                  .doc(notification.getRequestId)
                  .get();
              logger.d(requestSnapshot.data());

              String tripId =
                  (requestSnapshot.data() as Map<String, dynamic>)['tripId'];
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
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return const Divider(
          height: 1,
          color: Colors.white24,
        );
      },
    );
  }
}
