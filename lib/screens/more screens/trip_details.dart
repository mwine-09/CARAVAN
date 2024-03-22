import 'package:caravan/models/Trip.dart';
import 'package:caravan/screens/more%20screens/request_trip.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TripDetailsScreen extends StatelessWidget {
  TripDetailsScreen({super.key});

  final List<TripDetails> tripDetailsList = [
    TripDetails(
      driverName: 'John Doe',
      location: 'New York',
      destination: 'Los Angeles',
      availableSeats: 3,
      dateTime: DateTime(2022, 1, 1, 10, 0),
    ),
    TripDetails(
      driverName: 'Jane Smith',
      location: 'San Francisco',
      destination: 'Seattle',
      availableSeats: 2,
      dateTime: DateTime(2022, 1, 2, 14, 30),
    ),
    TripDetails(
      driverName: 'Mike Johnson',
      location: 'Chicago',
      destination: 'Miami',
      availableSeats: 4,
      dateTime: DateTime(2022, 1, 3, 9, 15),
    ),
    TripDetails(
      driverName: 'Emily Davis',
      location: 'Boston',
      destination: 'Washington D.C.',
      availableSeats: 1,
      dateTime: DateTime(2022, 1, 4, 16, 45),
    ),
    TripDetails(
      driverName: 'David Wilson',
      location: 'Denver',
      destination: 'Las Vegas',
      availableSeats: 5,
      dateTime: DateTime(2022, 1, 5, 12, 0),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 20, 20, 20),
        title: const Text('Trip Details',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView.builder(
        itemCount: tripDetailsList.length,
        itemBuilder: (context, index) {
          TripDetails trip = tripDetailsList[index];
          String formattedDate = DateFormat('E M/d/y').format(trip.dateTime);
          // format date and time to show time and date

          return MatchedDriver(
              driverName: trip.driverName,
              location: trip.location,
              destination: trip.destination,
              dateTime: formattedDate,
              availableSeats: trip.availableSeats);
        },
      ),
    );
  }
}
