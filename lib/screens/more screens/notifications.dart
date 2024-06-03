import 'package:caravan/providers/notification_provider.dart';
import 'package:caravan/screens/more%20screens/trip_notifications.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notificationProvider = Provider.of<NotificationProvider>(context);
    final notifications = notificationProvider.notifications;
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Notifications',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: notifications.isNotEmpty
            ? NotificationList()
            : const Text(
                " You don't have notifications!",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
      ),
    );
  }
}
