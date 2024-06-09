import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
      );

  final options =
      const IOSOptions(accessibility: KeychainAccessibility.first_unlock);

  Future<void> writeSecureData(String key, String value) async {
    await _storage.write(
        key: key,
        value: value,
        aOptions: _getAndroidOptions(),
        iOptions: options);
  }

  Future<String?> readSecureData(String key) async {
    return await _storage.read(
        key: key, aOptions: _getAndroidOptions(), iOptions: options);
  }

  Future<void> deleteSecureData(String key) async {
    await _storage.delete(
        key: key, aOptions: _getAndroidOptions(), iOptions: options);
  }
}
