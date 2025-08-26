import 'package:flutter/material.dart';

class LessonNotesScreen extends StatelessWidget {
  const LessonNotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notes = [
      {"title": "Math Lesson - Fractions", "teacher": "Mr. Adams"},
      {"title": "Science Lesson - Photosynthesis", "teacher": "Ms. Grace"},
      {"title": "English Lesson - Grammar", "teacher": "Mr. John"},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Lesson Notes")),
      body: ListView.builder(
        itemCount: notes.length,
        itemBuilder: (context, index) {
          final note = notes[index];
          return ListTile(
            leading: const Icon(Icons.note),
            title: Text(note["title"]!),
            subtitle: Text("By: ${note["teacher"]}"),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LessonNoteDetailScreen(
                    title: note["title"]!,
                    teacher: note["teacher"]!,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class LessonNoteDetailScreen extends StatelessWidget {
  final String title;
  final String teacher;

  const LessonNoteDetailScreen({
    super.key,
    required this.title,
    required this.teacher,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Lesson Note Details")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Title: $title",
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text("Teacher: $teacher", style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            const Text(
              "Sample lesson content goes here. In the real app, this would display the full lesson note details fetched from Firestore.",
              style: TextStyle(fontSize: 16),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Lesson Approved ✅")),
                    );
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.check),
                  label: const Text("Approve"),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Lesson Rejected ❌")),
                    );
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.close),
                  label: const Text("Reject"),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}