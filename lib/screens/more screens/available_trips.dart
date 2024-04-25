import 'package:caravan/components/debouncer.dart';
import 'package:caravan/components/trip_card.dart';
import 'package:caravan/models/trip.dart';
import 'package:caravan/providers/location_provider.dart';
import 'package:caravan/providers/trips_provider.dart';
import 'package:caravan/providers/user_profile.provider.dart';

import 'package:caravan/screens/more%20screens/driver/driver_destination.dart';
import 'package:geolocator/geolocator.dart';
import 'package:caravan/services/database_service.dart';
import 'package:caravan/services/location_service.dart';

import "package:flutter/material.dart";

import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class AvailableTrips extends StatefulWidget {
  const AvailableTrips({super.key});

  @override
  State<AvailableTrips> createState() => _AvailableTripsState();
}

class _AvailableTripsState extends State<AvailableTrips> {
  final TextEditingController _searchController = TextEditingController();
  final logger = Logger();
  late LatLng _currentLocation;

  final List<Trip> _allTrips = [];
  List<Trip> _filteredTrips = [];
  double _searchRadius = 3; // Initial search radius in km.
  final _debouncer = Debouncer(milliseconds: 500);
  @override
  Widget build(BuildContext context) {
    context.read<TripDetailsProvider>();
    _currentLocation =
        context.read<LocationProvider>().currentPosition ?? const LatLng(0, 0);

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
            icon: const Icon(Icons.filter_list, color: Colors.white),
            onPressed: () {
              showModalBottomSheet(
                showDragHandle: true,
                enableDrag: true,
                context: context,
                builder: (context) {
                  return StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                      return Container(
                        height: 200,
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          mainAxisSize: MainAxisSize.values[1],
                          children: [
                            Text(
                                'Search Radius: ${_searchRadius.toStringAsFixed(1)} km'),
                            Slider(
                              value: _searchRadius,
                              min: 1,
                              max: 15,
                              divisions: 14,
                              label: _searchRadius.round().toString(),
                              onChanged: (double value) {
                                setState(() {
                                  _searchRadius = value;
                                });
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
          if (context.read<UserProfileProvider>().userProfile.isDriver)
            IconButton(
              icon: const Icon(Icons.add, color: Colors.white),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const DriverDestinationScreen()));
              },
            ),
        ],
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              controller: _searchController,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: const Color.fromARGB(255, 0, 0, 0),
                  ),
              cursorColor: Colors.black,
              decoration: InputDecoration(
                constraints: const BoxConstraints(
                  maxHeight: 50,
                ),
                suffixIcon: IconButton(
                  constraints: const BoxConstraints(
                    maxHeight: 50,
                  ),
                  icon: const Icon(Icons.search,
                      color: Color.fromARGB(255, 0, 0, 0)),
                  onPressed: () {
                    _searchTrips();
                  },
                ),
                hintText: 'Enter Destination',
                hintStyle: const TextStyle(color: Colors.black),
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
              onChanged: (value) async {
                _debouncer.run(() {
                  _searchTrips();
                });
              },
            ),
          ),
          _filteredTrips.isNotEmpty
              ? Expanded(
                  child: ListView.builder(
                    itemCount: _filteredTrips.length,
                    itemBuilder: (context, index) {
                      final trip = _filteredTrips[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: AvailabeTripCard(trip: trip),
                      );
                    },
                  ),
                )
              : Expanded(
                  child: StreamBuilder<List<Trip>>(
                    stream: DatabaseService().fetchTrips(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                            child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ));
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}',
                            style: const TextStyle(
                              color: Colors.white,
                            ));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(
                          child: Text(
                            'No trips available',
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium
                                ?.copyWith(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                          ),
                        );
                      } else {
                        // Data is available, you can use snapshot.data safely
                        final trips = snapshot.data!;
                        _allTrips.addAll(trips);
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
                ),
        ],
      ),
    );
  }

  void _searchTrips() async {
    String searchText = _searchController.text;
    double searchRadiusInMeters = _searchRadius * 1000; // Convert km to meters.

    if (searchText.isEmpty) {
      setState(() {
        _filteredTrips.clear();
        _filteredTrips =
            List.from(_allTrips); // Create a new list from _allTrips.
      });
    } else {
      // Get the coordinates of the search location.
      LatLng searchLocation =
          await LocationService().searchLocation(searchText);
      setState(() {
        _filteredTrips.clear();

        _filteredTrips = _allTrips.where((trip) {
          // Check if the search location is close enough to any point in the polyline.
          bool isDestinationInPath = trip.polylinePoints!.any((point) {
            double distanceInMeters = Geolocator.distanceBetween(
              searchLocation.latitude,
              searchLocation.longitude,
              point.latitude,
              point.longitude,
            );
            return distanceInMeters <=
                searchRadiusInMeters; // Use the specified search radius.
          });

          // Check if the trip's location is within the specified radius of the current location.
          double distanceFromCurrentLocation = Geolocator.distanceBetween(
            _currentLocation.latitude,
            _currentLocation.longitude,
            trip.polylinePoints!.first.latitude,
            trip.polylinePoints!.first.longitude,
          );

          return isDestinationInPath &&
              distanceFromCurrentLocation <=
                  searchRadiusInMeters; // Use the specified search radius.
        }).toList();
      });
    }
  }

  // void _searchTrips() async {
  //   String searchText = _searchController.text;

  //   // Get the coordinates of the search location.
  //   LatLng searchLocation = await LocationService().searchLocation(searchText);

  //   logger.i("The search location is $searchLocation");
  //   if (searchText.isEmpty) {
  //     setState(() {
  //       _filteredTrips = _allTrips;
  //     });
  //   } else {
  //     setState(() {
  //       _filteredTrips = _allTrips.where((trip) {
  //         // Check if the search location is close enough to any point in the polyline.
  //         bool isDestinationInPath = trip.polylinePoints!.any((point) {
  //           double distanceInMeters = Geolocator.distanceBetween(
  //             searchLocation.latitude,
  //             searchLocation.longitude,
  //             point.latitude,
  //             point.longitude,
  //           );
  //           return distanceInMeters <=
  //               3000; // 3km threshold for destination in path.
  //         });

  //         // Check if the trip's location is within a 3km radius of the current location.
  //         double distanceFromCurrentLocation = Geolocator.distanceBetween(
  //           _currentLocation.latitude,
  //           _currentLocation.longitude,
  //           trip.polylinePoints!.first.latitude,
  //           trip.polylinePoints!.first.longitude,
  //         );

  //         logger.i(
  //             'The distance from the current location is ${distanceFromCurrentLocation / 1000} kms');

  //         return isDestinationInPath &&
  //             distanceFromCurrentLocation <=
  //                 _searchRadius * 1000; // 3km threshold for trip's location.
  //       }).toList();
  //     });
  //   }
  // }
}
