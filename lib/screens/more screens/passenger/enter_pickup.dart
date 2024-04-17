import 'package:caravan/models/request.dart';
import 'package:caravan/services/location_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as location;
import 'package:logger/web.dart';

var logger = Logger();

class PickupLocationScreen extends StatefulWidget {
  final TripRequest tripRequest;

  const PickupLocationScreen({super.key, required this.tripRequest});

  @override
  State<PickupLocationScreen> createState() => _PickupLocationScreenState();
}

class _PickupLocationScreenState extends State<PickupLocationScreen> {
  late GoogleMapController _googleMapController;
  late LocationService locationService;
  late PolylinePoints polylinePoints;
  late PolylineResult polylineResult;
  late List<LatLng> polylineCoordinates = [];
  late Set<Polyline> polylines = {};
  late String destinationText = '';
  var locationSuggestions = [];

  TextEditingController destinationController = TextEditingController();
  var initialCameraPosition = const LatLng(0, 0);
  var currentPosition = const LatLng(0, 0);
  var currentPositionName = '';
  Set<Marker> markers = {};
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    initializeMap();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: currentPosition,
              zoom: 14.4746,
            ),
            onMapCreated: (GoogleMapController controller) {
              _googleMapController = controller;
            },
            markers: markers,
          ),
          Column(
            children: [
              const SizedBox(
                height: 60,
              ),
              Row(
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromARGB(255, 115, 115, 115),
                          blurRadius: 5,
                          spreadRadius: 0.1,
                          offset: Offset(0, 0),
                        ),
                      ],
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 70,
                  ),
                  const Text(
                    'Enter Destination',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
          Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.8,
                  child: DraggableScrollableSheet(
                      initialChildSize: 0.4,
                      minChildSize: 0.3,
                      maxChildSize: 0.8,
                      builder: (BuildContext context,
                              ScrollController scrollController) =>
                          SingleChildScrollView(
                            controller: scrollController,
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.8,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                              ),
                              padding: const EdgeInsets.all(20),
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    const Row(
                                      children: [
                                        Text(
                                          'Pickup Location',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    SizedBox(
                                      // child: TextField(
                                      //   controller: destinationController,
                                      //   onChanged: (testFieldValue) {
                                      //     LocationService()
                                      //         .getLocationSuggestions(
                                      //             testFieldValue)
                                      //         .then((value) {
                                      //       setState(() {
                                      //         locationSuggestions = value;
                                      //       });
                                      //     });
                                      //   },
                                      //   cursorColor: Colors.black,
                                      //   decoration: InputDecoration(
                                      //       hintText: 'Enter Destination',
                                      //       hintStyle: const TextStyle(
                                      //           color: Colors.black),
                                      //       prefixIcon:
                                      //           const Icon(Icons.search),
                                      //       fillColor: Colors.white,
                                      //       filled: true,
                                      //       border: OutlineInputBorder(
                                      //         borderRadius:
                                      //             BorderRadius.circular(20),
                                      //         borderSide:
                                      //             const BorderSide(width: 0.8),
                                      //       ),
                                      //       focusedBorder: OutlineInputBorder(
                                      //         borderRadius:
                                      //             BorderRadius.circular(20),
                                      //         borderSide: const BorderSide(
                                      //           width: 0.8,
                                      //           color: Colors.black,
                                      //         ),
                                      //       )),
                                      // ),

                                      child: Text(
                                        'Pickup: ${widget.tripRequest.source}',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    SizedBox(
                                        child: Text(
                                      'Destination: ${widget.tripRequest.destination}',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )),
                                    if (locationSuggestions.isNotEmpty)
                                      Column(
                                        children: locationSuggestions
                                            .map((location) => ListTile(
                                                  leading: const Icon(
                                                      Icons.location_on),
                                                  title: Text(location),
                                                  onTap: () {
                                                    // Auto-fill the search bar with the selected location and search for it
                                                    if (mounted) {
                                                      setState(() {
                                                        destinationText =
                                                            location;
                                                        destinationController
                                                            .text = location;

                                                        locationSuggestions
                                                            .clear();
                                                      });

                                                      LocationService()
                                                          .searchLocation(
                                                              destinationText)
                                                          .then((value) {
                                                        setState(() {
                                                          markers.clear();
                                                          markers.add(Marker(
                                                            markerId:
                                                                const MarkerId(
                                                                    'dest'),
                                                            position: LatLng(
                                                                value.latitude,
                                                                value
                                                                    .longitude),
                                                          ));
                                                        });

                                                        _googleMapController.animateCamera(
                                                            CameraUpdate.newCameraPosition(
                                                                CameraPosition(
                                                                    target: LatLng(
                                                                        value
                                                                            .latitude,
                                                                        value
                                                                            .longitude),
                                                                    zoom:
                                                                        14.4746)));
                                                      });
                                                    }
                                                  },
                                                ))
                                            .toList(),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ))))
        ],
      ),
    );
  }

  Future<void> initializeMap() async {
    logger.i('Initializing map');
    final location.Location locationController = location.Location();
    bool serviceEnabled;
    location.PermissionStatus permissionGranted;

    serviceEnabled = await locationController.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await locationController.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await locationController.hasPermission();
    if (permissionGranted == location.PermissionStatus.denied) {
      permissionGranted = await locationController.requestPermission();
      if (permissionGranted != location.PermissionStatus.granted) {
        return;
      }
    }

    logger.i('Location services enabled');

    locationController.onLocationChanged
        .listen((location.LocationData currentLocation) async {
      if (currentLocation.latitude != null &&
          currentLocation.longitude != null) {
        currentPosition =
            LatLng(currentLocation.latitude!, currentLocation.longitude!);

        _googleMapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: currentPosition,
              zoom: 14.4746,
            ),
          ),
        );
        currentPositionName = await LocationService()
            .getPlaceName(currentPosition.latitude, currentPosition.longitude);
        logger.i(currentPositionName);
        setState(() {});
      }
    });

    logger.i('Getting initial location');

    location.LocationData? initialLocation =
        await locationController.getLocation();
    setState(() async {
      currentPosition =
          LatLng(initialLocation.latitude!, initialLocation.longitude!);
      isLoading = false;

      currentPositionName = await LocationService()
          .getPlaceName(currentPosition.latitude, currentPosition.longitude);
      logger.i(currentPositionName);
    });
  }
}
