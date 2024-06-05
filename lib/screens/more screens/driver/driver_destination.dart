import 'package:caravan/models/request.dart';
import 'package:caravan/models/trip.dart';
import 'package:caravan/providers/location_provider.dart';
import 'package:caravan/screens/more%20screens/driver/driver_startpoint.dart';
import 'package:caravan/services/location_service.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:logger/web.dart';
import 'package:provider/provider.dart';

var logger = Logger();

class DriverDestinationScreen extends StatefulWidget {
  const DriverDestinationScreen({super.key});

  @override
  _DriverDestinationScreenState createState() =>
      _DriverDestinationScreenState();
}

class _DriverDestinationScreenState extends State<DriverDestinationScreen> {
  GoogleMapController? mapController;
  DraggableScrollableController scrollController =
      DraggableScrollableController();
  late LocationProvider locationProvider;
  TextEditingController searchController = TextEditingController();
  LatLng? selectedDestination;
  late String selectedDestinationName;
  List<String> suggestions = [];
  static Widget _textFieldIcon = const Icon(Icons.search);
  Trip trip = Trip();
  LocationService locationService = LocationService.getInstance();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    locationProvider = Provider.of<LocationProvider>(context);
    logger.i("Current Position: ${locationProvider.currentPosition}");

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: Container(
          margin: const EdgeInsets.only(left: 15),
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                spreadRadius: 0.5,
                offset: Offset(0.7, 0.7),
              ),
            ],
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back),
            color: const Color.fromARGB(255, 0, 0, 0),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
              onMapCreated: (controller) {
                setState(() {
                  mapController = controller;
                });
              },
              onTap: (position) {
                setState(() {
                  selectedDestination = position;
                });
              },
              initialCameraPosition: CameraPosition(
                target: locationProvider.currentPosition ??
                    const LatLng(0.3453531942815488,
                        30.56664376884249), // Initial map position
                zoom: 13.0,
              ),
              markers: {
                Marker(
                  markerId: const MarkerId('currentPosition'),
                  position: locationProvider.currentPosition ??
                      const LatLng(0.3453531942815488, 30.56664376884249),
                  infoWindow: const InfoWindow(
                    title: 'Current Position',
                  ),
                ),
                if (selectedDestination != null)
                  Marker(
                    markerId: const MarkerId('selectedDestination'),
                    position: selectedDestination!,
                    infoWindow: InfoWindow(
                      title: selectedDestinationName,
                    ),
                  ),
              }),
          Container(
            margin: const EdgeInsets.only(top: 20),
            decoration: const BoxDecoration(),
            child: DraggableScrollableSheet(
              expand: true,
              snapAnimationDuration: const Duration(seconds: 1),
              initialChildSize: 0.4,
              minChildSize: 0.3,
              maxChildSize: 0.8,
              builder:
                  (BuildContext context, ScrollController scrollController) =>
                      Container(
                height: MediaQuery.of(context).size.height * 0.8,
                decoration: const BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10.0,
                      spreadRadius: 0.5,
                      offset: Offset(0.7, 0.7),
                    ),
                  ],
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
                        controller: searchController,
                        onChanged: (testFieldValue) {
                          locationService
                              .getLocationSuggestions(testFieldValue)
                              .then((value) {
                            setState(() {
                              suggestions = value;
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
                              if (suggestions.isNotEmpty)
                                Column(
                                  children: suggestions
                                      .map((location) => ListTile(
                                            leading:
                                                const Icon(Icons.location_on),
                                            title: Text(location),
                                            onTap: () {
                                              setState(() {
                                                trip.destination = location;
                                                selectedDestinationName =
                                                    location;
                                                searchController.text =
                                                    location;
                                                suggestions.clear();
                                              });

                                              // Auto-fill the search bar with the selected location and search for it
                                              if (mounted) {
                                                setState(() {
                                                  searchController.text =
                                                      location;

                                                  suggestions.clear();
                                                });

                                                locationService
                                                    .searchLocation(location)
                                                    .then((value) {
                                                  setState(() {
                                                    selectedDestination = value;
                                                  });

                                                  var trip = Trip(
                                                    destination: location,
                                                    destinationCoordinates:
                                                        value,
                                                    location: locationProvider
                                                        .currentPositionName!,
                                                    pickupCoordinates:
                                                        locationProvider
                                                            .currentPosition!,
                                                  );

                                                  logger.e(
                                                      'Selected Destination: $selectedDestination');
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              DriverStartPointScreen(
                                                                tripRequest:
                                                                    trip,
                                                              )));
                                                });
                                              }

                                              setState(() {
                                                _textFieldIcon =
                                                    const Icon(Icons.search);
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
