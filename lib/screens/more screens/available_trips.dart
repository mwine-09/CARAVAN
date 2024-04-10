import 'package:caravan/models/trip.dart';
import 'package:caravan/providers/trips_provider.dart';
import 'package:caravan/screens/more%20screens/create_trip.dart';
import 'package:caravan/screens/more%20screens/trip_details.dart';
import 'package:caravan/services/database_service.dart';
import "package:flutter/material.dart";
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AvailableTrips extends StatelessWidget {
  const AvailableTrips({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<TripDetailsProvider>();

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      appBar: AppBar(
        title: Text('Available Trips',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                )),
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CreateTripScreen()));
            },
          ),
        ],
        backgroundColor: Colors.black,
      ),
      body: StreamBuilder<List<Trip>>(
        stream: DatabaseService().fetchTrips(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}',
                style: const TextStyle(
                  color: Colors.white,
                ));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Text(
              'No data available',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Colors.white,
                    fontSize: 20,
                  ),
            );
          } else {
            // Data is available, you can use snapshot.data safely
            final trips = snapshot.data!;
            return ListView.builder(
              itemCount: trips.length,
              itemBuilder: (context, index) {
                final trip = trips[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AvailabeTripCard(trip: trip),
                );
              },
            );
          }
        },
      ),
    );
  }
}

class AvailabeTripCard extends StatelessWidget {
  const AvailabeTripCard({
    super.key,
    required this.trip,
  });

  final Trip trip;

  @override
  Widget build(BuildContext context) {
    final tripProvider =
        Provider.of<TripDetailsProvider>(context, listen: true);
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
                const SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Destination: ${trip.destination}",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "PickUp: ${trip.location}",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "Date: ${DateFormat.yMMMMd().format(trip.dateTime)}",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "Time: ${DateFormat.jm().format(trip.dateTime)}",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                    ),
                  ],
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
              child: ElevatedButton(
                onPressed: () async {
                  try {
                    tripProvider.setTripDetails(trip);
                    final driverID = trip.driverID;
                    print(driverID);
                    final userProfile =
                        await DatabaseService().getUserProfile(driverID);
                    print(userProfile);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            TripDetailsScreen(userProfile: userProfile),
                      ),
                    );
                  } catch (e) {
                    print('Error fetching user profile: $e');
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(320, 50),
                  backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                ),
                child: Text('See More About This Trip',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: Colors.black,
                          fontSize: 18,
                        )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
