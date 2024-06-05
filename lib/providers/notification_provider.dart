import 'dart:async';
import 'package:caravan/models/notification.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationProvider with ChangeNotifier {
  List<MyNotification> _notifications = [];
  int unreadNotificationsCount = 0;
  List<MyNotification> get notifications => _notifications;
  User? user = FirebaseAuth.instance.currentUser!;
  StreamSubscription? _notificationSubscription;

  NotificationProvider() {
    _startListeningToNotifications();
  }

  Stream<List<MyNotification>> getNotificationsStream() {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .collection('notifications')
        .orderBy('timestamp',
            descending: false) // Sort by timestamp in descending order
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => MyNotification.fromDocument(doc))
            .toList());
  }

  void _startListeningToNotifications() {
    _notificationSubscription =
        getNotificationsStream().listen((notifications) {
      _notifications = notifications;
      unreadNotificationsCount = _notifications
          .where((notification) => notification.status == 'unread')
          .length;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _notificationSubscription?.cancel();
    super.dispose();
    notifyListeners();
  }

  Future<void> markAsRead(MyNotification notification) async {
    String? userId = user!.uid;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('notifications')
        .doc(notification.id)
        .update({'status': 'read'});
    notification.status = 'read';
    notifyListeners();
  }
}
