import 'package:flutter/material.dart';

class SchoolInfoScreen extends StatelessWidget {
  const SchoolInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("School Info")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("School Name: Future Leaders Academy"),
            const SizedBox(height: 8),
            const Text("School Code: FLA-1234"),
            const SizedBox(height: 8),
            const Text("Location: Accra, Ghana"),
            const SizedBox(height: 16),
            const Text("Teachers: 25"),
            const Text("Lesson Notes Submitted: 120"),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                // TODO: Firestore generate invite code
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Invite Code Generated")),
                );
              },
              child: const Text("Add Teacher (Generate Code)"),
            ),
          ],
        ),
      ),
    );
  }
}
