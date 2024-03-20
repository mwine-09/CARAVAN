import 'package:flutter/material.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: Colors.grey[850],
        title: const Text('History',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: ListView.builder(
        itemCount: trips.length,
        itemBuilder: (context, index) {
          final trip = trips[index];
          return ListTile(
            title: Text(trip.destination),
            subtitle: Text(trip.date),
            onTap: () {
              // Handle tap on trip
            },
          );
        },
      ),
    );
  }
}

class Trip {
  final String destination;
  final String date;

  Trip({required this.destination, required this.date});
}

final List<Trip> trips = [
  Trip(destination: 'Trip 1', date: '2022-01-01'),
  Trip(destination: 'Trip 2', date: '2022-02-01'),
  Trip(destination: 'Trip 3', date: '2022-03-01'),
];
