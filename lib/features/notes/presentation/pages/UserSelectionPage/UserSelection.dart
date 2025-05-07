/*import 'package:flutter/material.dart';
import 'headmaster_auth_page.dart'; // Import Headmaster Login/Signup Page
import 'teacher_auth_page.dart'; // Import Teacher Login/Signup Page

class UserSelectionPage extends StatelessWidget {
  const UserSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.purpleAccent], // Modern gradient
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Welcome to the Teacher App",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 40),
                _buildSelectionButton(
                  context,
                  "Headmaster",
                  Icons.school,
                  Colors.deepPurple,
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const HeadmasterAuthPage()),
                  ),
                ),
                const SizedBox(height: 20),
                _buildSelectionButton(
                  context,
                  "Teacher",
                  Icons.person,
                  Colors.blue,
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const TeacherAuthPage()),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSelectionButton(BuildContext context, String title,
      IconData icon, Color color, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 28),
        label: Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
*/