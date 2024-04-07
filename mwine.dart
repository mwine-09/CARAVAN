class TripDetailsScreen extends StatefulWidget {
  const TripDetailsScreen({super.key});

  @override
  State<TripDetailsScreen> createState() => _TripDetailsScreenState();
}

class _TripDetailsScreenState extends State<TripDetailsScreen> {
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> coordinates = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCoordinates();
  }

  Future<void> fetchCoordinates() async {
    final tripProvider = Provider.of<TripDetailsProvider>(context, listen: false);
    final trip = tripProvider.tripDetails;

    final List<LatLng> fetchedCoordinates = await Future.wait([
      LocationService().searchLocation(trip!.destination),
      LocationService().searchLocation(trip.location),
    ]);

    setState(() {
      coordinates = fetchedCoordinates;
      isLoading = false;
    });

    fetchPolylinePoints(coordinates[1], coordinates[0]);
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
                      child: isLoading
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                semanticsLabel: "Loading map...",
                              ),
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: GoogleMap(
                                initialCameraPosition: CameraPosition(
                                  target: coordinates[0],
                                  zoom: 15,
                                ),
                                markers: {
                                  Marker(
                                    markerId: const MarkerId('destination'),
                                    position: coordinates[0],
                                    infoWindow:
                                        const InfoWindow(title: 'Destination'),
                                  ),
                                  Marker(
                                    markerId: const MarkerId('pickup'),
                                    position: coordinates[1],
                                    infoWindow:
                                        const InfoWindow(title: 'Pickup'),
                                  ),
                                },
                                polylines: polylines.values.toSet(),
                              ),
                            ),
                    ),
                  ]),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> fetchPolylinePoints(
      LatLng pickup, LatLng destinationAddress) async {
    final polylinePoints = PolylinePoints();
    final result = await polylinePoints.getRouteBetweenCoordinates(
      googleMapsApiKey,
      PointLatLng(pickup.latitude, pickup.longitude),
      PointLatLng(destinationAddress.latitude, destinationAddress.longitude),
    );
    if (result.points.isNotEmpty) {
      final List<LatLng> points = result.points
          .map((point) => LatLng(point.latitude, point.longitude))
          .toList();
      generatePolyLineFromPoints(points);
    } else {
      debugPrint(result.errorMessage);
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
