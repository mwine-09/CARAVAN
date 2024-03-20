import 'package:caravan/screens/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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
      body: const Center(
        child: Stack(
          children: [MatchedDriver()],
        ),
      ),
    );
  }
}

class MatchedDriver extends StatelessWidget {
  const MatchedDriver({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        color: const Color.fromARGB(255, 20, 20, 20),
        // width 380 height 290

        child: const Column(children: [
          SizedBox(height: 10),
          Row(
            children: [
              SizedBox(width: 10),
              CircleAvatar(
                radius: 40,
                backgroundImage: AssetImage('assets/default_profile.jpg'),
              ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Driver Name',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Driver Rating',
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Driver Phone Number',
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 10)
        ]));
  }
}
