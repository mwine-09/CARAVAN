import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapsView extends StatefulWidget {
  const GoogleMapsView({super.key});

  @override
  State<GoogleMapsView> createState() => _GoogleMapsViewState();
}

class _GoogleMapsViewState extends State<GoogleMapsView> {
  static const googlePlex = LatLng(0.3254716, 32.5665353);
  static const destination = LatLng(0.3254716, 32.6665353);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: const CameraPosition(
          target: googlePlex,
          zoom: 10,
        ),
        markers: {
          const Marker(markerId: MarkerId('marker_1'), position: googlePlex),
          const Marker(markerId: MarkerId('marker_2'), position: destination),
        },
// CameraPosition
      ), // GoogleMap
    );
  }
}
