import 'package:flutter/material.dart';

class TripDetailsScreen extends StatelessWidget {
  const TripDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // leading: Text(
        //   context.toString(),
        //   style: TextStyle(color: Colors.white),
        // ),
        backgroundColor: const Color.fromARGB(255, 20, 20, 20),
        title: Text(context.toString(),
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Text(
            context.toString(),
            style: const TextStyle(color: Colors.black),
          )
        ],
      ),
    );
  }
}
