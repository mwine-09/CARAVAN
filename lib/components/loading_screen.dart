import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingScreen extends StatelessWidget {
  final int durationtime;
  const LoadingScreen({super.key, required this.durationtime});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: SpinKitCubeGrid(
          duration: Duration(milliseconds: durationtime),
          color: const Color.fromARGB(255, 255, 255, 255),
          size: 100.0,
        ),
      ),
    );
  }
}
