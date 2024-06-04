import 'package:caravan/models/user_profile.dart';
import 'package:caravan/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ViewRequestsScreen extends StatefulWidget {
  final String tripId;

  const ViewRequestsScreen({super.key, required this.tripId});

  @override
  _ViewRequestsScreenState createState() => _ViewRequestsScreenState();
}

class _ViewRequestsScreenState extends State<ViewRequestsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'View Requests',
          style: TextStyle(color: Colors.white),
        ),
        bottom: TabBar(
          indicatorColor: Colors.blueAccent,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white38,
          controller: _tabController,
          tabs: const [
            Tab(text: 'Pending'),
            Tab(text: 'Accepted'),
            Tab(text: 'Declined'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          RequestsList(tripId: widget.tripId, status: 'pending'),
          RequestsList(tripId: widget.tripId, status: 'accepted'),
          RequestsList(tripId: widget.tripId, status: 'declined'),
        ],
      ),
    );
  }
}

class RequestsList extends StatelessWidget {
  final String tripId;
  final String status;

  const RequestsList({super.key, required this.tripId, required this.status});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: DatabaseService().fetchRequestsByStatus(tripId, status),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: CircularProgressIndicator(
            color: Colors.white,
          ));
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
              child: Text(
            'No requests found.',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: Colors.white, fontSize: 20),
          ));
        } else {
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var request = snapshot.data!.docs[index];
              return FutureBuilder<UserProfile>(
                future:
                    DatabaseService().getUserProfile(request['passengerId']),
                builder: (context, userSnapshot) {
                  if (userSnapshot.connectionState == ConnectionState.waiting) {
                    return const SizedBox(); // Show nothing while loading user data
                  } else if (userSnapshot.hasError) {
                    return Center(child: Text('Error: ${userSnapshot.error}'));
                  } else {
                    var username = userSnapshot.data!.username!;
                    return ListTile(
                      title: Text(
                        'Request from $username',
                        style: const TextStyle(color: Colors.white),
                      ),
                      subtitle: Text('Status: ${request['status']}'),
                      trailing: _buildActionButtons(request),
                    );
                  }
                },
              );
            },
          );
        }
      },
    );
  }

  Widget _buildActionButtons(QueryDocumentSnapshot request) {
    switch (request['status']) {
      case 'pending':
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () {
                DatabaseService().addPassengerToTrip(
                    request['passengerId'], request['tripId']);
                DatabaseService().updateRequestStatus(request.id, 'accepted');
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Colors.white, // Text color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              child: const Text('Accept'),
            ),
            ElevatedButton(
              onPressed: () {
                DatabaseService().updateRequestStatus(request.id, 'declined');
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.black, // Text color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              child: const Text('Decline'),
            ),
          ],
        );
      case 'accepted':
        return ElevatedButton(
          onPressed: () {
            DatabaseService().updateRequestStatus(request.id, 'pending');
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.red, // Text color
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          child: const Text('Cancel'),
        );
      case 'declined':
        return ElevatedButton(
          onPressed: () {
            DatabaseService().updateRequestStatus(request.id, 'accepted');
            DatabaseService()
                .addPassengerToTrip(request['passengerId'], request['tripId']);
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.black,
            backgroundColor: Colors.white, // Text color
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          child: const Text('Accept'),
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
