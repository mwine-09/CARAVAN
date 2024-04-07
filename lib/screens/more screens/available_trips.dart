import 'package:caravan/models/trip.dart';
import 'package:caravan/providers/trips_provider.dart';
import 'package:caravan/screens/more%20screens/trip_details.dart';
import "package:flutter/material.dart";
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AvailableTrips extends StatelessWidget {
  const AvailableTrips({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tripProvider = context.read<TripDetailsProvider>();

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 0, 0, 0),
      appBar: AppBar(
        title: const Text(
          'Available Trips',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.black,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('/trips').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final trips = snapshot.data?.docs;
            final tripsList =
                trips?.map((doc) => Trip.fromFirestore(doc)).toList() ?? [];

            return ListView.builder(
              itemCount: tripsList.length,
              itemBuilder: (context, index) {
                final trip = tripsList[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AvailabeTripCard(trip: trip),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return const Center(
              child: SizedBox(
                width: 100,
                height: 100,
                child: CircularProgressIndicator(
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

class AvailabeTripCard extends StatelessWidget {
  const AvailabeTripCard({
    Key? key,
    required this.trip,
  }) : super(key: key);

  final Trip trip;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      color: const Color.fromARGB(255, 22, 22, 22),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(width: 10),
                Container(
                  width: 100,
                  height: 100,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/default_profile.jpg'),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Destination: ${trip.destination}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "PickUp: ${trip.location}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "Date: ${DateFormat.yMMMMd().format(trip.dateTime)}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "Time: ${DateFormat.jm().format(trip.dateTime)}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
              child: ElevatedButton(
                onPressed: () {
                  final tripProvider =
                      Provider.of<TripDetailsProvider>(context, listen: false);
                  tripProvider.setTripDetails(trip);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TripDetailsScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(320, 50),
                  backgroundColor: Color.fromARGB(255, 255, 255, 255),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                ),
                child: const Text(
                  'Request Trip',
                  style: TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
