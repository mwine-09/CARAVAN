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
        automaticallyImplyLeading: false,
        title: const Center(
          child: Text("Previous trips",
              style: TextStyle(
                  color: Color.fromARGB(255, 254, 254, 254),
                  fontSize: 16,
                  fontWeight: FontWeight.bold)),
        ),
        backgroundColor: const Color.fromARGB(255, 20, 20, 20),
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
