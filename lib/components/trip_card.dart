import 'package:caravan/models/trip.dart';
import 'package:caravan/providers/trips_provider.dart';
import 'package:caravan/screens/more%20screens/trip_details.dart';
import 'package:caravan/services/database_service.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:logger/web.dart';
import 'package:provider/provider.dart';

class AvailabeTripCard extends StatelessWidget {
  const AvailabeTripCard({
    super.key,
    required this.trip,
  });

  final Trip trip;

  @override
  Widget build(BuildContext context) {
    final logger = Logger();

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
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: trip.driver?.photoUrl != null
                          ? NetworkImage(trip.driver!.photoUrl!)
                          : const AssetImage('assets/default_profile.jpg')
                              as ImageProvider,
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "PickUp: ${trip.location}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          overflow: TextOverflow.visible,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "Destination: ${trip.destination}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          overflow: TextOverflow.visible,
                        ),
                        softWrap: true,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "Date: ${DateFormat.yMMMMd().format(trip.dateTime!)}",
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "Time: ${DateFormat.jm().format(trip.dateTime!)}",
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
              child: ElevatedButton(
                onPressed: () {
                  try {
                    tripProvider.setTripDetails(trip);
                    final driverID = trip.createdBy;
                    print("The driver id is $driverID");
                    DatabaseService().getUserProfile(driverID!).then((value) {
                      logger.i("The trip was created by $value");
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              TripDetailsScreen(userProfile: value),
                        ),
                      );
                    }).catchError((e) {
                      print('Error fetching user profile: $e');
                    });
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
