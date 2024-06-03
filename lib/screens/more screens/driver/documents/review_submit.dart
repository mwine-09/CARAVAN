import 'dart:io';

import 'package:caravan/screens/more%20screens/driver/documents/upload.dart';
import 'package:flutter/material.dart';

class ReviewDocumentsScreen extends StatelessWidget {
  final File? frontIdFile;
  final File? backIdFile;
  final File? interpolLetterFile;
  final File? selfieFile;

  const ReviewDocumentsScreen({
    super.key,
    required this.frontIdFile,
    required this.backIdFile,
    required this.interpolLetterFile,
    required this.selfieFile,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          'Review Documents',
          style: Theme.of(context)
              .textTheme
              .bodyLarge
              ?.copyWith(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Front of ID',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(color: Colors.white)),
              const SizedBox(height: 8),
              frontIdFile != null
                  ? Image.file(frontIdFile!)
                  : Text('No file selected',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(color: Colors.white)),
              const SizedBox(height: 16),
              Text('Back of ID',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(color: Colors.white)),
              const SizedBox(height: 8),
              backIdFile != null
                  ? Image.file(backIdFile!)
                  : Text('No file selected',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(color: Colors.white)),
              const SizedBox(height: 16),
              Text('Interpol Letter',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(color: Colors.white)),
              const SizedBox(height: 8),
              interpolLetterFile != null
                  ? Image.file(interpolLetterFile!)
                  : Text('No file selected',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(color: Colors.white)),
              const SizedBox(height: 16),
              Text('Selfie',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(color: Colors.white)),
              const SizedBox(height: 8),
              selfieFile != null
                  ? Image.file(selfieFile!)
                  : Text('No file selected',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(color: Colors.white)),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DocumentUploadScreen(
                              frontIdFile: frontIdFile!,
                              backIdFile: backIdFile!,
                              interpolLetterFile: interpolLetterFile!,
                              selfieFile: selfieFile!)));
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(280, 50),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                ).copyWith(
                  backgroundColor: MaterialStateProperty.all(Colors.white),
                ),
                child: Text(
                  'Submit Documents',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: Colors.black,
                        fontSize: 18,
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
