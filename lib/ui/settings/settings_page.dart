import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            // Button to clear shared preferences
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Clear Data'),
              subtitle: const Text('Clear all stored shared preferences'),
              onTap: () => _clearSharedPreferences(context),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _clearSharedPreferences(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    bool success = await prefs.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(success
            ? 'Shared Preferences cleared successfully!'
            : 'Failed to clear Shared Preferences'),
      ),
    );
  }
}
