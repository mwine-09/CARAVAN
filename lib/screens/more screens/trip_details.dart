import 'package:caravan/constants.dart';
import 'package:caravan/models/trip.dart';
import 'package:caravan/providers/trips_provider.dart';
// import 'package:caravan/screens/more%20screens/request_trip.dart';
import 'package:caravan/services/location_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TripDetailsScreen extends StatefulWidget {
  const TripDetailsScreen({super.key});

  @override
  State<TripDetailsScreen> createState() => _TripDetailsScreenState();
}

class _TripDetailsScreenState extends State<TripDetailsScreen> {
  Map<PolylineId, Polyline> polylines = {};

  @override
  Widget build(BuildContext context) {
    final tripProvider = Provider.of<TripDetailsProvider>(context);

    final trip = tripProvider.tripDetails;

    final destinationCoordinates =
        LocationService().searchLocation(trip!.destination);
    final pickupLocationCoordinates =
        LocationService().searchLocation(trip.location);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: const Text(
          'John Doe',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SafeArea(
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
            TripDriverCard(trip: trip),
            const SizedBox(height: 5),
            const Text(
              "Trip Details",
              style: TextStyle(
                  color: Color.fromARGB(255, 249, 249, 249),
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 22, 22, 22),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "From: ${trip.location}",
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 14),
                            ),
                            Text(
                              "To: ${trip.destination}",
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 14),
                            ),
                            Text(
                              "Number of stops: ${trip.availableSeats}",
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 14),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(320, 50),
                        backgroundColor: Color.fromARGB(255, 255, 255, 255),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                      ),
                      child: const Text(
                        'Send request',
                        style: TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Row(
                      children: [
                        Text(
                          "Route Map",
                          style: TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: 380,
                      height: 220,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16)),
                      child: FutureBuilder<List<LatLng>>(
                        future: Future.wait([
                          LocationService().searchLocation(trip.destination),
                          LocationService().searchLocation(trip.location),
                        ]),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                semanticsLabel: "Loading map...",
                              ),
                            );
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            final List<LatLng> coordinates = snapshot.data!;
                            final LatLng destinationCoordinates =
                                coordinates[0];
                            final LatLng pickupCoordinates = coordinates[1];
                            fetchPolylinePoints(
                                pickupCoordinates, destinationCoordinates);
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: GoogleMap(
                                initialCameraPosition: CameraPosition(
                                  target: destinationCoordinates,
                                  zoom: 15,
                                ),
                                markers: {
                                  Marker(
                                    markerId: const MarkerId('destination'),
                                    position: destinationCoordinates,
                                    infoWindow:
                                        const InfoWindow(title: 'Destination'),
                                  ),
                                  Marker(
                                    markerId: const MarkerId('pickup'),
                                    position: pickupCoordinates,
                                    infoWindow:
                                        const InfoWindow(title: 'Pickup'),
                                  ),
                                },
                                polylines: polylines.values.toSet(),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ]),
            ),
          ],
        ),
      ),
    );
  }

  Future<List<LatLng>> fetchPolylinePoints(
      LatLng pickup, LatLng destinationAddress) async {
    final polylinePoints = PolylinePoints();
    final result = await polylinePoints.getRouteBetweenCoordinates(
      googleMapsApiKey,
      PointLatLng(pickup.latitude, pickup.longitude),
      PointLatLng(destinationAddress.latitude, destinationAddress.longitude),
    );
    if (result.points.isNotEmpty) {
      final List<LatLng> polylineCoordinates = result.points
          .map((point) => LatLng(point.latitude, point.longitude))
          .toList();
      generatePolyLineFromPoints(polylineCoordinates);
      return polylineCoordinates;
    } else {
      debugPrint(result.errorMessage);
      return [];
    }
  }

  void generatePolyLineFromPoints(List<LatLng> polylinePoints) {
    final id = PolylineId('polyline');
    final polyline = Polyline(
      polylineId: id,
      color: Colors.blueAccent,
      points: polylinePoints,
      width: 3,
    );
    setState(() {
      polylines[id] = polyline;
    });
  }
}

class TripDriverCard extends StatelessWidget {
  const TripDriverCard({
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
            Center(
              child: Row(
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
                      const Row(
                        children: [
                          Text(
                            "Driver Name: ",
                            style: TextStyle(
                              color: Color.fromARGB(255, 255, 255, 255),
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Text(
                            "John Doe",
                            style: TextStyle(
                              color: Color.fromARGB(255, 255, 255, 255),
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      const Row(
                        children: [
                          Text(
                            "Number Plate: ",
                            style: TextStyle(
                              color: Color.fromARGB(255, 255, 255, 255),
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Text(
                            "UBQ 876G",
                            style: TextStyle(
                              color: Color.fromARGB(255, 255, 255, 255),
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(height: 5),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          const Text(
                            "Available Seats: ",
                            style: TextStyle(
                              color: Color.fromARGB(255, 255, 255, 255),
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            "${trip.availableSeats}",
                            style: const TextStyle(
                              color: Color.fromARGB(255, 255, 255, 255),
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
              child: ElevatedButton(
                onPressed: () {
                  // final tripProvider =
                  //     Provider.of<TripDetailsProvider>(context, listen: false);
                  // tripProvider.setTripDetails(trip);
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //       builder: (context) => TripDetailsScreen()),
                  // );
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(320, 50),
                  backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                ),
                child: const Text(
                  'See Full Profile',
                  style: TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontSize: 16,
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
