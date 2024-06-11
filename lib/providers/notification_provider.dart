import 'dart:async';
import 'package:caravan/models/notification.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';

Logger logger = Logger();

class NotificationProvider with ChangeNotifier {
  List<MyNotification> _notifications = [];
  int unreadNotificationsCount = 0;
  List<MyNotification> get notifications => _notifications;

  User? user = FirebaseAuth.instance.currentUser;
  StreamSubscription? _notificationSubscription;

  NotificationProvider() {
    // startListeningToNotifications();
  }

  Stream<List<MyNotification>> getNotificationsStream(User? user) {
    logger.i("Getting notifications for $user");
    try {
      return FirebaseFirestore.instance
          .collection('users')
          .doc(user?.uid)
          .collection('notifications')
          .orderBy('timestamp', descending: false)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => MyNotification.fromDocument(doc))
              .toList())
          .handleError((error) {
        // Handle the error here, such as logging or displaying an error message
        logger.d('Error fetching notifications: $error');
        return []; // Return an empty list to gracefully handle the error
      });
    } catch (e) {
      // Handle the error here, such as logging or displaying an error message
      logger.d('Error fetching notifications: $e');
      return const Stream
          .empty(); // Return an empty stream to gracefully handle the error
    }
  }

  void startListeningToNotifications() {
    User? user = FirebaseAuth.instance.currentUser;
    logger.i("Listening for notifications for $user");
    if (user != null) {
      _notificationSubscription =
          getNotificationsStream(user).listen((notifications) {
        _notifications = notifications;
        unreadNotificationsCount = _notifications
            .where((notification) => notification.status == 'unread')
            .length;
      });
    }

    notifyListeners();
  }

  @override
  void dispose() {
    _notificationSubscription?.cancel();
    super.dispose();
  }

  Future<void> markAsRead(MyNotification notification, User? user) async {
    if (notification.status != 'read') {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user?.uid)
          .collection('notifications')
          .doc(notification.id)
          .update({'status': 'read'});
      notification.status = 'read';
      notifyListeners();
    }
  }

  void resetProvider() {
    _notifications = [];
    unreadNotificationsCount = 0;
    notifyListeners();
  }
}
