// Import the test and http packages
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:caravan/services/location_service.dart';

void main() {
  test('getRoutes returns correct routes', () async {
    // Arrange: Set up the test data and mocks
    const startPlaceId = 'test_start_place_id';
    const endPlaceId = 'test_end_place_id';
    final expectedRoutes = [
      {'route': 'test_route'}
    ];

    // Mock the http client
    http.Client client = MockClient((request) async {
      return http.Response('[{"route": "test_route"}]', 200);
    });

    // Replace the http client in the LocationService with the mock client

    // Act: Call the function with the test data
    final routes = await LocationService().getRoutes(startPlaceId, endPlaceId);

    // Assert: Check that the function returns the expected result
    expect(routes, expectedRoutes);
  });
}
