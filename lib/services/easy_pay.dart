import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class EasypayService {
  final String clientId;
  final String secret;
  final String apiUrl = 'https://www.easypay.co.ug/api/';
  final Logger logger = Logger();

  static EasypayService? _instance;

  factory EasypayService({
    required String clientId,
    required String secret,
  }) {
    _instance ??= EasypayService._internal(
      clientId: clientId,
      secret: secret,
    );
    return _instance!;
  }

  EasypayService._internal({
    required this.clientId,
    required this.secret,
  });

  Future<Map<String, dynamic>> mmDeposit({
    required double amount,
    required String phone,
    required String reference,
    required String reason,
  }) async {
    final payload = {
      'username': clientId,
      'password': secret,
      'action': 'mmdeposit',
      'amount': amount,
      'currency': 'UGX',
      'phone': phone,
      'reference': reference,
      'reason': reason,
    };
    return _runTransaction(payload);
  }

  Future<Map<String, dynamic>> mmPayout({
    required double amount,
    required String phone,
    required String reference,
  }) async {
    final payload = {
      'username': clientId,
      'password': secret,
      'action': 'mmpayout',
      'amount': amount,
      'currency': 'UGX',
      'phone': phone,
      'reference': reference,
    };
    return _runTransaction(payload);
  }

  Future<Map<String, dynamic>> checkBalance() async {
    final payload = {
      'username': clientId,
      'password': secret,
      'action': 'checkbalance',
    };
    return _runTransaction(payload);
  }

  Future<Map<String, dynamic>> mmStatus(String reference) async {
    final payload = {
      'username': clientId,
      'password': secret,
      'action': 'mmstatus',
      'reference': reference,
    };
    return _runTransaction(payload);
  }

  Future<Map<String, dynamic>> _runTransaction(
      Map<String, dynamic> payload) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(payload),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      if (responseData['success'] == 1) {
        return responseData;
      } else {
        throw Exception('Transaction failed: ${responseData['errormsg']}');
      }
    } else {
      throw Exception('Network error: ${response.statusCode}');
    }
  }
}
