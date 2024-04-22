import 'package:caravan/models/request.dart';
import 'package:caravan/providers/location_provider.dart';
import 'package:caravan/screens/more%20screens/passenger/enter_pickup.dart';
import 'package:caravan/services/location_service.dart';

import 'package:flutter/material.dart';

import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:logger/web.dart';
import 'package:provider/provider.dart';

var logger = Logger();

class DestinationScreen extends StatefulWidget {
  const DestinationScreen({super.key});

  @override
  _DestinationScreenState createState() => _DestinationScreenState();
}

class _DestinationScreenState extends State<DestinationScreen> {
  TripRequest tripRequest = TripRequest();
  late GoogleMapController mapController;
  late LocationService locationService;
  late PolylinePoints polylinePoints;
  late PolylineResult polylineResult;
  late List<LatLng> polylineCoordinates = [];
  late Set<Polyline> polylines = {};
  late String destinationText;
  var locationSuggestions = [];
  static Widget _textFieldIcon = const Icon(Icons.search);

  late LatLng destinationCoordinates;
  late LocationProvider locationProvider;

  TextEditingController destinationController = TextEditingController();
  var initialCameraPosition = const LatLng(0, 0);
  late LatLng? currentPosition;
  Set<Marker> markers = {};
  bool isLoading = true;

  String? currentPositionName;
  @override
  void initState() {
    super.initState();

    // }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    currentPosition = context.watch<LocationProvider>().currentPosition;
    currentPositionName = context.watch<LocationProvider>().currentPositionName;

    // if (currentPosition != null) {
    markers.add(
      Marker(
        markerId: const MarkerId('current'),
        position: currentPosition!,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme:
            const IconThemeData(color: Color.fromARGB(255, 255, 255, 255)),
        leading: Container(
          margin: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back),
            color: Colors.black,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        // Add the title,
        elevation: 0,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.black,
              ),
            )
          : Stack(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: IgnorePointer(
                    ignoring: false,
                    child: GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: currentPosition!,
                        zoom: 14.4746,
                      ),
                      onMapCreated: (GoogleMapController controller) {
                        mapController = controller;
                      },
                      markers: markers,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 20),
                  decoration: const BoxDecoration(),
                  child: DraggableScrollableSheet(
                    expand: true,
                    snapAnimationDuration: const Duration(seconds: 1),
                    initialChildSize: 0.5,
                    minChildSize: 0.3,
                    maxChildSize: 0.8,
                    builder: (BuildContext context,
                            ScrollController scrollController) =>
                        Container(
                      height: MediaQuery.of(context).size.height * 0.8,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          const Row(
                            children: [
                              Icon(
                                Icons.car_rental,
                                color: Colors.black,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                'Where are you going?',
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          SizedBox(
                            child: TextField(
                              controller: destinationController,
                              onChanged: (testFieldValue) {
                                LocationService()
                                    .getLocationSuggestions(testFieldValue)
                                    .then((value) {
                                  setState(() {
                                    locationSuggestions = value;
                                  });
                                });
                              },
                              cursorColor: Colors.black,
                              decoration: InputDecoration(
                                hintText: 'Enter Destination',
                                hintStyle: const TextStyle(color: Colors.black),
                                prefixIcon: _textFieldIcon,
                                fillColor: Colors.white,
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: const BorderSide(width: 0.8),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: const BorderSide(
                                    width: 0.8,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height *
                                  0.5, // Adjust the height of the scrollable list
                              child: SingleChildScrollView(
                                controller:
                                    scrollController, // Add the scroll controller to the SingleChildScrollView
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    if (locationSuggestions.isNotEmpty)
                                      Column(
                                        children: locationSuggestions
                                            .map((location) => ListTile(
                                                  leading: const Icon(
                                                      Icons.location_on),
                                                  title: Text(location),
                                                  onTap: () {
                                                    setState(() {
                                                      _textFieldIcon =
                                                          const SizedBox(
                                                              width: 10,
                                                              height: 10,
                                                              child:
                                                                  SpinKitChasingDots(
                                                                color: Colors
                                                                    .black,
                                                                size: 10.0,
                                                              ));
                                                    });

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
                                                          destinationCoordinates =
                                                              value;

                                                          tripRequest
                                                                  .destinationCoordinates =
                                                              value;

                                                          tripRequest
                                                                  .destination =
                                                              destinationText;

                                                          tripRequest.source =
                                                              locationProvider
                                                                  .currentPositionName;
                                                          tripRequest
                                                                  .pickupCoordinates =
                                                              locationProvider
                                                                      .currentPosition ??
                                                                  initialCameraPosition;
                                                        });

                                                        logger.e(tripRequest
                                                            .destinationCoordinates);
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                PickupLocationScreen(
                                                              tripRequest:
                                                                  tripRequest,
                                                            ),
                                                          ),
                                                        );
                                                      });
                                                    }

                                                    setState(() {
                                                      _textFieldIcon =
                                                          const Icon(
                                                              Icons.search);
                                                    });
                                                  },
                                                ))
                                            .toList(),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
