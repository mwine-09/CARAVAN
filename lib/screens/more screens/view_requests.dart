import 'package:caravan/models/user_profile.dart';
import 'package:caravan/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';

Logger logger = Logger();

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
    return StreamBuilder<QuerySnapshot>(
      stream: DatabaseService().fetchRequestsStream(tripId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text(
              'No $status requests found.',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Colors.white, fontSize: 20),
            ),
          );
        } else {
          var requests = snapshot.data!.docs
              .where((request) => request['status'] == status)
              .toList();

          if (requests.isEmpty) {
            return const Center(
              child: Text(
                "Nothing to see here",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            );
          }
          return ListView.separated(
            separatorBuilder: (context, index) => const Divider(
              height: 1,
              color: Colors.white30,
            ),
            itemCount: requests.length,
            itemBuilder: (context, index) {
              var request = requests[index];
              return FutureBuilder<UserProfile>(
                future:
                    DatabaseService().getUserProfile(request['passengerId']),
                builder: (context, userSnapshot) {
                  if (userSnapshot.connectionState == ConnectionState.waiting) {
                    return const SizedBox();
                  } else if (userSnapshot.hasError) {
                    return Center(
                        child: Text(
                      'Error: ${userSnapshot.error}',
                      style: const TextStyle(color: Colors.white),
                    ));
                  } else {
                    var username = userSnapshot.data!.username!;
                    return ListTile(
                      title: GestureDetector(
                        child: Text(
                          'Request from $username',
                          style: const TextStyle(color: Colors.white),
                        ),
                        onTap: () {
                          // navigate to the user's profile
                          Navigator.pushNamed(context, '/profile',
                              arguments: userSnapshot.data);
                        },
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
                // change the status of the request to accepted
                logger.d("The id of this request docuement is ${request.id}");
                DatabaseService()
                    .addRequestToTrip(request['tripId'], request.id);
                DatabaseService().updateRequestStatus(request.id, 'accepted');
                logger.d("${request['passengerId']}, ${request.id}");
                // notify the user that their request has been accepted.
                DatabaseService().sendRequestStatusNotification(
                    request['passengerId'], request.id, 'accepted');
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

                DatabaseService().sendRequestStatusNotification(
                    request['passengerId'], request.id, 'declined');
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
            // change the status of the request to accepted
            DatabaseService().updateRequestStatus(request.id, 'pending');

            DatabaseService().removePassengerFromTrip(
                request['passengerId'], request['tripId']);

            // notify the user that their request has been accepted.
            DatabaseService().sendRequestStatusNotification(
                request['passengerId'], request.id, 'pending');
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
            // change the status of the request to accepted
            logger.d("The id of this request docuement is ${request.id}");
            DatabaseService().addRequestToTrip(request['tripId'], request.id);
            DatabaseService().updateRequestStatus(request.id, 'accepted');
            logger.d("${request['passengerId']}, ${request.id}");
            // notify the user that their request has been accepted.
            DatabaseService().sendRequestStatusNotification(
                request['passengerId'], request.id, 'accepted');
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
