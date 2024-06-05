import 'package:caravan/models/trip.dart';
import 'package:caravan/providers/location_provider.dart';
import 'package:caravan/providers/trips_provider.dart';

import 'package:caravan/services/trip_service.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class LocationTrackingMap extends StatefulWidget {
  final String tripId;
  const LocationTrackingMap({super.key, required this.tripId});

  @override
  _LocationTrackingMapState createState() => _LocationTrackingMapState();
}

class _LocationTrackingMapState extends State<LocationTrackingMap> {
  final TripService _tripService = TripService();

  late GoogleMapController _mapController;
  Position? _currentPosition;
  Marker? _currentMarker;
  Marker? _endMarker;
  Circle? _currentCircle;
  late LocationProvider locationProvider;

  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};

  BitmapDescriptor? carIcon;

  @override
  void initState() {
    super.initState();
    _setCustomMarkerIcon();
    _tripService.startLocationUpdates(_onLocationUpdate);
  }

  @override
  void dispose() {
    _tripService.stopLocationUpdates();
    super.dispose();
  }

  void _setCustomMarkerIcon() async {
    carIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(devicePixelRatio: 2.5),
      'assets/car_icon.png', // Your car icon asset
    );
  }

  void _onLocationUpdate(Position position) {
    setState(() {
      _currentPosition = position;

      // Update car marker
      _currentMarker = Marker(
        markerId: const MarkerId('currentLocation'),
        position: LatLng(position.latitude, position.longitude),
        icon: carIcon ??
            BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      );

      // Move camera to the new position
      _mapController.animateCamera(
        CameraUpdate.newLatLng(
          LatLng(position.latitude, position.longitude),
        ),
      );

      // Update markers
      _markers.add(_currentMarker!);
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

    List<LatLng> polylinePoints = trip.getPolylinePoints!;

    // Add polylines to the map
    _polylines.add(
      Polyline(
        polylineId: const PolylineId('tripRoute'),
        points: polylinePoints,
        color: Colors.blue,
        width: 5,
      ),
    );

    // Add start and end markers
    _markers.add(
      Marker(
        markerId: const MarkerId('startLocation'),
        position: polylinePoints.first,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      ),
    );

    _markers.add(
      Marker(
        markerId: const MarkerId('endLocation'),
        position: polylinePoints.last,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
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
      body: GoogleMap(
        onMapCreated: (controller) => _mapController = controller,
        initialCameraPosition: CameraPosition(
          target: LatLng(_currentPosition!.latitude,
              _currentPosition!.longitude), // Default position, will be updated
          zoom: 14,
        ),
        markers: _markers,
        polylines: _polylines,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
      ),
    );
  }
}
