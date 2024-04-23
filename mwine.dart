                    //  onPressed: () {
                    //     showModalBottomSheet(
                    //       showDragHandle: true,
                    //       context: context,
                    //       builder: (BuildContext context) {
                    //         return SizedBox(
                    //           height: 200,
                    //           child: Column(
                    //             mainAxisSize: MainAxisSize.min,
                    //             children: [
                    //               ListTile(
                    //                 leading: const Icon(Icons.camera),
                    //                 title: const Text('Take a Photo'),
                    //                 onTap: () {
                    //                   Navigator.pop(context);
                    //                 },
                    //               ),
                    //               ListTile(
                    //                 leading: const Icon(Icons.photo_library),
                    //                 title: const Text('Choose a Photo'),
                    //                 onTap: () async {
                    //                   final ImagePicker picker = ImagePicker();
                    //                   final XFile? image =
                    //                       await picker.pickImage(
                    //                           source: ImageSource.gallery);
                    //                   if (image != null) {
                    //                     File file = File(image.path);

                    //                     showDialog(
                    //                       context: context,
                    //                       builder: (BuildContext context) {
                    //                         return AlertDialog(
                    //                             title:
                    //                                 const Text('Image Preview'),
                    //                             content: Image.file(file),
                    //                             actions: [
                    //                               TextButton(
                    //                                 child: Text('Cancel',
                    //                                     style: Theme.of(context)
                    //                                         .textTheme
                    //                                         .bodyMedium!
                    //                                         .copyWith(
                    //                                             color: Colors
                    //                                                 .redAccent)),
                    //                                 onPressed: () {
                    //                                   Navigator.pop(context);
                    //                                 },
                    //                               ),
                    //                               TextButton(
                    //                                   style: ElevatedButton
                    //                                       .styleFrom(
                    //                                           elevation: 0),
                    //                                   child: Text(
                    //                                     'Upload',
                    //                                     style: Theme.of(context)
                    //                                         .textTheme
                    //                                         .bodyMedium!
                    //                                         .copyWith(
                    //                                           color: const Color
                    //                                               .fromARGB(
                    //                                               255, 0, 0, 0),
                    //                                         ),
                    //                                   ),
                    //                                   onPressed: () {
                    //                                     showDialog(
                    //                                       context: context,
                    //                                       builder: (BuildContext
                    //                                           context) {
                    //                                         // Create a Reference to the file
                    //                                         Reference
                    //                                             storageRef =
                    //                                             firebaseStorage
                    //                                                 .ref()
                    //                                                 .child(
                    //                                                     'profile_pictures/${userProfile.userID}');

                    //                                         // Start the upload.
                    //                                         var uploadTask =
                    //                                             storageRef
                    //                                                 .putFile(
                    //                                                     file);

                    //                                         // Listen for snapshot events to monitor the upload progress.
                    //                                         uploadTask
                    //                                             .snapshotEvents
                    //                                             .listen(
                    //                                                 (event) {
                    //                                           logger.i(
                    //                                               'Upload progress: ${event.bytesTransferred}/${event.totalBytes}');
                    //                                           uploadProgress
                    //                                               .value = event
                    //                                                   .bytesTransferred /
                    //                                               event
                    //                                                   .totalBytes;
                    //                                         });

                    //                                         uploadTask
                    //                                             .whenComplete(
                    //                                                 () async {
                    //                                           try {
                    //                                             uploadComplete
                    //                                                     .value =
                    //                                                 true;
                    //                                             // Get the download URL.
                    //                                             final String
                    //                                                 downloadURL =
                    //                                                 await storageRef
                    //                                                     .getDownloadURL();
                    //                                             DatabaseService().updateUserProfilePicture(
                    //                                                 userProfileProvider
                    //                                                     .userProfile
                    //                                                     .userID!,
                    //                                                 downloadURL);

                    //                                             userProfileProvider
                    //                                                     .userProfile
                    //                                                     .photoUrl =
                    //                                                 downloadURL;

                    //                                             // Use the download URL (e.g., save it to Firestore, display it in the app).
                    //                                             print(
                    //                                                 'Download URL: $downloadURL');
                    //                                             Navigator.pop(
                    //                                                 context);
                    //                                           } catch (e) {
                    //                                             // The upload failed, handle the error.
                    //                                             print(
                    //                                                 'Upload failed with error: $e');
                    //                                           }
                    //                                         });

                    //                                         return ValueListenableBuilder<
                    //                                                 bool>(
                    //                                             valueListenable:
                    //                                                 uploadComplete,
                    //                                             builder:
                    //                                                 ((context,
                    //                                                     value,
                    //                                                     child) {
                    //                                               if (value) {
                    //                                                 Navigator.pop(
                    //                                                     context);
                    //                                               }
                    //                                               return AlertDialog(
                    //                                                 title: const Text(
                    //                                                     'Uploading Image'),
                    //                                                 content:
                    //                                                     Column(
                    //                                                   mainAxisSize:
                    //                                                       MainAxisSize
                    //                                                           .min,
                    //                                                   children: [
                    //                                                     // Show a progress indicator
                    //                                                     ValueListenableBuilder<
                    //                                                         double>(
                    //                                                       valueListenable:
                    //                                                           uploadProgress,
                    //                                                       builder: (context,
                    //                                                           value,
                    //                                                           child) {
                    //                                                         return LinearProgressIndicator(
                    //                                                             color: Colors.blue,
                    //                                                             value: value);
                    //                                                       },
                    //                                                     ),
                    //                                                     const SizedBox(
                    //                                                         height:
                    //                                                             10),
                    //                                                     const Text(
                    //                                                         'Uploading...'), // Show a message indicating the upload is in progress
                    //                                                   ],
                    //                                                 ),
                    //                                               );
                    //                                             }));
                    //                                       },
                    //                                     );
                    //                                   })
                    //                             ]);
                    //                       },
                    //                     );
                    //                   }
                    //                 },
                    //               ),
                    //             ],
                    //           ),
                    //         );
                    //       },
                    //     );
                      
                      
                    //   },