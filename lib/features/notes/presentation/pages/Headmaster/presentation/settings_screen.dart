import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text("Update Profile"),
            onTap: () {
              // TODO: Navigate to profile edit screen
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Profile update clicked")),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.lock),
            title: const Text("Change Password"),
            onTap: () {
              // TODO: Change password flow
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Change password clicked")),
              );
            },
          ),
        ],
      ),
    );
  }
}
