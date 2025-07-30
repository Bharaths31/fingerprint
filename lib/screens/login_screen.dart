// lib/screens/login_screen.dart

import 'package:flutter/material.dart';
import 'package:fingerprint/services/auth_service.dart'; // Change 'your_app_name'
import 'package:fingerprint/services/storage_service.dart'; // Change 'your_app_name'

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _authService = AuthService();
  final StorageService _storageService = StorageService();
  final TextEditingController _passwordController = TextEditingController();

  bool _isBiometricAvailable = false;
  bool _isBiometricEnabled = false;

  @override
  void initState() {
    super.initState();
    _checkBiometricStatus();
  }

  Future<void> _checkBiometricStatus() async {
    _isBiometricAvailable = await _authService.canCheckBiometrics();
    _isBiometricEnabled = await _storageService.isBiometricEnabled();
    if (mounted) {
      setState(() {});
      if (_isBiometricEnabled && _isBiometricAvailable) {
        _tryBiometricLogin();
      }
    }
  }

  Future<void> _tryBiometricLogin() async {
    final didAuthenticate = await _authService.authenticateWithBiometrics();
    if (didAuthenticate && mounted) {
      await _storageService.incrementFingerprintLoginCount();
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  Future<void> _loginWithPassword() async {
    final isValid = _authService.authenticateWithPassword(_passwordController.text);
    if (!isValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Incorrect Password'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (!_isBiometricEnabled && _isBiometricAvailable) {
      await _showRegisterBiometricDialog();
    } else {
       if(mounted) Navigator.pushReplacementNamed(context, '/home');
    }
  }

  Future<void> _showRegisterBiometricDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Enable Fingerprint Login?'),
        content: const Text('Would you like to use your fingerprint for future logins?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Yes'),
          ),
        ],
      ),
    );

    if (result == true) {
      final didAuthenticate = await _authService.authenticateWithBiometrics();
      if (didAuthenticate) {
        await _storageService.setBiometricEnabled(true);
        if(mounted) ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Fingerprint login enabled!'), backgroundColor: Colors.green),
        );
      }
    }
     if(mounted) Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.lock_outline, size: 80),
            const SizedBox(height: 24),
            Text(
              'Enter your 4-digit password',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              keyboardType: TextInputType.number,
              obscureText: true,
              maxLength: 4,
              textAlign: TextAlign.center,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                counterText: '',
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loginWithPassword,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('LOGIN'),
            ),
            const SizedBox(height: 16),
            if (_isBiometricEnabled && _isBiometricAvailable)
              OutlinedButton.icon(
                icon: const Icon(Icons.fingerprint),
                label: const Text('Use Fingerprint'),
                onPressed: _tryBiometricLogin,
                style: OutlinedButton.styleFrom(
                   padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
          ],
        ),
      ),
    );
  }

   @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }
}