// ignore_for_file: avoid_logger.i
// import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:caravan/credentials.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import "package:http/http.dart" as http;
import 'package:http/http.dart';
import 'dart:convert' as convert;

import 'package:logger/web.dart';

var logger = Logger();

class LocationService {
  String key = googleMapsApiKey;
  static LocationService? _instance;

  LocationService._(); // Private constructor

  static LocationService getInstance() {
    _instance ??= LocationService._();
    return _instance!;
  }

  Future<String> getPlaceId(String input) async {
    final String url =
        "https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=$input&inputtype=textquery&key=$key";

    var response = await http.get(Uri.parse(url));

    var json = convert.jsonDecode(response.body);

    var placeId = json['candidates'][0]['place_id'] as String;

    // logger.i("THis is the place id $placeId");
    return placeId;
  }

  Future<List<String>> getLocationSuggestions(String query) async {
    logger.i("This is the query $query");
    var url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$query&key=$key&components=country:UG');

    var response = await http.get(url);

    logger.e("The status code is ${response.statusCode}");

    if (response.statusCode == 200) {
      final places = json.decode(response.body);
      // logger.i(places);

      if (places['predictions'].length > 0) {
        return List<String>.from(places['predictions']
            .map((prediction) => prediction['description'])).take(12).toList();
      } else {
        logger.e("No predictions found");
        return [];
      }
    } else {
      throw Exception('Failed to load predictions');
    }
  }

  Future<Map<String, dynamic>> getPlace(String input) async {
    final placeId = await getPlaceId(input);

    final String url =
        "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$key";

    var response = await http.get(Uri.parse(url));
    // logger.i("wait");

    var json = convert.jsonDecode(response.body);
    // logger.i(" still wait");

    var results = json['result'] as Map<String, dynamic>;

    // logger.i("These are the results : $results");
    return results;
  }

  Map<String, double> extractCoordinates(Map<String, dynamic> placeDetails) {
    double lat = placeDetails["geometry"]["location"]["lat"];
    double lng = placeDetails["geometry"]["location"]["lng"];

    return {"lat": lat, "lng": lng};
  }

  Future<String> getPlaceName(double lat, double lng) async {
    try {
      final url =
          'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$key';

      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final results = data['results'] as List<dynamic>;
        if (results.isNotEmpty) {
          // logger.e('Results: $results');
          return results[0]['formatted_address'];
        }
      }
      throw Exception('No place found for the given coordinates.');
    } catch (e) {
      // Handle any errors that occur during the request
      // logger.i("An error occurred while getting place name");
      logger.i(e);
      throw Exception('Failed to get place name.');
    }
  }

  Future<Map<String, dynamic>> fetchDirections(String origin,
      String destination, List<String> waypoints, String apiKey) async {
    final String waypointsParam = waypoints.join('|');
    final String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=$origin&destination=$destination&waypoints=$waypointsParam&key=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load directions');
    }
  }

  // fetch directions between two points
  Future<Map<String, dynamic>> fetchDirectionsBetweenTwoPoints(
      String origin, String destination, String apiKey) async {
    final String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=$origin&destination=$destination&key=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return json.decode(response.body)['routes'][0];
    } else {
      throw Exception('Failed to load directions');
    }
  }

  Future<Map<String, dynamic>> fetchDistanceAndDuration(
      String origin, List<String> destinations, String apiKey) async {
    final String destinationsParam = destinations.join('|');
    final String url =
        'https://maps.googleapis.com/maps/api/distancematrix/json?origins=$origin&destinations=$destinationsParam&key=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load distance and duration');
    }
  }

  Future<Map<String, dynamic>> snapToRoads(
      List<String> path, String apiKey) async {
    final String pathParam = path.join('|');
    final String url =
        'https://roads.googleapis.com/v1/snapToRoads?path=$pathParam&key=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to snap to roads');
    }
  }

  Future<List> getRoutes(String startPlaceId, String endPlaceId) async {
    final String url =
        "https://maps.googleapis.com/maps/api/directions/json?origin=place_id:$startPlaceId&destination=place_id:$endPlaceId&alternatives=true&key=$key";

    var response = await http.get(Uri.parse(url));

    var json = convert.jsonDecode(response.body);

    var routes = json['routes'] as List;

    return routes;
  }

  Future<List<Map<String, dynamic>>> getTripRoute(
    String origin,
    List<String> waypoints,
    String destination,
  ) async {
    List<Map<String, dynamic>> route = [];
    waypoints.add(origin);
    waypoints.add(destination);

    try {
      List<String> sortedWaypoints =
          await sortWaypoints(origin, waypoints, destination);

      logger.i("Sorted waypoints: $sortedWaypoints");

      for (int i = 0; i < sortedWaypoints.length - 1; i++) {
        String origin = sortedWaypoints[i];
        String destination = sortedWaypoints[i + 1];
        Map<String, dynamic> directions = await fetchDirectionsBetweenTwoPoints(
            origin, destination, googleMapsApiKey);

        logger.i("Directions: $directions");

        route.add(directions);
      }

      logger.i("Still waiting for the route: $route");

      Set<String> allKeys = {};
      for (int i = 0; i < route.length; i++) {
        allKeys.addAll(route[i].keys);
      }
      logger.i("All keys: $allKeys");
    } catch (e) {
      logger.e("Error occurred while getting trip route: $e");
      // Optionally, rethrow the error or return an empty route to indicate failure
      // rethrow;
    }

    return route;
  }

  Future<List<String>> sortWaypoints(
      String driverLocation, List<String> waypoints, String destination) async {
    waypoints.add(driverLocation);
    waypoints.add(destination);
    // Calculate the distance between each waypoint and the driver's current location
    Map<String, double> distances = {};

    for (String waypoint in waypoints) {
      String url =
          'https://maps.googleapis.com/maps/api/distancematrix/json?units=metric&origins=$driverLocation&destinations=$waypoint&key=$googleMapsApiKey';

      try {
        final response = await http.get(Uri.parse(url));
        if (response.statusCode == 200) {
          var data = json.decode(response.body);
          distances[waypoint] = data['rows'][0]['elements'][0]['distance']
                  ['value'] /
              1000.0; // distance in kilometers
        } else {
          // Handle non-200 status codes
          throw Exception(
              'Failed to calculate distance, status code: ${response.statusCode}');
        }
      } catch (e) {
        // Handle any errors that occur during the HTTP request or JSON decoding
        print('Error calculating distance for $waypoint: $e');
        distances[waypoint] = -1; // Optional: Use -1 to indicate an error
      }
    }

    // Calculate the distance between each pair of waypoints
    Map<String, Map<String, double>> pairDistances = {};
    for (int i = 0; i < waypoints.length - 1; i++) {
      String waypoint1 = waypoints[i];
      for (int j = i + 1; j < waypoints.length; j++) {
        String waypoint2 = waypoints[j];
        String url =
            'https://maps.googleapis.com/maps/api/distancematrix/json?units=metric&origins=$waypoint1&destinations=$waypoint2&key=$googleMapsApiKey';
        final response = await http.get(Uri.parse(url));
        if (response.statusCode == 200) {
          var data = json.decode(response.body);
          double distance = data['rows'][0]['elements'][0]['distance']
                  ['value'] /
              1000.0; // distance in kilometers
          pairDistances[waypoint1] ??= {};
          pairDistances[waypoint1]![waypoint2] = distance;
          pairDistances[waypoint2] ??= {};
          pairDistances[waypoint2]![waypoint1] = distance;
        } else {
          throw Exception('Failed to calculate distance');
        }
      }
    }

    // Dijkstra's algorithm
    List<String> sortedWaypoints = [driverLocation];
    while (sortedWaypoints.length <= waypoints.length) {
      // String currentLocation = sortedWaypoints.last;
      double minDistance = double.infinity;
      String nextWaypoint = '';
      for (String waypoint in waypoints) {
        if (!sortedWaypoints.contains(waypoint)) {
          double distance = distances[waypoint] ?? double.infinity;
          if (distance < minDistance) {
            minDistance = distance;
            nextWaypoint = waypoint;
          }
        }
      }
      sortedWaypoints.add(nextWaypoint);
    }

    return sortedWaypoints;
  }

  Future<Map<String, dynamic>> getDirection(
    String origin,
    String destination,
  ) async {
    final String url =
        "https://maps.googleapis.com/maps/api/directions/json?origin=$origin&destination=$destination&key=$key";

    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);

    var results = {
      'distance_km': json['routes'][0]['legs'][0]['distance'],
      'bounds_ne': json['routes'][0]['bounds']['northeast'],
      'bounds_sw': json['routes'][0]['bounds']['southwest'],
      'start_location': json['routes'][0]['legs'][0]['start_location'],
      'end_location': json['routes'][0]['legs'][0]['end_location'],
      'polyline': json['routes'][0]['overview_polyline']['points'],
      'polyline_decoded': PolylinePoints()
          .decodePolyline(json['routes'][0]['overview_polyline']['points']),
    };

    // logger.i(results);
    return results;
  }

  Future<LatLng> searchLocation(String location) async {
    try {
      // Get place details using the location name
      Map<String, dynamic> placeDetails = await getPlace(location);

      // Extract coordinates from the place details
      Map<String, double> coordinates = extractCoordinates(placeDetails);
      double latitude = coordinates["lat"]!;
      double longitude = coordinates["lng"]!;

      // logger.i(LatLng(latitude, longitude));

      return LatLng(latitude, longitude);
    } catch (e) {
      // Handle any errors that occur during the search
      // logger.i("An error occurred while searching for location");
      logger.i(e);
      return const LatLng(
          0, 0); // Return a default value or handle the error as needed
    }
  }

// function to fetch polylines
  Future<List<LatLng>> fetchPolylines(String origin, String destination) async {
    final String url =
        "https://maps.googleapis.com/maps/api/directions/json?origin=$origin&destination=$destination&key=$key";

    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);
    if (json['routes'] == null || json['routes'].isEmpty) {
      throw Exception('No routes found.');
    }
    var route = json['routes'][0];
    var legs = route['legs'];
    if (legs == null || legs.isEmpty) {
      throw Exception('No legs found.');
    }
    var polyline = route['overview_polyline']['points'];
    var polylineDecoded = PolylinePoints().decodePolyline(polyline);
    var polylines = polylineDecoded
        .map((point) => LatLng(point.latitude, point.longitude))
        .toList();
    return polylines;
  }

  List<LatLng> decodePoly(String encoded) {
    List<LatLng> points = <LatLng>[];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      LatLng p = LatLng(lat / 1E5, lng / 1E5);
      points.add(p);
    }
    return points;
  }

  Future<List<List<Map<String, double>>>> fetchTripPolylines(
      String origin, String destination, List<String> waypoints) async {
    final String waypointsString = 'optimize:true|${waypoints.join('|')}';
    final String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=$origin&destination=$destination&waypoints=$waypointsString&key=$googleMapsApiKey';

    Response response = await http.get(Uri.parse(url));
    logger.i("This is the response ${response.body}");

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      logger.i("This is the data $data");

      if (data['routes'] == null || data['routes'].isEmpty) {
        throw Exception('No routes found in the response');
      }

      List<dynamic> routes = data['routes'];
      logger.i("This is the routes $routes");

      List<List<Map<String, double>>> polylines = [];

      for (var route in routes) {
        if (route['legs'] == null || route['legs'].isEmpty) {
          continue;
        }
        List<Map<String, double>> polyline = [];
        List<dynamic> steps = route['legs'][0]['steps'];
        logger.i("This is the steps $steps");

        for (var step in steps) {
          if (step['polyline'] == null || step['polyline']['points'] == null) {
            continue;
          }
          String encodedPolyline = step['polyline']['points'];
          List<Map<String, double>> points = _decodePolyline(encodedPolyline);
          polyline.addAll(points);
        }
        polylines.add(polyline);
      }

      return polylines;
    } else {
      throw Exception('Failed to load polylines');
    }
  }

  List<Map<String, double>> _decodePolyline(String encoded) {
    List<Map<String, double>> polyline = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;

      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);

      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;

      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);

      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      Map<String, double> point = {
        'latitude': lat / 1E5,
        'longitude': lng / 1E5
      };
      polyline.add(point);
    }

    return polyline;
  }

  Future<Map<String, dynamic>> getOptimizedRoute({
    required LatLng origin,
    required LatLng destination,
    required List<LatLng> waypoints,
  }) async {
    String originStr = '${origin.latitude},${origin.longitude}';
    String destinationStr = '${destination.latitude},${destination.longitude}';
    String waypointsStr = waypoints
        .map((point) => '${point.latitude},${point.longitude}')
        .join('|');

    String url = 'https://maps.googleapis.com/maps/api/directions/json?'
        'origin=$originStr&destination=$destinationStr'
        '&waypoints=optimize:true|$waypointsStr'
        '&mode=driving&departure_time=now'
        '&key=$googleMapsApiKey';

    final response = await http.get(Uri.parse(url));
    logger.i("This is the response $response");
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load directions');
    }
  }

  Map<String, dynamic> parseRouteData(Map<String, dynamic> data) {
    var routes = data['routes'][0];
    var legs = routes['legs'];
    List<LatLng> polylineCoordinates = [];
    List<int> waypointOrder = routes['waypoint_order'].cast<int>();
    String eta = legs.last['arrival_time']['text'];

    for (var leg in legs) {
      for (var step in leg['steps']) {
        polylineCoordinates.add(LatLng(
          step['start_location']['lat'],
          step['start_location']['lng'],
        ));
        polylineCoordinates.add(LatLng(
          step['end_location']['lat'],
          step['end_location']['lng'],
        ));
      }
    }

    logger.e({
      'polylineCoordinates': polylineCoordinates,
      'waypointOrder': waypointOrder,
      'eta': eta,
    });

    return {
      'polylineCoordinates': polylineCoordinates,
      'waypointOrder': waypointOrder,
      'eta': eta,
    };
  }
}
