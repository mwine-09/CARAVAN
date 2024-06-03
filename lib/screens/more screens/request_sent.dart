import 'package:flutter/material.dart';

class RequestSendScreen extends StatelessWidget {
  const RequestSendScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Text(
              "Request sent successfully",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          )
        ],
      ),
    );
  }
}
