import 'dart:convert';
import 'package:caravan/credentials.dart';
import 'package:http/http.dart' as http;

class DirectionsService {
  final String apiKey = googleMapsApiKey;

  Future<Map<String, dynamic>?> getDirections({
    required String origin,
    required List<String> waypoints,
    required String destination,
  }) async {
    const baseUrl = 'https://maps.googleapis.com/maps/api/directions/json';
    final waypointsString = waypoints.map((wp) => 'via:$wp').join('|');
    final queryParams = {
      'origin': origin,
      'destination': destination,
      'waypoints': 'optimize:true|$waypointsString',
      'key': apiKey,
    };

    final url = Uri.parse(baseUrl).replace(queryParameters: queryParams);

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print('Error fetching directions: ${response.reasonPhrase}');
      return null;
    }
  }
}
