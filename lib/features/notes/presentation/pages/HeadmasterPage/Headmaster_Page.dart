import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../../auth/presentation/pages/WelcomeScreen.dart';
//import 'package:teacherapp_cleanarchitect/features/auth/presentation/widgets/teacher_activity_tile.dart';

class HeadmasterDashboard extends StatelessWidget {
  const HeadmasterDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Headmaster Dashboard"),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              context.read<AuthBloc>().add(AuthSignOut());
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const WelcomeScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Teacher Activity Summary",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
           /* TeacherActivityTile(
              teacherName: "John Doe",
              lastLogin: "April 28, 2025",
              lastLessonCreated: "Science - Cells",
            ),

            TeacherActivityTile(
              teacherName: "Mary Smith",
              lastLogin: "April 27, 2025",
              lastLessonCreated: "Math - Algebra",
            ),
            */
            const SizedBox(height: 20),
            const Text(
              "Lesson Statistics",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildStatisticCard("Total Lessons", "58"),
            _buildStatisticCard("Most Active Subject", "English"),
            _buildStatisticCard("Inactive Teachers", "3"),
            const SizedBox(height: 20),
            const Text(
              "Teacher Search",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(
                hintText: "Search by name or subject",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.picture_as_pdf),
              onPressed: () {
                // TODO: Add export functionality
              },
              label: const Text("Export Report"),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildStatisticCard(String title, String value) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 2,
      child: ListTile(
        leading: const Icon(Icons.bar_chart, color: Colors.blue),
        title: Text(title),
        trailing: Text(
          value,
          style: const TextStyle(
              fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87),
        ),
      ),
    );
  }
} // HeadmasterDashboard
