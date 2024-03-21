import 'package:flutter/material.dart';

class MatchedDriversScreen extends StatelessWidget {
  const MatchedDriversScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Matched Drivers'),
      ),
      body: const Center(
        child: Text('Display matched drivers here'),
      ),
    );
  }
}
