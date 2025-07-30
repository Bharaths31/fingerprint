// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
// Import the storage service to get the count
import 'package:fingerprint/services/storage_service.dart'; // Change 'your_app_name'

// 1. Convert to StatefulWidget
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // 2. Add state variable and service instance
  int _fingerprintLoginCount = 0;
  final StorageService _storageService = StorageService();

  // 3. Load the count when the screen initializes
  @override
  void initState() {
    super.initState();
    _loadLoginCount();
  }

  Future<void> _loadLoginCount() async {
    final count = await _storageService.getFingerprintLoginCount();
    if (mounted) {
      setState(() {
        _fingerprintLoginCount = count;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.verified_user, size: 80, color: Colors.green),
            const SizedBox(height: 16),
            const Text(
              '🎉 Welcome!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const Text('You are successfully logged in.'),
            const SizedBox(height: 40), // Add some space
            
            // 4. Display the counter
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.fingerprint, color: Colors.blueGrey),
                const SizedBox(width: 8),
                Text(
                  'Fingerprint Logins: $_fingerprintLoginCount',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}