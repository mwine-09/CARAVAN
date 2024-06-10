import 'package:caravan/models/request.dart';
import 'package:caravan/models/trip.dart';
import 'package:caravan/providers/location_provider.dart';
import 'package:caravan/providers/trips_provider.dart';
import 'package:caravan/services/database_service.dart';

import 'package:caravan/services/location_service.dart';
import 'package:caravan/services/trip_service.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmaps;

import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class LocationTrackingMap extends StatefulWidget {
  final String tripId;
  Set<gmaps.Polyline>? polylines;

  LocationTrackingMap({super.key, required this.tripId, this.polylines});

  @override
  _LocationTrackingMapState createState() => _LocationTrackingMapState();
}

class _LocationTrackingMapState extends State<LocationTrackingMap>
    with SingleTickerProviderStateMixin {
  final TripService _tripService = TripService();
  gmaps.GoogleMapController? _mapController;
  bool isLoading = false;
  Position? _currentPosition;
  gmaps.Marker? _currentMarker;
  late LocationProvider locationProvider;
  final PanelController _panelController = PanelController();
  Set<gmaps.Marker> markers = {};
  Set<gmaps.Polyline> _polylines = {};
  LocationService locationService = LocationService.getInstance();
  late bool isTripStarted;
  gmaps.BitmapDescriptor? carIcon;
  gmaps.BitmapDescriptor? pickupIcon;
  DatabaseService dbservice = DatabaseService();
  late TripDetailsProvider tripProvider;
  late Trip trip;
  late AnimationController _animationController;
  double _sliderValue = 0.0;

  void _onSliderChanged(double value) {
    setState(() {
      _sliderValue = value;
    });
  }

  void _onSliderEnd() {
    if (_sliderValue == 100.0) {
      _startTrip();
    } else {
      setState(() {
        _sliderValue = 0.0;
      });
    }
  }

  Future<void> _startTrip() async {
    Trip trip = tripProvider.availableTrips
        .firstWhere((trip) => trip.getId == widget.tripId);
    setState(() {
      isTripStarted = true;
    });
    tripProvider.updateTripStatus(trip.getId!, TripStatus.started);
    // Notify the creator of the trip
    DatabaseService().sendNotification(trip.createdBy!, "alert",
        "Trip to ${trip.destination} by ${trip.driver!.username} has started");
  }

  void _setCustomMarkerIcon() async {
    carIcon = await gmaps.BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(50, 50)),
      'assets/car_icon.png',
    );
    setState(() {});
  }

  void _setPickupMarkerIcon() async {
    pickupIcon = await gmaps.BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(50, 50)),
      'assets/rider.png',
    );
    setState(() {});
  }

  @override
  void initState() {
    _polylines = widget.polylines ?? {};
    super.initState();
    tripProvider = Provider.of<TripDetailsProvider>(context, listen: false);
    trip = tripProvider.availableTrips
        .firstWhere((trip) => trip.getId == widget.tripId);

    isTripStarted = trip.getTripStatus == TripStatus.started;
    locationProvider = Provider.of<LocationProvider>(context, listen: false);

    _setCustomMarkerIcon();
    _setPickupMarkerIcon();
    _tripService.startLocationUpdates(_onLocationUpdate);
    // _getDirections();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _tripService.stopLocationUpdates();
    _animationController.dispose();
    super.dispose();
  }

  void _onLocationUpdate(Position position) {
    setState(() {
      _currentPosition = position;

      _currentMarker = gmaps.Marker(
        markerId: const gmaps.MarkerId('currentLocation'),
        position: gmaps.LatLng(position.latitude, position.longitude),
        icon: carIcon ??
            gmaps.BitmapDescriptor.defaultMarkerWithHue(
                gmaps.BitmapDescriptor.hueBlue),
      );

      if (_mapController != null) {
        _mapController!.animateCamera(
          gmaps.CameraUpdate.newLatLng(
            gmaps.LatLng(position.latitude, position.longitude),
          ),
        );
      }

      markers.add(_currentMarker!);

      Trip trip = tripProvider.availableTrips
          .firstWhere((trip) => trip.getId == widget.tripId);
      List<Request> requests = trip.getRequests ?? [];

      for (Request request in requests) {
        if (request.pickupCoordinates != null &&
            request.destinationCoordinates != null) {
          gmaps.Marker pickupMarker = gmaps.Marker(
            markerId: gmaps.MarkerId('pickup_${request.passengerId}'),
            position: request.destinationCoordinates!,
            infoWindow: gmaps.InfoWindow(
              title: request.pickupLocationName,
            ),
            icon: pickupIcon ??
                gmaps.BitmapDescriptor.defaultMarkerWithHue(
                    gmaps.BitmapDescriptor.hueYellow),
          );

          // Add the pickup marker to the map for pickup location
          gmaps.Marker destinationMarker = gmaps.Marker(
            markerId: gmaps.MarkerId(const Uuid().v4().toString()),
            position: request.destinationCoordinates!,
            infoWindow: gmaps.InfoWindow(
              title: request.destinationLocationName,
            ),
            icon: pickupIcon ??
                gmaps.BitmapDescriptor.defaultMarkerWithHue(
                    gmaps.BitmapDescriptor.hueGreen),
          );

          markers.add(pickupMarker);
          markers.add(destinationMarker);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    locationProvider = Provider.of<LocationProvider>(context, listen: false);
    _currentPosition = locationProvider.userLocation!;

    Trip trip = tripProvider.availableTrips
        .firstWhere((trip) => trip.getId == widget.tripId);

    isTripStarted = trip.getTripStatus == TripStatus.started;

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
        body: Stack(children: [
          gmaps.GoogleMap(
            onMapCreated: (controller) {
              _mapController = controller;
            },
            initialCameraPosition: gmaps.CameraPosition(
              target: gmaps.LatLng(
                  _currentPosition!.latitude, _currentPosition!.longitude),
              zoom: 14,
            ),
            markers: markers,
            polylines: _polylines,
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
            trafficEnabled: true,
          ),
          Positioned(
            top: 50,
            right: 15,
            child: FloatingActionButton(
              backgroundColor: Colors.white,
              onPressed: () {
                if (_currentPosition != null && _mapController != null) {
                  _mapController!.animateCamera(
                    gmaps.CameraUpdate.newLatLng(
                      gmaps.LatLng(_currentPosition!.latitude,
                          _currentPosition!.longitude),
                    ),
                  );
                }
              },
              child: const Icon(Icons.my_location),
            ),
          ),
          SlidingUpPanel(
            panelSnapping: false,
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            controller: _panelController,
            minHeight: MediaQuery.of(context).size.height * 0.3,
            maxHeight: MediaQuery.of(context).size.height * 0.8,
            panel: _buildPanelContent(trip),
          ),
        ]));
  }

  Widget _buildPanelContent(Trip trip) {
    List<Request> requests = trip.getRequests ?? [];
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Trip Information',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
          ),
          Text("Destination: ${trip.destination}"),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Estimated Time: 15 mins'),
          ),
          isTripStarted
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // Handle cancel trip action
                        },
                        child: const Text('End trip'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Handle SOS action
                        },
                        child: const Text('Emergency SOS'),
                      ),
                    ],
                  ),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 16),
                    SlideAction(
                      text: "Slide to start trip",
                      textStyle: const TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                      ),
                      outerColor: const Color.fromARGB(255, 0, 0, 0),
                      innerColor: Colors.white,
                      sliderButtonIcon: const Icon(Icons.arrow_forward,
                          color: Color.fromARGB(255, 0, 0, 0), size: 30),
                      onSubmit: () => _startTrip(),
                    ),
                  ],
                ),
          Expanded(
            child: ListView.builder(
              itemCount: requests.length,
              itemBuilder: (context, index) {
                Request request = requests[index];
                return ListTile(
                  leading: const Icon(Icons.location_pin),
                  title: Text("Pickup: ${request.pickupLocationName}"),
                  subtitle: Text("Dropoff: ${request.destinationLocationName}"),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
