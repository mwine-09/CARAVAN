import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerService {
  final ImagePicker _picker = ImagePicker();

  Future<File?> pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(source: source);
      if (image != null) {
        return File(image.path);
      }
    } catch (e) {
      print('Failed to pick image: $e');
    }
    return null;
  }

  Future<void> uploadImage({
    required BuildContext context,
    required File file,
    required String userId,
    required String documentType,
    required void Function(String) onSuccess,
    required void Function(String) onError,
  }) async {
    try {
      // Create a reference to the file in Firebase Storage
      Reference storageRef = FirebaseStorage.instance
          .ref()
          .child('documents/$userId/$documentType');

      // Start the upload
      UploadTask uploadTask = storageRef.putFile(file);

      // Show the upload progress dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => UploadProgressDialog(uploadTask: uploadTask),
      );

      // Wait for the upload to complete
      TaskSnapshot snapshot = await uploadTask;

      // Get the download URL
      String downloadURL = await snapshot.ref.getDownloadURL();

      // Save the document URL to Firestore
      await FirebaseFirestore.instance.collection('documents').add({
        'userId': userId,
        'documentType': documentType,
        'documentURL': downloadURL,
        'status': 'pending',
      });

      onSuccess(downloadURL);
    } catch (e) {
      onError('Failed to upload image: $e');
    }
  }
}

class UploadProgressDialog extends StatelessWidget {
  final UploadTask uploadTask;

  const UploadProgressDialog({super.key, required this.uploadTask});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<TaskSnapshot>(
      stream: uploadTask.snapshotEvents,
      builder: (context, snapshot) {
        double progress = 0.0;
        if (snapshot.hasData) {
          progress = snapshot.data!.bytesTransferred.toDouble() /
              snapshot.data!.totalBytes.toDouble();
        }
        return AlertDialog(
          title: const Text('Uploading Image'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              LinearProgressIndicator(value: progress),
              const SizedBox(height: 10),
              const Text('Uploading...'),
            ],
          ),
        );
      },
    );
  }
}

class UploadService {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadFile({
    required File file,
    required String path,
    required ValueNotifier<double> uploadProgress,
  }) async {
    try {
      final Reference storageRef = _firebaseStorage.ref().child(path);
      final UploadTask uploadTask = storageRef.putFile(file);

      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        uploadProgress.value = snapshot.bytesTransferred.toDouble() /
            snapshot.totalBytes.toDouble();
      });

      await uploadTask.whenComplete(() async {
        if (uploadTask.snapshot.state == TaskState.success) {
          final String downloadURL = await storageRef.getDownloadURL();
          return downloadURL;
        } else {
          throw Exception('File upload failed');
        }
      });

      // Adding a return statement here to ensure a value is always returned
      return await storageRef.getDownloadURL();
    } catch (e) {
      print('Error uploading file: $e');
      throw Exception('Error uploading file: $e');
    }
  }

  Future<void> saveDocumentUrls(String userId, Map<String, String> urls) async {
    try {
      await _firestore.collection('documents').doc(userId).set({
        ...urls,
        'status': 'pending', // Initial status can be 'pending' or as needed
      });
    } catch (e) {
      print('Error saving document URLs: $e');
      throw Exception('Error saving document URLs: $e');
    }
  }
}
