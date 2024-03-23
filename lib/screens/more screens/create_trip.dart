import 'package:flutter/material.dart';

class CreateTripScreen extends StatelessWidget {
  const CreateTripScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Create Trip',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: const Color.fromARGB(255, 20, 20, 20),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: const Center(
          child: Text("Create trips here"),
        ));
  }
}
