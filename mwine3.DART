import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:caravan/constants.dart';
import 'package:caravan/services/location_service.dart';

import 'package:flutter_polyline_points/flutter_polyline_points.dart';

import 'package:location/location.dart' as location;
import 'package:logger/logger.dart';

final logger = Logger();

class DestinationScreen extends StatefulWidget {
  const DestinationScreen({super.key});

  @override
  State<DestinationScreen> createState() => _DestinationScreenState();
}

class _DestinationScreenState extends State<DestinationScreen> {
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
  Set<Marker> markers = {};
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initializeMap();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: currentPosition,
                zoom: 14.4746,
              ),
              mapType: MapType.normal,
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
                                   
                                        SizedBox(
                                          width: 20,
                                          child: TextField(
                                            controller: destinationController,
                                            onChanged: (testFieldValue) {
                                              LocationService()
                                                  .getLocationSuggestions(
                                                      testFieldValue)
                                                  .then((value) {
                                                setState(() {
                                                  locationSuggestions = value;
                                                });
                                              });
                                            },
                                            cursorColor: Colors.black,
                                            decoration: InputDecoration(
                                                hintText: 'Enter Destination',
                                                hintStyle: const TextStyle(
                                                    color: Colors.black),
                                                prefixIcon:
                                                    const Icon(Icons.search),
                                                fillColor: Colors.white,
                                                filled: true,
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  borderSide: const BorderSide(
                                                      width: 0.8),
                                                ),
                                                focusedBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  borderSide: const BorderSide(
                                                    width: 0.8,
                                                    color: Colors.black,
                                                  ),
                                                )),
                                          ),
                                        ),
                                         
                                      
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        // Get the destination coordinates
                                        LocationService()
                                            .searchLocation(destinationText)
                                            .then((value) {
                                          setState(() {
                                            markers.clear();
                                            markers.add(Marker(
                                              markerId: const MarkerId('dest'),
                                              position: LatLng(value.latitude,
                                                  value.longitude),
                                            ));
                                          });

                                          _googleMapController.animateCamera(
                                              CameraUpdate.newCameraPosition(
                                                  CameraPosition(
                                                      target: LatLng(
                                                          value.latitude,
                                                          value.longitude),
                                                      zoom: 14.4746)));
                                        });
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.black,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 100, vertical: 20),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                      ),
                                      child: const Text('Confirm Destination'),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
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
                                                    }
                                                  },
                                                ))
                                            .toList(),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                      
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );

    
        
    
  }

  Future<void> initializeMap() async {
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

    locationController.onLocationChanged
        .listen((location.LocationData currentLocation) {
      if (currentLocation.latitude != null &&
          currentLocation.longitude != null) {
        setState(() {
          currentPosition =
              LatLng(currentLocation.latitude!, currentLocation.longitude!);
        });
      }
    });

    location.LocationData? initialLocation =
        await locationController.getLocation();
    if (initialLocation.latitude != null && initialLocation.longitude != null) {
      setState(() {
        currentPosition =
            LatLng(initialLocation.latitude!, initialLocation.longitude!);
        isLoading = false;
      });
    }
  }
}
