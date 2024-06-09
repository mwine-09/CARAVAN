import 'package:caravan/providers/chat_provider.dart';
import 'package:caravan/services/database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:caravan/models/user_profile.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfileProvider extends ChangeNotifier {
  static UserProfile _userProfile = UserProfile();
  final _firestore = FirebaseFirestore.instance;

  UserProfile get userProfile => _userProfile;

  set userProfile(UserProfile value) {
    _userProfile = value;
    notifyListeners();
  }

  Future<void> initialize(String uid) async {
    try {
      UserProfile? profile = await DatabaseService().getUserProfile(uid);
      userProfile = profile;
    } catch (e) {
      logger.e('Failed to initialize user profile: $e');
      userProfile =
          UserProfile(); // Set to a default value if initialization fails
    }
  }

  Future<void> loadUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    try {
      String? userProfileString = prefs.getString('userProfile');
      if (userProfileString != null && userProfileString.isNotEmpty) {
        _userProfile = UserProfile.fromJson(jsonDecode(userProfileString));
      } else {
        _userProfile = UserProfile(); // Default value
      }
      notifyListeners();
    } catch (e) {
      logger.e('Failed to load user profile: $e');
      _userProfile = UserProfile(); // Set to a default value if loading fails
      notifyListeners();
    }
  }

  Future<void> saveUserProfile(UserProfile userProfile) async {
    final prefs = await SharedPreferences.getInstance();
    try {
      await prefs.setString('userProfile', jsonEncode(userProfile.toJson()));
      _userProfile = userProfile;
      logger.i('User profile saved successfully.');
      notifyListeners();
    } catch (e) {
      logger.e('Failed to save user profile: $e');
    }
  }

  void updateUserProfile(UserProfile newProfile) {
    userProfile = newProfile;
  }

  Future<void> updateWallet(double amount, String action) async {
    try {
      await _firestore.runTransaction((transaction) async {
        DocumentReference balanceRef = _firestore
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('wallet')
            .doc('balance');

        DocumentSnapshot balanceSnapshot = await transaction.get(balanceRef);
        double currentBalance = 0.0;
        if (balanceSnapshot.exists) {
          var balanceData =
              (balanceSnapshot.data() as Map<String, dynamic>?)?['balance'];
          if (balanceData is int) {
            currentBalance = balanceData.toDouble();
          } else if (balanceData is double) {
            currentBalance = balanceData;
          }
        }

        if (action == 'deposit') {
          transaction.update(balanceRef, {'balance': currentBalance + amount});
          userProfile.wallet!.balance = currentBalance + amount;
        } else if (action == 'withdraw') {
          transaction.update(balanceRef, {'balance': currentBalance - amount});
          userProfile.wallet!.balance = currentBalance - amount;
        } else {
          throw Exception('Invalid action type');
        }

        _addTransactionHistory(transaction, action, amount);
      });
      logger.i('Wallet updated successfully.');
    } catch (e) {
      logger.e('Failed to update wallet: $e');
      rethrow;
    }
    notifyListeners();
  }

  void _addTransactionHistory(
    Transaction transaction,
    String type,
    double amount, {
    String? recipientId,
  }) {
    DocumentReference historyRef = _firestore
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('wallet')
        .doc('balance')
        .collection('history')
        .doc();

    Map<String, dynamic> historyData = {
      'type': type,
      'amount': amount,
      'timestamp': FieldValue.serverTimestamp(),
      'recipientId': recipientId,
    };

    transaction.set(historyRef, historyData);
  }

  void reset() {
    _userProfile = UserProfile();
    notifyListeners();
  }
}
