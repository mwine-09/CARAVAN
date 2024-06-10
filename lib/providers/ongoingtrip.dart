import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmaps;

class OnGoingTripDetailsProvider extends ChangeNotifier {
  Set<gmaps.Polyline>? onGoingTripPolylines;

  set onGoingTripPolylinesSet(Set<gmaps.Polyline> polylines) {
    onGoingTripPolylines = polylines;
    notifyListeners();
  }

  Set<gmaps.Polyline>? get onGoingTripPolylineSet => onGoingTripPolylines;
}
