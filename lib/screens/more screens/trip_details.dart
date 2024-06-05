import 'dart:math';

import 'package:caravan/models/chat_room.dart';
import 'package:caravan/models/trip.dart';
import 'package:caravan/models/user_profile.dart';
import 'package:caravan/providers/chat_provider.dart';
import 'package:caravan/providers/trips_provider.dart';
import 'package:caravan/providers/user_profile.provider.dart';
import 'package:caravan/screens/more%20screens/location_tracking_map.dart';
import 'package:caravan/screens/more%20screens/messaging_screen.dart';
import 'package:caravan/screens/more%20screens/passenger/enter_destination.dart';
import 'package:caravan/screens/more%20screens/passenger/rider_destination_location.dart';
import 'package:caravan/screens/more%20screens/request_sent.dart';
import 'package:caravan/screens/more%20screens/view_requests.dart';
import 'package:caravan/services/database_service.dart';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

Logger logger = Logger();

class TripDetailsScreen extends StatefulWidget {
  final UserProfile userProfile;
  const TripDetailsScreen({super.key, required this.userProfile});

  @override
  State<TripDetailsScreen> createState() => _TripDetailsScreenState();
}

class _TripDetailsScreenState extends State<TripDetailsScreen> {
  late GoogleMapController mapController;
  Map<PolylineId, Polyline> polylines = {};
  Map<MarkerId, Marker> markers = {};
  static LatLng _center = const LatLng(0, 0);

  String startTripButton = "Start Trip";

  @override
  void initState() {
    super.initState();
    print("TripDetailsScreen initialized");
  }

  @override
  Widget build(BuildContext context) {
    ChatProvider chatProvider = Provider.of<ChatProvider>(context);
    UserProfileProvider userProfileProvider =
        Provider.of<UserProfileProvider>(context);
    final tripProvider = Provider.of<TripDetailsProvider>(context);
    final Trip trip = tripProvider.tripDetails!;
    String? selectedDriverName = widget.userProfile.username ?? "Unknown user";
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: Text(
          selectedDriverName,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Driver details",
                  style: TextStyle(
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                TripDriverCard(
                    trip: trip,
                    selectedDriverName: selectedDriverName,
                    userProfile: widget.userProfile),
                const SizedBox(height: 8),
                const Text(
                  "Trip Details",
                  style: TextStyle(
                      color: Color.fromARGB(255, 249, 249, 249),
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 22, 22, 22),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "To: ${trip.destination}",
                                  softWrap: true,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 14),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  "From: ${trip.location}",
                                  softWrap: true,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 14),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  "Max number of stops: ${trip.availableSeats}",
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),

                          // message button
                          if (trip.createdBy !=
                              userProfileProvider.userProfile.userID)
                            ElevatedButton(
                              onPressed: () async {
                                String driverId =
                                    trip.createdBy ?? "Unknown user";

                                if (chatProvider.hasChatroom(driverId)) {
                                  ChatRoom? chatroom =
                                      chatProvider.getChatroom(driverId);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ChatScreen(
                                        chatRoom: chatroom!,
                                      ),
                                    ),
                                  );
                                } else {
                                  await chatProvider.createChatroom(
                                    driverId,
                                  );
                                  ChatRoom? chatroom =
                                      chatProvider.getChatroom(driverId);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ChatScreen(
                                        chatRoom: chatroom!,
                                      ),
                                    ),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(100, 50),
                                backgroundColor:
                                    const Color.fromARGB(255, 255, 255, 255),
                                shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                ),
                              ),
                              child: const Text(
                                'Message',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 0, 0, 0),
                                  fontSize: 16,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      trip.createdBy != userProfileProvider.userProfile.userID
                          ? ElevatedButton(
                              onPressed: () {
                                try {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              DestinationScreen(trip: trip)));
                                } catch (e) {
                                  logger.e("Encountered an error $e");
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(320, 50),
                                backgroundColor:
                                    const Color.fromARGB(255, 255, 255, 255),
                                shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                ),
                              ),
                              child: const Text(
                                'Send request',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 0, 0, 0),
                                  fontSize: 16,
                                ),
                              ),
                            )
                          : ElevatedButton(
                              onPressed: () {
                                try {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ViewRequestsScreen(
                                                tripId: trip.id!,
                                              )));
                                } catch (e) {
                                  logger.e("Encountered an error $e");
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(320, 50),
                                backgroundColor:
                                    const Color.fromARGB(255, 255, 255, 255),
                                shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                ),
                              ),
                              child: const Text(
                                'View Requests',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 0, 0, 0),
                                  fontSize: 16,
                                ),
                              ),
                            )
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Map Preview",
                  style: TextStyle(
                      color: Color.fromARGB(255, 249, 249, 249),
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: SizedBox(
                    width: 380,
                    height: 220,
                    child: GoogleMap(
                      onMapCreated: (controller) {
                        mapController = controller;
                        initializeMap(trip);
                      },
                      initialCameraPosition: CameraPosition(
                        target: _center,
                        zoom: 20,
                      ),
                      markers: markers.values.toSet(),
                      polylines: polylines.values.toSet(),
                    ),
                  ),
                ),
                if (trip.createdBy == userProfileProvider.userProfile.userID)
                  Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const DestinationSelectionScreen(),
                                    ));

                                // change the status of the trip from to started
                                // tripProvider.updateTripStatus(
                                //     trip.id!, TripStatus.started);

                                // DatabaseService().sendNotification(
                                //     trip.createdBy!,
                                //     "alert",
                                //     "Trip to ${trip.destination} by ${trip.driver!.username} has started");

                                // notify the passengers that supposed to be in that trip

                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) =>
                                //             LocationTrackingMap(
                                //               tripId: trip.id!,
                                //             )));
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color.fromARGB(255, 255, 255, 255),
                                  shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)),
                                  )),
                              child: Text(
                                startTripButton,
                                style: const TextStyle(
                                  color: Color.fromARGB(255, 0, 0, 0),
                                  fontSize: 16,
                                ),
                              )),
                          ElevatedButton(
                              onPressed: () {
//  Cancel a trip
                                tripProvider.cancelTrip(trip.id!);
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color.fromARGB(255, 255, 255, 255),
                                  shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)),
                                  )),
                              child: const Text(
                                "Cancel Trip",
                                style: TextStyle(
                                  color: Color.fromARGB(255, 0, 0, 0),
                                  fontSize: 16,
                                ),
                              )),
                        ],
                      ),
                    ],
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> getDirections(String origin, String destination) async {
    // Use your method to get directions and set polylines
    // For example:
    // var directions = await getDirectionsFromAPI(origin, destination);
    // setPolylines(directions);

    // Dummy implementation
    LatLng originLatLng =
        const LatLng(37.7749, -122.4194); // Example coordinates
    LatLng destinationLatLng = const LatLng(34.0522, -118.2437);

    PolylineId id = const PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.blue,
      points: [originLatLng, destinationLatLng],
      width: 3,
    );

    Marker originMarker = Marker(
      markerId: const MarkerId("origin"),
      position: originLatLng,
    );

    Marker destinationMarker = Marker(
      markerId: const MarkerId("destination"),
      position: destinationLatLng,
    );

    setState(() {
      polylines[id] = polyline;
      markers[const MarkerId("origin")] = originMarker;
      markers[const MarkerId("destination")] = destinationMarker;
      _center = LatLng((originLatLng.latitude + destinationLatLng.latitude) / 2,
          (originLatLng.longitude + destinationLatLng.longitude) / 2);
    });
  }

  Future<void> initializeMap(Trip trip) async {
    final destinationCoordinates = trip.polylinePoints!.last;
    final pickupCoordinates = trip.polylinePoints!.first;

    final List<LatLng> polylinePoints = trip.polylinePoints!;
    if (mounted) {
      setState(() {
        _center = LatLng(
            (pickupCoordinates.latitude + destinationCoordinates.latitude) / 2,
            (pickupCoordinates.longitude + destinationCoordinates.longitude) /
                2);
        print("The center is $_center");
        polylines.clear();
        generatePolyLineFromPoints(polylinePoints);

        markers.clear();
        final destinationMarker = Marker(
          markerId: const MarkerId('destination'),
          position: destinationCoordinates,
          infoWindow: const InfoWindow(title: 'Destination'),
        );
        final pickupMarker = Marker(
          markerId: const MarkerId('pickup'),
          position: pickupCoordinates,
          infoWindow: const InfoWindow(title: 'Pickup'),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        );

        markers[destinationMarker.markerId] = destinationMarker;
        markers[pickupMarker.markerId] = pickupMarker;
      });
    }
    animateToBounds(pickupCoordinates, destinationCoordinates);
  }

  void generatePolyLineFromPoints(List<LatLng> polylinePoints) {
    const id = PolylineId('polyline');
    final polyline = Polyline(
      polylineId: id,
      color: const Color.fromARGB(255, 68, 158, 255),
      points: polylinePoints,
      width: 3,
    );
    if (mounted) {
      setState(() {
        polylines[id] = polyline;
      });
    }
  }

  void animateToBounds(LatLng pickup, LatLng destination) {
    LatLngBounds bounds = LatLngBounds(
      southwest: LatLng(min(pickup.latitude, destination.latitude),
          min(pickup.longitude, destination.longitude)),
      northeast: LatLng(max(pickup.latitude, destination.latitude),
          max(pickup.longitude, destination.longitude)),
    );

    double padding = 50.0;

    mapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, padding));
  }
}

class TripDriverCard extends StatelessWidget {
  final Trip trip;
  final String selectedDriverName;
  final UserProfile userProfile;

  const TripDriverCard({
    super.key,
    required this.trip,
    required this.selectedDriverName,
    required this.userProfile,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[800],
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(userProfile.photoUrl!),
        ),
        title: Text(
          selectedDriverName,
          style: const TextStyle(color: Colors.white),
        ),
        subtitle: Text(
          trip.driver!.make ?? 'Unknown Car Model',
          style: const TextStyle(color: Colors.white70),
        ),
      ),
    );
  }
}
