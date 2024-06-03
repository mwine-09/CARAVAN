import 'dart:io';

import 'package:caravan/screens/more%20screens/driver/documents/selfie.dart';

import 'package:flutter/material.dart';
import 'package:caravan/services/image_picker_service.dart';
import 'package:image_picker/image_picker.dart';

ImagePickerService imagePickerService = ImagePickerService();

class InterpolLetterUploadScreen extends StatefulWidget {
  final File? frontIdFile;
  final File? backIdFile;

  const InterpolLetterUploadScreen(
      {super.key, required this.frontIdFile, required this.backIdFile});

  @override
  _InterpolLetterUploadScreenState createState() =>
      _InterpolLetterUploadScreenState();
}

class _InterpolLetterUploadScreenState
    extends State<InterpolLetterUploadScreen> {
  final ImagePickerService _imagePickerService = ImagePickerService();
  File? interpolLetterFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          'Upload Interpol Letter',
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
              const Text('Select Interpol Letter'),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () async {
                  File? file =
                      await _imagePickerService.pickImage(ImageSource.camera);
                  setState(() {
                    interpolLetterFile = file;
                  });
                },
                child: Container(
                  width: double.infinity,
                  height: 400,
                  color: Colors.grey[200],
                  child: interpolLetterFile != null
                      ? Image.file(interpolLetterFile!)
                      : const Center(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Interpol letter preview'),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (interpolLetterFile != null)
                    ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          // minimumSize: const Size(280, 50),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                        ).copyWith(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.white),
                        ),
                        child: Text(
                          'Retake',
                          style:
                              Theme.of(context).textTheme.labelMedium?.copyWith(
                                    color: Colors.black,
                                    fontSize: 18,
                                  ),
                        )),
                  ElevatedButton(
                    onPressed: () {
                      if (interpolLetterFile != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SelfieUploadScreen(
                                frontIdFile: widget.frontIdFile,
                                backIdFile: widget.backIdFile,
                                interpolLetterFile: interpolLetterFile),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Please upload Interpol letter')),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      // minimumSize: const Size(280, 50),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                    ).copyWith(
                      backgroundColor: MaterialStateProperty.all(Colors.white),
                    ),
                    child: Text(
                      'Next: Selfie',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: Colors.black,
                            fontSize: 18,
                          ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
