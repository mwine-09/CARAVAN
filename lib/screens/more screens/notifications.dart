import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                FirebaseFirestore.instance.collection('/notifications').add({
                  'title': 'New Notification',
                  'body': 'This is a new notification',
                });

                print("done adding trip");
              },
              child: const Text("Add notification"),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('/notifications')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final notifications = snapshot.data?.docs;
                    return ListView.builder(
                      itemCount: notifications?.length,
                      itemBuilder: (context, index) {
                        final notification = notifications?[index].data();
                        return ListTile(
                          title: Text(
                              (notification as Map<String, dynamic>)['title']),
                          subtitle: Text(notification['body']),
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
