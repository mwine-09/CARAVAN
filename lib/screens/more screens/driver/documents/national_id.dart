import 'dart:io';

import 'package:caravan/screens/more%20screens/driver/documents/interpol.dart';
import 'package:caravan/services/image_picker_service.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class IdDocumentUploadScreen extends StatefulWidget {
  const IdDocumentUploadScreen({super.key});

  @override
  State<IdDocumentUploadScreen> createState() => _IdDocumentUploadScreenState();
}

class _IdDocumentUploadScreenState extends State<IdDocumentUploadScreen> {
  final ImagePickerService _imagePickerService = ImagePickerService();
  File? frontIdFile;
  File? backIdFile;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          'Upload ID Documents',
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // const SizedBox(height: 8),
              const Text(
                'Select Front ID',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              const SizedBox(height: 16),
              // Preview box for front ID image
              GestureDetector(
                onTap: (() async {
                  //allow to upload pictures or take
                  File? file =
                      await _imagePickerService.pickImage(ImageSource.camera);
                  if (file != null) {
                    setState(() {
                      frontIdFile = file;
                    });
                  }
                }),
                child: Container(
                  width: double.infinity,
                  height: 250,
                  color: Colors.grey[200],
                  child: frontIdFile != null
                      ? Image.file(frontIdFile!)
                      : const Center(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Front ID Preview'),
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
              const Text(
                'Upload Back of ID',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              const SizedBox(height: 8),
              // const Text('Select Back ID'),
              const SizedBox(height: 8),
              // Preview box for back ID image
              GestureDetector(
                onTap: (() async {
                  File? file =
                      await _imagePickerService.pickImage(ImageSource.camera);
                  if (file != null) {
                    setState(() {
                      backIdFile = file;
                    });
                  }
                }),
                child: Container(
                  width: double.infinity,
                  height: 250,
                  color: Colors.grey[200],
                  child: backIdFile != null
                      ? Image.file(backIdFile!)
                      : const Center(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Back ID Preview'),
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
                  // Navigate to the next screen for the Interpol letter

                  if (backIdFile == null || frontIdFile == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text(
                              'Make sure to upload both the front and back photos')),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => InterpolLetterUploadScreen(
                            frontIdFile: frontIdFile!, backIdFile: backIdFile!),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(280, 50),
                  // reduce rounded corners
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                ).copyWith(
                  backgroundColor: WidgetStateProperty.all(Colors.white),
                  minimumSize: WidgetStateProperty.all(const Size(80, 50)),
                ),
                child: Text('Next: Interpol Letter',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: Colors.black,
                          fontSize: 18,
                        )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
