     // GestureDetector(
                                        //   onTap: () async {
                                        //     var details;
                                        //     final LatLng tappedPosition =
                                        //         await _googleMapController
                                        //             .getLatLng(
                                        //       ScreenCoordinate(
                                        //         x: details.globalPosition.dx
                                        //             .toInt(),
                                        //         y: details.globalPosition.dy
                                        //             .toInt(),
                                        //       ),
                                        //     );
                                        //     final List<Placemark> placemarks =
                                        //         await placemarkFromCoordinates(
                                        //       tappedPosition.latitude,
                                        //       tappedPosition.longitude,
                                        //     );
                                        //     final String placeName =
                                        //         placemarks.first.name ?? '';
                                        //     setState(() {
                                        //       destinationController.text =
                                        //           placeName;
                                        //     });
                                        //   },
                                        //   child: const Icon(Icons.add_location),
                                        // ),














                                        ...
Row(
  children = [
    Expanded(
      child: TextField(
        controller: pickupController,
        onChanged: (value) {
          if (mounted) {
            setState(() {
              pickupText = value;
              pickupFocus = true;
            });
          }
          LocationService()
              .getLocationSuggestions(value)
              .then((value) => {
                    if (mounted)
                      {
                        setState(() {
                          locationSuggestions = value;
                        })
                      }
                  });
        },
        decoration: const InputDecoration(
          hintText: 'Enter pickup location',
          border: OutlineInputBorder(),
          suffixIcon: Icon(
            Icons.location_on,
            color: Colors.black,
          ),
        ),
      ),
    ),
    IconButton(
      onPressed: () {
        setState(() {
          _isExpanded = !_isExpanded;
          if (_isExpanded) {
            _childSize = 0.4;
          } else {
            _childSize = 0.6;
          }
        });
      },
      icon: Icon(
        _isExpanded
            ? Icons.keyboard_arrow_down
            : Icons.keyboard_arrow_up,
      ),
    ),
  ],
),
if (locationSuggestions.isNotEmpty)
  Column(
    children = locationSuggestions
        .map((location) => ListTile(
              leading: const Icon(
                Icons.location_on,
              ),
              title: Text(location),
              onTap: () {
                if (mounted) {
                  setState(() {
                    if (pickupFocus) {
                      pickupText = location;
                      pickupController.text = location;
                    } else {
                      destinationText = location;
                      destinationController.text = location;
                    }
                    locationSuggestions.clear();
                  });
                }
              },
            ))
        .toList(),
  ),
...




























import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as location;

class GoogleMapsView extends StatefulWidget {
  const GoogleMapsView({super.key});

  @override
  State<GoogleMapsView> createState() => _GoogleMapsViewState();
}

class _GoogleMapsViewState extends State<GoogleMapsView> {
  late LatLng currentPosition = const LatLng(0, 0);
  final location.Location locationController1 = location.Location();
  static late LatLng pickupLocationCoordinates;
  static var pickupLocationName = '';
  final logger = Logger();

  static late LatLng destinationCoordinates;
  static var destinationName = '';
  static final List<LatLng> _routes = [];
  GoogleMapController? _mapController;
  String? searchText;
  List<String> locationSuggestions = [];
  static final Set<Marker> _markers = {};

  static Map<PolylineId, Polyline> polylines = {};

  final pickupController = TextEditingController();
  final destinationController = TextEditingController();

  static bool pickupFocus = true;
  bool isLoading = true;

  bool _isExpanded = false;
  double _childSize = 0.5;

  @override
  void initState() {
    super.initState();
    initializeMap();
  }

  @override
  void dispose() {
    pickupController.dispose();
    destinationController.dispose();
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(
                  color: Colors.white,
                ),
                const SizedBox(height: 20),
                Text(
                  "Getting things ready...",
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      fontSize: 14),
                )
              ],
            ))
          : Stack(
              children: [
                GoogleMap(
                  myLocationEnabled: true,
                  initialCameraPosition:
                      CameraPosition(target: currentPosition, zoom: 15),
                  onMapCreated: (GoogleMapController controller) {
                    _mapController = controller;
                  },
                  markers: _markers,
                  polylines: polylines.values.toSet(),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height *
                        _childSize, // Set the height to a fraction of the screen height
                    child: DraggableScrollableSheet(
                      snap: true,
                      expand: false,
                      initialChildSize: _childSize,
                      minChildSize: 0.4,
                      maxChildSize: 0.6,
                      builder: (BuildContext context,
                          ScrollController scrollController) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 30),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(20)),
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        controller: pickupController,
                                        onChanged: (value) {
                                          setState(() {
                                            searchText = value;
                                          });
                                        },
                                        decoration: const InputDecoration(
                                          hintText: 'Enter pickup location',
                                          border: OutlineInputBorder(),
                                          suffixIcon: Icon(
                                            Icons.location_on,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _isExpanded = !_isExpanded;
                                          if (_isExpanded) {
                                            _childSize = 0.4;
                                          } else {
                                            _childSize = 0.6;
                                          }
                                        });
                                      },
                                      icon: Icon(
                                        _is
