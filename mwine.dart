import 'package:caravan/constants.dart';
import 'package:caravan/models/trip.dart';
import 'package:caravan/providers/trips_provider.dart';
import 'package:caravan/services/location_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TripDetailsScreen extends StatefulWidget {
  const TripDetailsScreen({Key? key}) : super(key: key);

  @override
  State<TripDetailsScreen> createState() => _TripDetailsScreenState();
}

class _TripDetailsScreenState extends State<TripDetailsScreen> {
  late Trip trip;
  late GoogleMapController mapController;
  Map<PolylineId, Polyline> polylines = {};

  @override
  void initState() {
    super.initState();
    trip = Provider.of<TripDetailsProvider>(context, listen: false).tripDetails!;
    initializeMap();
  }

  Future<void> initializeMap() async {
    final coordinates = await Future.wait([
      LocationService().searchLocation(trip.destination),
      LocationService().searchLocation(trip.location),
    ]);
    final destinationCoordinates = coordinates[0];
    final pickupCoordinates = coordinates[1];

    final List<LatLng> polylinePoints = await fetchPolylinePoints(
      pickupCoordinates,
      destinationCoordinates,
    );

    setState(() {
      polylines.clear();
      generatePolyLineFromPoints(polylinePoints);
    });
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
      color: const Color.fromARGB(255, 68, 255, 71),
      points: polylinePoints,
      width: 3,
    );
    setState(() {
      polylines[id] = polyline;
    });
  }

  @override
  Widget build(BuildContext context) {
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
            // TripDriverCard(trip: trip),
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
                      child: GoogleMap(
                        onMapCreated: (controller) {
                          mapController = controller;
                        },
                        initialCameraPosition: const CameraPosition(
                          target: LatLng(0, 0),
                          zoom: 15,
                        ),
                        markers: {
                          Marker(
                            markerId: MarkerId('destination'),
                            position: LatLng(0, 0),
                            infoWindow: const InfoWindow(title: 'Destination'),
                          ),
                          Marker(
                            markerId: MarkerId('pickup'),
                            position: LatLng(0, 0),
                            infoWindow: const InfoWindow(title: 'Pickup'),
                          ),
                        },
                        polylines: polylines.values.toSet(),
                      ),
                    ),
                  ]),
            ),
          ],
        ),
      ),
    );
  }
}
