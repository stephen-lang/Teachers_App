import 'package:flutter/material.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Reports")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text("Lesson Notes Status"),
            const SizedBox(height: 12),
            Container(
              height: 150,
              color: Colors.blue[50],
              child: const Center(child: Text("Pie Chart Placeholder")),
            ),
            const SizedBox(height: 24),
            const Text("Teacher Engagement"),
            const SizedBox(height: 12),
            Container(
              height: 150,
              color: Colors.green[50],
              child: const Center(child: Text("Bar Chart Placeholder")),
            ),
            const Spacer(),
            ElevatedButton.icon(
              onPressed: () {
                // TODO: PDF generation logic
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("PDF Report Exported")),
                );
              },
              icon: const Icon(Icons.picture_as_pdf),
              label: const Text("Export PDF"),
            ),
          ],
        ),
      ),
    );
  }
}
