import 'dart:io';

import 'package:caravan/models/user_profile.dart';
import 'package:caravan/providers/user_profile.provider.dart';
import 'package:caravan/screens/authenticate/change_password.dart';
import 'package:caravan/screens/authenticate/interim_login.dart';
import 'package:caravan/screens/more%20screens/driver/documents/national_id.dart';

import 'package:caravan/screens/more%20screens/profile.dart';
import 'package:caravan/services/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

final logger = Logger();

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  Future<void> _loadImage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? imagePath = prefs.getString('imagePath');
    if (imagePath != null) {
      setState(() {
        _imageFile = File(imagePath);
      });
    }
  }

  final firebaseStorage = FirebaseStorage.instance;
  ValueNotifier<double> uploadProgress = ValueNotifier(0);
  ValueNotifier<bool> uploadComplete = ValueNotifier(false);
  late UserProfileProvider userProfileProvider;
  late UserProfile userProfile;
  bool _isDriver = false; // Assuming initial role is passenger
  @override
  Widget build(BuildContext context) {
    userProfileProvider = Provider.of(context);
    userProfile = userProfileProvider.userProfile;
    String username = userProfileProvider.userProfile.username!;
    _isDriver = userProfile.isDriver;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
        ),
        // iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: Column(
          children: [
            CircleAvatar(
              backgroundColor: Colors.white60,
              radius: 50,
              backgroundImage: _imageFile != null
                  ? FileImage(_imageFile!)
                  : userProfile.photoUrl != null
                      ? NetworkImage(userProfile.photoUrl!)
                          as ImageProvider<Object>?
                      : null,
              child: Stack(
                children: [
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: IconButton(
                      icon: const Icon(
                        Icons.add_a_photo,
                        color: Color.fromARGB(255, 255, 255, 255),
                      ),
                      onPressed: () {
                        showImagePickerBottomSheet(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Text(username,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                      fontSize: 16,
                    )),
            Text(userProfile.email!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                      fontSize: 16,
                    )),
            const SizedBox(
              height: 15,
            ),
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Container(
                  decoration: const BoxDecoration(
                      color: Colors.white12,
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: ListView(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.person, color: Colors.white),
                        title: Text(
                          "Personal data",
                          style:
                              Theme.of(context).textTheme.labelMedium?.copyWith(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                        ),
                        onTap: () {
                          // Handle profile tap
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => // Initialize userProfile variable
                                        const ProfileScreen(),
                              ));
                        },
                      ),
                      const Divider(
                        height: 1,
                        color: Colors.white12,
                      ),
                      ListTile(
                        leading:
                            const Icon(Icons.car_rental, color: Colors.white),
                        title: Text(
                          "Driver",
                          style:
                              Theme.of(context).textTheme.labelMedium?.copyWith(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                        ),
                        trailing: Switch(
                          value: userProfile.isDriver,
                          onChanged: (newValue) {
                            _toggleRole();
                          },
                          activeColor: Colors.green,
                          inactiveThumbColor: Colors.grey,
                          inactiveTrackColor: Colors.grey[300],
                        ),
                      ),
                      const Divider(
                        height: 1,
                        color: Colors.white12,
                      ),
                      ListTile(
                        leading: const Icon(Icons.delete, color: Colors.white),
                        title: Text(
                          'Delete account',
                          style:
                              Theme.of(context).textTheme.labelMedium?.copyWith(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                        ),
                        onTap: () {
                          // Handle option 2 tap
                        },
                      ),
                      const Divider(
                        height: 1,
                        color: Colors.white12,
                      ),
                      ListTile(
                        leading:
                            const Icon(Icons.password, color: Colors.white),
                        title: Text(
                          'change password',
                          style:
                              Theme.of(context).textTheme.labelMedium?.copyWith(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const ChangePasswordScreen()));
                        },
                      ),
                      const Divider(
                        height: 1,
                        color: Colors.white12,
                      ),
                      ListTile(
                        leading: const Icon(Icons.document_scanner_rounded,
                            color: Colors.white),
                        title: Text(
                          'Upload Documents',
                          style:
                              Theme.of(context).textTheme.labelMedium?.copyWith(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const IdDocumentUploadScreen()));
                        },
                      ),
                      const Divider(
                        height: 1,
                        color: Colors.white12,
                      ),
                      ListTile(
                        leading: const Icon(Icons.power_settings_new,
                            color: Colors.white),
                        title: Text(
                          'Logout',
                          style:
                              Theme.of(context).textTheme.labelMedium?.copyWith(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                        ),
                        onTap: () {
                          FirebaseAuth.instance.signOut();

                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const MyLogin()),
                              (route) => false);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _toggleRole() async {
    logger.d("The value of the issue Driver is $_isDriver");
    String userId = userProfileProvider.userProfile.userID!;
    DatabaseService databaseService = DatabaseService();

    if (_isDriver) {
      // If the user is currently a driver, allow switching to passenger without any checks
      await databaseService.toggleIsDriver(userId, false);
      setState(() {
        _isDriver = false;
        userProfile.isDriver =
            false; // Update userProfile directly if it's used in the UI
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          'You are now a passenger.',
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: Colors.white,
                fontSize: 16,
              ),
        ),
      ));
    } else {
      // Check if the user has the 'documents' field in the database
      bool docExists = await databaseService.documentExists(userId);
      if (!docExists) {
        // Prompt user to submit documents
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            'Please submit your documents for review.',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: Colors.white,
                  fontSize: 16,
                ),
          ),
        ));
        return;
      }

      // Check if documents are approved
      bool isApproved = await databaseService.isDocumentApproved(userId);
      if (isApproved) {
        await databaseService.toggleIsDriver(userId, true);
        setState(() {
          _isDriver = true;
          userProfile.isDriver =
              true; // Update userProfile directly if it's used in the UI
        });
        logger.d("The value of the issue Driver is $_isDriver");

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            'You are now a driver.',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: Colors.white,
                  fontSize: 16,
                ),
          ),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            'Your documents are awaiting review.',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: Colors.white,
                  fontSize: 16,
                ),
          ),
        ));
      }
    }
  }

  void showImagePickerBottomSheet(BuildContext context) {
    showModalBottomSheet(
      showDragHandle: true,
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 200,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildTakePhotoTile(context),
              buildChoosePhotoTile(context),
            ],
          ),
        );
      },
    );
  }

  ListTile buildTakePhotoTile(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.camera),
      title: const Text('Take a Photo'),
      onTap: () async {
        try {
          final ImagePicker picker = ImagePicker();
          final XFile? image =
              await picker.pickImage(source: ImageSource.camera);
          if (image != null) {
            File file = File(image.path);
            showImagePreviewDialog(context, file);
          }
        } catch (e) {
          print('Failed to take photo: $e');
          showErrorDialog(context, 'Failed to take photo: $e');
        }
      },
    );
  }

  TextButton buildCancelButton(BuildContext context) {
    return TextButton(
      child: Text('Cancel',
          style: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(color: Colors.redAccent)),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  ListTile buildChoosePhotoTile(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.photo_library),
      title: const Text('Choose a Photo'),
      onTap: () async {
        try {
          final ImagePicker picker = ImagePicker();
          final XFile? image =
              await picker.pickImage(source: ImageSource.gallery);
          if (image != null) {
            File file = File(image.path);
            showImagePreviewDialog(context, file);

            // Save the image path to SharedPreferences
            final SharedPreferences prefs =
                await SharedPreferences.getInstance();
            await prefs.setString('imagePath', file.path);
          }
        } catch (e) {
          showErrorDialog(context, 'Failed to pick image: $e');
        }
      },
    );
  }

  void showImagePreviewDialog(BuildContext context, File file) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Image Preview'),
          content: Image.file(file),
          actions: [
            buildCancelButton(context),
            buildUploadButton(context, file),
          ],
        );
      },
    );
  }

  TextButton buildUploadButton(BuildContext context, File file) {
    return TextButton(
      style: ElevatedButton.styleFrom(elevation: 0),
      child: Text(
        'Upload',
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: const Color.fromARGB(255, 0, 0, 0),
            ),
      ),
      onPressed: () {
        showUploadProgressDialog(context, file);
      },
    );
  }

  void showUploadProgressDialog(BuildContext context, File file) {
    // Create a Reference to the file
    Reference storageRef = firebaseStorage
        .ref()
        .child('profile_pictures/${userProfileProvider.userProfile.userID}');

    // Start the upload.
    var uploadTask = storageRef.putFile(file);

    // Listen for snapshot events to monitor the upload progress.
    uploadTask.snapshotEvents.listen((event) {
      logger
          .i('Upload progress: ${event.bytesTransferred}/${event.totalBytes}');
      uploadProgress.value = event.bytesTransferred / event.totalBytes;
    });

    uploadTask.whenComplete(() async {
      if (uploadTask.snapshot.state != TaskState.canceled) {
        try {
          uploadComplete.value = true;
          // Get the download URL.

          final String downloadURL = await storageRef.getDownloadURL();
          DatabaseService().updateUserProfilePicture(
              userProfileProvider.userProfile.userID!, downloadURL);

          userProfileProvider.userProfile.photoUrl = downloadURL;

          // Use the download URL (e.g., save it to Firestore, display it in the app).
          print('Download URL: $downloadURL');
          Navigator.pop(context);
          Navigator.pop(context);
        } catch (e) {
          // The upload failed, handle the error.
          showErrorDialog(context, 'Upload failed with error: $e');
        }
      }
    });

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return buildUploadProgressDialog(context);
      },
    );

    setState(() {
      _loadImage();
    });
  }

  void showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              child: const Text(
                'OK',
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  ValueListenableBuilder<bool> buildUploadProgressDialog(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: uploadComplete,
      builder: (context, value, child) {
        if (value) {
          Navigator.pop(context);
        }
        return AlertDialog(
          title: const Text('Uploading Image'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Show a progress indicator
              ValueListenableBuilder<double>(
                valueListenable: uploadProgress,
                builder: (context, value, child) {
                  return LinearProgressIndicator(
                      color: Colors.blue, value: value);
                },
              ),
              const SizedBox(height: 10),
              const Text(
                  'Uploading...'), // Show a message indicating the upload is in progress
            ],
          ),
        );
      },
    );
  }
}
