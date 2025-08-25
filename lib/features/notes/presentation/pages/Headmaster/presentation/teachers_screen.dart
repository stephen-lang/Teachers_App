import 'package:flutter/material.dart';
import 'teacher_profile_screen.dart';

class TeachersScreen extends StatelessWidget {
  const TeachersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final teachers = [
      {"name": "Mr. John Doe", "email": "johndoe@gmail.com"},
      {"name": "Ms. Jane Smith", "email": "janesmith@gmail.com"},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Teachers")),
      body: ListView.builder(
        itemCount: teachers.length,
        itemBuilder: (context, index) {
          final teacher = teachers[index];
          return Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              leading: const Icon(Icons.person, size: 40),
              title: Text(teacher["name"]!),
              subtitle: Text(teacher["email"]!),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TeacherProfileScreen(teacher: teacher),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
