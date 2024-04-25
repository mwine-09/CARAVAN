import 'dart:math';

import 'package:caravan/providers/location_provider.dart';

import 'package:caravan/services/location_service.dart';

import 'package:flutter/material.dart';

import 'package:flutter_polyline_points/flutter_polyline_points.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:logger/web.dart';
import 'package:provider/provider.dart';

var logger = Logger();

class DriverStartPointScreen extends StatefulWidget {
  final LatLng destination;
  final String selectedDestinationName;

  const DriverStartPointScreen(
      {super.key,
      required this.destination,
      required this.selectedDestinationName});

  @override
  State<DriverStartPointScreen> createState() => _DriverStartPointScreenState();
}

class _DriverStartPointScreenState extends State<DriverStartPointScreen> {}
