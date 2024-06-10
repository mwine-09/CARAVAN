import 'package:caravan/credentials.dart';
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
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
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

  late AnimationController _animationController;
  double _sliderValue = 0.0;

  @override
  void initState() {
    super.initState();
    isLoading = true;
    _polylines = widget.polylines ?? {};
    _setCustomMarkerIcon();
    _setPickupMarkerIcon();
    _tripService.startLocationUpdates(_onLocationUpdate);

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();

    // Fetch trip details and load the route
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchTripDetailsAndLoadRoute();
    });
  }

  Future<void> _fetchTripDetailsAndLoadRoute() async {
    try {
      tripProvider = Provider.of<TripDetailsProvider>(context, listen: false);
      Trip trip = tripProvider.availableTrips
          .firstWhere((trip) => trip.getId == widget.tripId);
      isTripStarted = trip.getTripStatus == TripStatus.started;
      await _loadRoute(trip);
    } catch (e) {
      print('Error fetching trip details: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _loadRoute(Trip trip) async {
    setState(() {
      isLoading = true;
    });
    LatLng origin = locationProvider.currentPosition ?? const LatLng(0, 0);
    LatLng destination =
        trip.destinationCoordinates!; // Example destination (Los Angeles, CA)

    //  loop though the requests and get the waypoints
    List<LatLng> waypoints = [];
    // for each request in the trip, get the pickup coordinates and destination coordinates
    for (Request request in trip.requests!) {
      waypoints.add(request.pickupCoordinates!);
      waypoints.add(request.destinationCoordinates!);
    }

    try {
      var data = await locationService.getOptimizedRoute(
        apiKey: googleMapsApiKey,
        origin: origin,
        destination: destination,
        waypoints: waypoints,
      );
      var routeData = locationService.parseRouteData(data);
      setState(() {
        _polylines.add(Polyline(
          polylineId: const PolylineId('optimized_route'),
          points: routeData['polylineCoordinates'],
          color: Colors.blue,
          width: 5,
        ));
        isLoading = false;
        // You can use routeData['waypointOrder'] and routeData['eta'] as needed
        print('Optimized Waypoint Order: ${routeData['waypointOrder']}');
        print('Estimated Time of Arrival: ${routeData['eta']}');
      });
    } catch (e) {
      print('Error loading route: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _onSliderChanged(double value) {
    setState(() {
      _sliderValue = value;
    });
  }

  void _onSliderEnd() {
    if (_sliderValue == 100.0) {
      // Start the trip
      _startTrip();
    } else {
      // Reset the slider
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
    // Logic to start the trip
    tripProvider.updateTripStatus(trip.getId!, TripStatus.started);

    // Navigate to the trip tracking screen or perform any other action
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
  void dispose() {
    _tripService.stopLocationUpdates();
    _animationController.dispose();
    super.dispose();
  }

  void _onLocationUpdate(Position position) {
    setState(() {
      _currentPosition = position;
      _polylines = widget.polylines ?? {};

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

      tripProvider = Provider.of<TripDetailsProvider>(context, listen: false);
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
          markers.add(pickupMarker);
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

    List<Polyline> polylineList = _polylines.toList();

    if (polylineList.isNotEmpty) {
      Polyline firstPolyline = polylineList.first;
      Polyline lastPolyline = polylineList.last;
      markers.add(
        gmaps.Marker(
          markerId: const gmaps.MarkerId('startLocation'),
          infoWindow: const gmaps.InfoWindow(title: "Start point"),
          position: firstPolyline.points.first,
          icon: gmaps.BitmapDescriptor.defaultMarkerWithHue(
              gmaps.BitmapDescriptor.hueGreen),
        ),
      );

      markers.add(
        gmaps.Marker(
          markerId: const gmaps.MarkerId('endLocation'),
          position: lastPolyline.points.last,
          infoWindow: const gmaps.InfoWindow(title:
              "End point"),
          icon: gmaps.BitmapDescriptor.defaultMarkerWithHue(

              gmaps.BitmapDescriptor.hueRed),
        ),
      );
    }



