import 'dart:io';

import 'package:caravan/screens/tabs/main_scaffold.dart';
import 'package:caravan/screens/tabs/settings.dart';
import 'package:caravan/services/image_picker_service.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DocumentUploadScreen extends StatelessWidget {
  final File frontIdFile;
  final File backIdFile;
  final File interpolLetterFile;
  final File selfieFile;

  DocumentUploadScreen({
    super.key,
    required this.frontIdFile,
    required this.backIdFile,
    required this.interpolLetterFile,
    required this.selfieFile,
  });

  final UploadService _uploadService = UploadService();
  User? user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    ValueNotifier<double> frontIdProgress = ValueNotifier<double>(0);
    ValueNotifier<double> backIdProgress = ValueNotifier<double>(0);
    ValueNotifier<double> interpolLetterProgress = ValueNotifier<double>(0);
    ValueNotifier<double> selfieProgress = ValueNotifier<double>(0);

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          'Documents',
          style: Theme.of(context)
              .textTheme
              .bodyLarge
              ?.copyWith(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              _buildFilePreview('Front ID', frontIdFile, frontIdProgress),
              _buildFilePreview('Back ID', backIdFile, backIdProgress),
              _buildFilePreview('Interpol Letter', interpolLetterFile,
                  interpolLetterProgress),
              _buildFilePreview('Selfie', selfieFile, selfieProgress),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  await _uploadAllFiles(context, frontIdProgress,
                      backIdProgress, interpolLetterProgress, selfieProgress);
                },
                child: const Text('Submit Documents'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilePreview(
      String label, File file, ValueNotifier<double> progress) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          height: 200,
          color: Colors.grey[200],
          child: Image.file(file, fit: BoxFit.cover),
        ),
        const SizedBox(height: 8),
        ValueListenableBuilder<double>(
          valueListenable: progress,
          builder: (context, value, child) {
            return LinearProgressIndicator(
              value: value,
              color: Colors.blue,
            );
          },
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Future<void> _uploadAllFiles(
      BuildContext context,
      ValueNotifier<double> frontIdProgress,
      ValueNotifier<double> backIdProgress,
      ValueNotifier<double> interpolLetterProgress,
      ValueNotifier<double> selfieProgress) async {
    String userId = user!.uid;
    try {
      final String frontIdUrl = await _uploadService.uploadFile(
        file: frontIdFile,
        path: 'documents/${userId}_front_id.jpg',
        uploadProgress: frontIdProgress,
      );

      final String backIdUrl = await _uploadService.uploadFile(
        file: backIdFile,
        path: 'documents/${userId}_back_id.jpg',
        uploadProgress: backIdProgress,
      );

      final String interpolLetterUrl = await _uploadService.uploadFile(
        file: interpolLetterFile,
        path: 'documents/${userId}_interpol_letter.jpg',
        uploadProgress: interpolLetterProgress,
      );

      final String selfieUrl = await _uploadService.uploadFile(
        file: selfieFile,
        path: 'documents/${userId}_selfie.jpg',
        uploadProgress: selfieProgress,
      );

      await _uploadService.saveDocumentUrls(userId, {
        'front_id_url': frontIdUrl,
        'back_id_url': backIdUrl,
        'interpol_letter_url': interpolLetterUrl,
        'selfie_url': selfieUrl,
      });

      // After all files are uploaded and URLs are saved, you can show a success message or navigate to another screen
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Documents uploaded successfully!'),
      ));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error uploading documents: $e'),
      ));
    }

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
          builder: (context) => const HomePage(
                tabDestination: 3,
              )),
      (route) => false,
    );
  }
}
