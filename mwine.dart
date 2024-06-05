import 'dart:math';
import 'package:caravan/models/trip.dart';
import 'package:caravan/providers/location_provider.dart';
import 'package:caravan/screens/more%20screens/create_trip.dart';

import 'package:caravan/services/location_service.dart';

import 'package:flutter/material.dart';

import 'package:flutter_polyline_points/flutter_polyline_points.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:logger/web.dart';
import 'package:provider/provider.dart';

var logger = Logger();

class DriverStartPointScreen extends StatefulWidget {
  final Trip tripRequest;

  const DriverStartPointScreen({super.key, required this.tripRequest});

  @override
  State<DriverStartPointScreen> createState() => _DriverStartPointScreenState();
}

class _DriverStartPointScreenState extends State<DriverStartPointScreen> {
  late GoogleMapController _googleMapController;
  LocationService locationService = LocationService.getInstance();
  late PolylinePoints polylinePoints;
  late PolylineResult polylineResult;
  late List<LatLng> polylineCoordinates = [];
  static Map<PolylineId, Polyline> polylines = {};

  late String pickUpLocationQuery = '';
  var locationSuggestions = [];
  late LocationProvider locationProvider;
  final key = GlobalKey();
  bool isChooseCustomPickUp = false;
  static Widget _textFieldIcon = const Icon(Icons.search);

  TextEditingController pickupFieldController = TextEditingController();
  var initialCameraPosition = const LatLng(0, 0);
  var currentPosition = const LatLng(0, 0);
  var currentPositionName = '';
  final Set<Marker> _markers = {};
  bool isLoading = true;
  var pickupLocation = '';

  LatLng pickupCoordinates = const LatLng(0, 0);
  @override
  void initState() {
    super.initState();
    locationProvider = Provider.of<LocationProvider>(context, listen: false);
    logger.i('Location Provider: ${locationProvider.currentPositionName}');
    pickupLocation = locationProvider.currentPositionName ?? '';
    updateMap(widget.tripRequest.pickupCoordinates!,
        widget.tripRequest.pickupCoordinates!);
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
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
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(locationProvider.currentPosition!.latitude,
                  locationProvider.currentPosition!.longitude),
              zoom: 14.4746,
            ),
            onMapCreated: (GoogleMapController controller) {
              _googleMapController = controller;
            },
            markers: _markers,
            polylines: polylines.values.toSet(),
          ),
          !isChooseCustomPickUp
              ? DraggableScrollableSheet(
                  initialChildSize: 0.5,
                  minChildSize: 0.4,
                  maxChildSize: 0.8,
                  builder: (BuildContext context,
                          ScrollController scrollController) =>
                      Expanded(
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.8,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 0, horizontal: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        isChooseCustomPickUp = true;
                                      });
                                    },
                                    child: const Text(
                                      'Edit',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
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
                                      height: 10,
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.9,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 10),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(
                                            Icons.location_on,
                                            color: Colors.black,
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Flexible(
                                            child: Text(
                                              pickupLocation,
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              softWrap: true,
                                              overflow: TextOverflow.visible,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    const Row(
                                      children: [
                                        Text(
                                          'Destination:',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          softWrap: true,
                                          overflow: TextOverflow.visible,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.9,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 10),
                                        decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(
                                              Icons.location_on,
                                              color: Colors.black,
                                            ),
                                            const SizedBox(
                                              width: 16,
                                            ),
                                            Flexible(
                                              child: Text(
                                                '${widget.tripRequest.destination}',
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                softWrap: true,
                                                overflow: TextOverflow.visible,
                                              ),
                                            ),
                                          ],
                                        )),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Align(
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.black,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 30, vertical: 16),
                                        ),
                                        onPressed: () {
                                          var trip = Trip();
                                          trip.destination =
                                              widget.tripRequest.destination;
                                          trip.location = pickupLocation;
                                          trip.polylinePoints =
                                              polylineCoordinates;
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: ((context) =>
                                                      CreateTripScreen(
                                                          tripdetails: trip))));
                                        },
                                        child: Text(
                                          'Create Trip',
                                          style: theme.textTheme.titleLarge!
                                              .copyWith(
                                                  color: Colors.white,
                                                  letterSpacing: 0.5),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ))
              : Container(
                  margin: const EdgeInsets.only(top: 20),
                  decoration: const BoxDecoration(),
                  child: DraggableScrollableSheet(
                    expand: true,
                    snapAnimationDuration: const Duration(seconds: 1),
                    initialChildSize: 0.5,
                    minChildSize: 0.2,
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
                          Row(
                            children: [
                              const Icon(
                                Icons.car_rental,
                                color: Colors.black,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                'Choose Pickup Location',
                                style: theme.textTheme.titleLarge!.copyWith(
                                  color: Colors.black,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          SizedBox(
                            child: TextField(
                              controller: pickupFieldController,
                              onChanged: (testFieldValue) {
                                locationService
                                    .getLocationSuggestions(testFieldValue)
                                    .then((value) {
                                  setState(() {
                                    locationSuggestions = value;
                                  });
                                });
                              },
                              cursorColor: Colors.black,
                              decoration: InputDecoration(
                                hintText: 'Enter Pickup Location',
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
                                                    // Auto-fill the search bar with the selected location and search for it
                                                    if (mounted) {
                                                      setState(() {
                                                        pickUpLocationQuery =
                                                            location;
                                                        pickupFieldController
                                                            .text = location;

                                                        locationSuggestions
                                                            .clear();
                                                      });

                                                      locationService
                                                          .searchLocation(
                                                              pickUpLocationQuery)
                                                          .then((value) {
                                                        setState(() {
                                                          pickupCoordinates =
                                                              value;

                                                          widget.tripRequest
                                                                  .pickupCoordinates =
                                                              value;

                                                          widget.tripRequest
                                                                  .location =
                                                              pickUpLocationQuery;
                                                        });
                                                        logger.e(widget
                                                            .tripRequest
                                                            .pickupCoordinates);

                                                        setState(() {
                                                          pickupLocation =
                                                              pickUpLocationQuery;
                                                          updateMap(
                                                              widget.tripRequest
                                                                  .pickupCoordinates!,
                                                              widget.tripRequest
                                                                  .destinationCoordinates!);
                                                          isChooseCustomPickUp =
                                                              false;
                                                        });
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

  // generatePolyLinefromPoints
  Future<void> generatePolyLineFromPoints(List<LatLng> polylinePoints) async {
    const id = PolylineId('polyline');
    final polyline = Polyline(
        polylineId: id,
        color: Colors.blueAccent,
        points: polylinePoints,
        width: 4);
    if (mounted) {
      setState(() {
        polylines[id] = polyline;
      });
    }

    logger.i("Done putting on the map");
  }

  void updateMap(LatLng pickupLocation, LatLng destinationLocation) async {
    setState(() {
      _markers.clear();
      polylines.clear();
    });
    _markers.add(
      Marker(
        markerId: const MarkerId('pickup'),
        position: widget.tripRequest.pickupCoordinates!,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        infoWindow: const InfoWindow(title: 'Pickup'),
      ),
    );
    // _markers.add(
    //   Marker(
    //     markerId: const MarkerId('Current Location'),
    //     position: locationProvider.currentPosition!,
    //     icon: await BitmapDescriptor.fromAssetImage(
    //         const ImageConfiguration(size: Size(48, 48)),
    //         'assets/customMarkerNew.png',
    //         mipmaps: true),
    //     infoWindow: const InfoWindow(title: 'My Location'),
    //   ),
    // );
    _markers.add(
      Marker(
        markerId: const MarkerId('destinationCoordinates'),
        position: widget.tripRequest.destinationCoordinates!,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        infoWindow: const InfoWindow(title: 'Destination'),
      ),
    );

    List<LatLng> something = await locationService.fetchPolylines(
        widget.tripRequest.location!, widget.tripRequest.destination!);

    logger.i("We have fetched the polylines");
    logger.i(something);

    setState(() {
      polylineCoordinates = something;
      drawRoutesOnMap(polylineCoordinates); // Move this inside setState
    });

    animateToBounds(widget.tripRequest.pickupCoordinates!,
        widget.tripRequest.destinationCoordinates!);
  }

  void animateToBounds(LatLng pickup, LatLng destination) async {
    LatLngBounds bounds = LatLngBounds(
      southwest: LatLng(min(pickup.latitude, destination.latitude),
          min(pickup.longitude, destination.longitude)),
      northeast: LatLng(max(pickup.latitude, destination.latitude),
          max(pickup.longitude, destination.longitude)),
    );

    // Calculate padding to ensure markers are fully visible
    double padding = 50.0;

    _googleMapController
        .animateCamera(CameraUpdate.newLatLngBounds(bounds, padding));
  }

  void drawRoutesOnMap(List<LatLng> routes) {
    logger.i("We have started drawing on the map");
    const polylineId = PolylineId('routes');
    final polyline = Polyline(
      polylineId: polylineId,
      color: const Color.fromARGB(255, 17, 123, 210),
      points: routes,
      width: 3,
    );
    setState(() {
      polylines[polylineId] = polyline;
    });

    logger.i("We are done drawing on the map");
  }
}
