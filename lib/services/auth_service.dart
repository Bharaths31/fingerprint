// lib/services/auth_service.dart

import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:fingerprint/utils/constants.dart'; // Change 'your_app_name'

class AuthService {
  final LocalAuthentication _auth = LocalAuthentication();

  // Checks if the password matches the default password.
  bool authenticateWithPassword(String password) {
    return password == kDefaultPassword;
  }

  // Checks if biometric hardware is available on the device.
  Future<bool> canCheckBiometrics() async {
    try {
      return await _auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      print(e);
      return false;
    }
  }

  // Triggers the biometric authentication prompt.
  Future<bool> authenticateWithBiometrics() async {
    try {
      return await _auth.authenticate(
        localizedReason: 'Scan your fingerprint to authenticate',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );
    } on PlatformException catch (e) {
      print(e);
      return false;
    }
  }
}