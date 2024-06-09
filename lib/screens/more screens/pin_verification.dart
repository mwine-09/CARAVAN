import 'package:caravan/screens/tabs/main_scaffold.dart';
import 'package:caravan/services/secure_storage.dart';
import 'package:flutter/material.dart';

class PinVerificationScreen extends StatefulWidget {
  final VoidCallback onVerified;

  const PinVerificationScreen({super.key, required this.onVerified});

  @override
  _PinVerificationScreenState createState() => _PinVerificationScreenState();
}

class _PinVerificationScreenState extends State<PinVerificationScreen> {
  final TextEditingController _pinController = TextEditingController();

  void _verifyPin() async {
    String enteredPin = _pinController.text;
    String? storedPin = await SecureStorageService().readSecureData('userPin');

    if (enteredPin == storedPin) {
      widget.onVerified();
    } else {
      // Show an error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Incorrect PIN')),
      );
    }
  }

  void _accessWallet() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PinVerificationScreen(
          onVerified: () {
            // Proceed to wallet screen
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const HomePage(
                        tabDestination: 1,
                      )),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter PIN'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _pinController,
              decoration: const InputDecoration(labelText: 'Enter your PIN'),
              keyboardType: TextInputType.number,
              maxLength: 4,
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: _verifyPin,
              child: const Text('Verify PIN'),
            ),
          ],
        ),
      ),
    );
  }
}
