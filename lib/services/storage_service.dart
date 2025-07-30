// lib/services/storage_service.dart

import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const _biometricEnabledKey = 'biometric_enabled';
  static const _fingerprintCountKey = 'fingerprint_login_count';

  // Check if the user has enabled biometric authentication.
  Future<bool> isBiometricEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_biometricEnabledKey) ?? false;
  }

  // Set the biometric authentication preference.
  Future<void> setBiometricEnabled(bool isEnabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_biometricEnabledKey, isEnabled);
  }

   // Gets the current count of fingerprint logins.
  Future<int> getFingerprintLoginCount() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_fingerprintCountKey) ?? 0;
  }

  // Increments the fingerprint login count by one.
  Future<void> incrementFingerprintLoginCount() async {
    final prefs = await SharedPreferences.getInstance();
    int currentCount = await getFingerprintLoginCount();
    await prefs.setInt(_fingerprintCountKey, currentCount + 1);
  }
}