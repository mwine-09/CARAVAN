import 'package:caravan/models/request.dart';
import 'package:caravan/models/trip.dart';
import 'package:caravan/providers/location_provider.dart';
import 'package:caravan/providers/trips_provider.dart';
import 'package:caravan/services/trip_service.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmaps;
import 'package:lottie/lottie.dart' as lottie;
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class LocationTrackingMap extends StatefulWidget {
  final String tripId;
  const LocationTrackingMap({super.key, required this.tripId});

  @override
  _LocationTrackingMapState createState() => _LocationTrackingMapState();
}

class _LocationTrackingMapState extends State<LocationTrackingMap>
    with SingleTickerProviderStateMixin {
  final TripService _tripService = TripService();
  gmaps.GoogleMapController? _mapController;
  Position? _currentPosition;
  gmaps.Marker? _currentMarker;
  late LocationProvider locationProvider;
  final PanelController _panelController = PanelController();
  final Set<gmaps.Marker> _markers = {};
  final Set<gmaps.Polyline> _polylines = {};

  gmaps.BitmapDescriptor? carIcon;
  gmaps.BitmapDescriptor? pickupIcon;

  late AnimationController _animationController;

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
    super.initState();
    _setCustomMarkerIcon();
    _setPickupMarkerIcon();
    _tripService.startLocationUpdates(_onLocationUpdate);

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
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

      _markers.add(_currentMarker!);

      TripDetailsProvider tripProvider =
          Provider.of<TripDetailsProvider>(context, listen: false);
      Trip trip = tripProvider.availableTrips
          .firstWhere((trip) => trip.getId == widget.tripId);
      List<Request> requests = trip.getRequests ?? [];

      for (Request request in requests) {
        if (request.pickupCoordinates != null) {
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
          _markers.add(pickupMarker);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    locationProvider = Provider.of<LocationProvider>(context, listen: false);
    _currentPosition = locationProvider.userLocation!;
    TripDetailsProvider tripProvider =
        Provider.of<TripDetailsProvider>(context);
    Trip trip = tripProvider.availableTrips
        .firstWhere((trip) => trip.getId == widget.tripId);
    List<gmaps.LatLng> polylinePoints = trip.getPolylinePoints!;

    _polylines.add(
      gmaps.Polyline(
        polylineId: const gmaps.PolylineId('tripRoute'),
        points: polylinePoints,
        color: Colors.blue,
        width: 5,
      ),
    );

    _markers.add(
      gmaps.Marker(
        markerId: const gmaps.MarkerId('startLocation'),
        infoWindow: const gmaps.InfoWindow(title: "Start point"),
        position: polylinePoints.first,
        icon: gmaps.BitmapDescriptor.defaultMarkerWithHue(
            gmaps.BitmapDescriptor.hueGreen),
      ),
    );

    _markers.add(
      gmaps.Marker(
        markerId: const gmaps.MarkerId('endLocation'),
        position: polylinePoints.last,
        infoWindow: const gmaps.InfoWindow(title: "Destination"),
        icon: gmaps.BitmapDescriptor.defaultMarkerWithHue(
            gmaps.BitmapDescriptor.hueRed),
      ),
    );

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
          gmaps.GoogleMap(
            onMapCreated: (controller) {
              _mapController = controller;
            },
            initialCameraPosition: gmaps.CameraPosition(
              target: gmaps.LatLng(
                  _currentPosition!.latitude, _currentPosition!.longitude),
              zoom: 14,
            ),
            markers: _markers,
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
        ],
      ),
    );
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
          Padding(
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
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              lottie.Lottie.asset(
                'assets/lottie.json', // Your Lottie animation file
                width: 50,
                height: 50,
              ),
              const SizedBox(width: 10),
              const Text('Trip in progress', style: TextStyle(fontSize: 16)),
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
