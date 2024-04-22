// import 'package:caravan/models/user_profile.dart';
// import 'package:caravan/providers/chat_provider.dart';
// import 'package:caravan/providers/location_provider.dart';
// import 'package:caravan/providers/user_profile.provider.dart';
// import 'package:caravan/services/database_service.dart';
// import 'package:caravan/services/location_service.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:logger/logger.dart';
// import 'package:provider/provider.dart';

// final logger = Logger();

// class ServiceInit {
//   final UserProfileProvider userProfileProvider;
//   final ChatProvider chatProvider;

//   static final user = FirebaseAuth.instance.currentUser;
//   ServiceInit(this.userProfileProvider, this.chatProvider) {
//     initializeAppData();
//   }

//   Future<void> initializeAppData() async {
//     Future.delayed(const Duration(seconds: 2));
//     if (user != null) {
//       //location

//       final userProfile = await DatabaseService().getUserProfile(user!.uid);
//       userProfileProvider.userProfile = userProfile;

//       // logger.i('User profile: $userProfile');

//       final user1 = UserProfileProvider().userProfile;
//       logger.i('The User is : $user1');

//       // get user chats
//       chatProvider.listenToChatrooms();
//     }
//   }
// }
