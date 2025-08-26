import 'package:flutter/material.dart';

class TeacherProfileScreen extends StatelessWidget {
  final Map<String, String> teacher;
  const TeacherProfileScreen({super.key, required this.teacher});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(teacher["name"]!)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Email: ${teacher["email"]}"),
            const SizedBox(height: 16),
            const Text("Subjects: Mathematics, Science"),
            const SizedBox(height: 16),
            const Text("Lesson Notes Submitted: 12"),
            const SizedBox(height: 16),
            const Text("Last Active: 2 days ago"),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                // TODO: Firestore logic for deactivate
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Teacher deactivated")),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text("Deactivate Teacher"),
            ),
          ],
        ),
      ),
    );
  }
}
