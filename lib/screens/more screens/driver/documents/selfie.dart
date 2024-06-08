import 'dart:io';

import 'package:caravan/screens/more%20screens/driver/documents/upload.dart';
import 'package:flutter/material.dart';
import 'package:caravan/services/image_picker_service.dart';

import 'package:image_picker/image_picker.dart';

class SelfieUploadScreen extends StatefulWidget {
  final File frontIdFile;
  final File backIdFile;
  final File interpolLetterFile;

  const SelfieUploadScreen({
    super.key,
    required this.frontIdFile,
    required this.backIdFile,
    required this.interpolLetterFile,
  });

  @override
  _SelfieUploadScreenState createState() => _SelfieUploadScreenState();
}

class _SelfieUploadScreenState extends State<SelfieUploadScreen> {
  final ImagePickerService _imagePickerService = ImagePickerService();
  File? selfieFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          'Upload Selfie',
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
              const Text(
                'Upload Selfie',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () async {
                  File? file =
                      await _imagePickerService.pickImage(ImageSource.camera);
                  setState(() {
                    selfieFile = file;
                  });
                },
                child: Container(
                  width: double.infinity,
                  height: 200,
                  color: Colors.grey[200],
                  child: selfieFile != null
                      ? Image.file(selfieFile!)
                      : const Center(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(' selfie Preview'),
                                SizedBox(
                                  height: 8,
                                ),
                                Icon(
                                  Icons.add_a_photo,
                                  color: Colors.black,
                                  size: 30,
                                )
                              ],
                            ),
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (selfieFile != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DocumentUploadScreen(
                          frontIdFile: widget.frontIdFile,
                          backIdFile: widget.backIdFile,
                          interpolLetterFile: widget.interpolLetterFile,
                          selfieFile: selfieFile!,
                        ),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Please upload your selfie')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(280, 50),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                ).copyWith(
                  backgroundColor: WidgetStateProperty.all(Colors.white),
                ),
                child: Text(
                  'Review Documents',
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
