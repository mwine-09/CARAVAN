// ignore_for_file: avoid_print
// import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';

import 'package:caravan/constants.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import "package:http/http.dart" as http;
import 'dart:convert' as convert;

import 'package:logger/web.dart';

var logger = Logger();

class LocationService {
  final String key = googleMapsApiKey;

  Future<String> getPlaceId(String input) async {
    final String url =
        "https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=$input&inputtype=textquery&key=$key";

    var response = await http.get(Uri.parse(url));

    var json = convert.jsonDecode(response.body);

    var placeId = json['candidates'][0]['place_id'] as String;

    // print("THis is the place id $placeId");
    return placeId;
  }

  Future<List<String>> getLocationSuggestions(String query) async {
    var key = LocationService().key;
    var url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$query&key=$key&components=country:UG');

    var response = await http.get(url);

    if (response.statusCode == 200) {
      final places = json.decode(response.body);
      // print(places);

      if (places['predictions'].length > 0) {
        return List<String>.from(places['predictions']
            .map((prediction) => prediction['description'])).take(8).toList();
      } else {
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
    // print("wait");

    var json = convert.jsonDecode(response.body);
    // print(" still wait");

    var results = json['result'] as Map<String, dynamic>;

    // print("These are the results : $results");
    return results;
  }

  Map<String, double> extractCoordinates(Map<String, dynamic> placeDetails) {
    double lat = placeDetails["geometry"]["location"]["lat"];
    double lng = placeDetails["geometry"]["location"]["lng"];

    return {"lat": lat, "lng": lng};
  }

  Future<String> getPlaceName(double latitude, double longitude) async {
    logger.i('Getting place name for coordinates: $latitude, $longitude');
    final String url =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=$key&components=country:UG";

    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);
    var results = json['results'] as List<dynamic>;
    if (results.isNotEmpty) {
      var placeName = results[0]['formatted_address'] as String;
      var addressComponents = results[0]['address_components'] as List<dynamic>;
      var specificPlace = '';
      for (var component in addressComponents) {
        var types = component['types'] as List<dynamic>;
        if (types.contains('locality')) {
          specificPlace = component['long_name'] as String;
          break;
        }
      }
      return specificPlace;
    } else {
      throw Exception('No place found for the given coordinates.');
    }
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

    // print(results);
    return results;
  }

  Future<LatLng> searchLocation(String location) async {
    try {
      // Get place details using the location name
      Map<String, dynamic> placeDetails =
          await LocationService().getPlace(location);

      // Extract coordinates from the place details
      Map<String, double> coordinates =
          LocationService().extractCoordinates(placeDetails);
      double latitude = coordinates["lat"]!;
      double longitude = coordinates["lng"]!;

      // print(LatLng(latitude, longitude));

      return LatLng(latitude, longitude);
    } catch (e) {
      // Handle any errors that occur during the search
      // print("An error occurred while searching for location");
      print(e);
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
    var leg = legs[0];
    var polyline = route['overview_polyline']['points'];
    var polylineDecoded = PolylinePoints().decodePolyline(polyline);
    var polylines = polylineDecoded
        .map((point) => LatLng(point.latitude, point.longitude))
        .toList();
    return polylines;
  }

  // import 'package:google_maps_flutter/google_maps_flutter.dart';

  // Future<Map<String, dynamic>> getDirection(
  //   String origin,
  //   String destination,
  // ) async {
  //   final String url =
  //       "https://maps.googleapis.com/maps/api/directions/json?origin=$origin&destination=$destination&key=$key";

  //   var response = await http.get(Uri.parse(url));
  //   var json = convert.jsonDecode(response.body);

  //   if (json['routes'] == null || json['routes'].isEmpty) {
  //     throw Exception('No routes found.');
  //   }

  //   var route = json['routes'][0];
  //   var legs = route['legs'];

  //   if (legs == null || legs.isEmpty) {
  //     throw Exception('No legs found.');
  //   }

  //   var leg = legs[0];

  //   var results = {
  //     'distance_km': leg['distance'],
  //     'bounds_ne': route['bounds']['northeast'],
  //     'bounds_sw': route['bounds']['southwest'],
  //     'start_location': leg['start_location'],
  //     'end_location': leg['end_location'],
  //     'polyline': route['overview_polyline']['points'],
  //     'polyline_decoded':
  //         PolylinePoints().decodePolyline(route['overview_polyline']['points']),
  //   };

  //   print(results);

  //   List<PointLatLng> polylineDecoded = results['polyline_decoded'];
  //   for (var point in polylineDecoded) {
  //     print('Latitude: ${point.latitude}, Longitude: ${point.longitude}');
  //   }

  //   return results;
  // }

//   Future<Map<String, dynamic>> getDirection(
//       String origin, String destination) async {
//     final String url =
//         "https://maps.googleapis.com/maps/api/directions/json?origin=$origin&destination=$destination&key=$key";

//     var response = await http.get(Uri.parse(url));
//     var json = convert.jsonDecode(response.body);

//     if (json['status'] == 'OK' &&
//         json['routes'] != null &&
//         json['routes'].isNotEmpty) {
//       var route = json['routes'][0];
//       var legs = route['legs'];

//       if (legs != null && legs.isNotEmpty) {
//         var leg = legs[0];

//         var results = {
//           'distance_km': leg['distance'],
//           'bounds_ne': route['bounds']['northeast'],
//           'bounds_sw': route['bounds']['southwest'],
//           'start_location': leg['start_location'],
//           'end_location': leg['end_location'],
//           'polyline': route['overview_polyline']['points'],
//           'polyline_decoded': PolylinePoints()
//               .decodePolyline(route['overview_polyline']['points']),
//         };

//         print(results);

//         List<PointLatLng> polylineDecoded = results['polyline_decoded'];
//         for (var point in polylineDecoded) {
//           print('Latitude: ${point.latitude}, Longitude: ${point.longitude}');
//         }

//         return results;
//       }
//     }

//     throw Exception('No routes found.');
//   }
}
