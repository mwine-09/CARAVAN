import 'package:flutter/material.dart';

class RequestTripScreen extends StatefulWidget {
  const RequestTripScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RequestTripScreenState createState() => _RequestTripScreenState();
}

class _RequestTripScreenState extends State<RequestTripScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Matched drivers',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: const Center(),
    );
  }
}

class MatchedDriver extends StatelessWidget {
  final String driverName;
  final String location;
  final String destination;
  final String dateTime;
  final int availableSeats;
  // ignore: use_key_in_widget_constructors
  const MatchedDriver({
    required this.location,
    required this.driverName,
    required this.destination,
    required this.dateTime,
    required this.availableSeats,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
      child: SizedBox(
          width: 300,
          height: 270,
          child: Card(
              color: const Color.fromARGB(255, 20, 20, 20),
              // width 380 height 290

              child: Column(children: [
                const SizedBox(height: 10),
                Row(
                  children: [
                    const SizedBox(width: 10),
                    const CircleAvatar(
                      radius: 40,
                      backgroundImage: AssetImage('assets/default_profile.jpg'),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          driverName,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Location: $location ',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 15),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Destination: $destination',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 15),
                        ),
                        Text(
                          'Date & Time: $dateTime',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 15),
                        ),
                        Text(
                          'Available seats: $availableSeats ',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 15),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size(320, 55),
                        backgroundColor:
                            const Color.fromARGB(255, 255, 255, 255),
                        shape: const BeveledRectangleBorder()),
                    onPressed: () {
                      // TODO: go to the page that shows full details
                    },
                    child: const Text(
                      'Request Trip',
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ))
              ]))),
    );
  }
}
