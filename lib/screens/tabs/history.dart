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
        body: const Center(
            child: Text("No records found",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold))));
  }
}
