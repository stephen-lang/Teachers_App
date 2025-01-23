import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:teacherapp_cleanarchitect/core/common/cubits/app_user/app_user_cubit_cubit.dart';
import 'package:teacherapp_cleanarchitect/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:teacherapp_cleanarchitect/features/auth/presentation/pages/WelcomeScreen.dart';
import 'package:teacherapp_cleanarchitect/features/notes/presentation/bloc/note_bloc.dart';
import 'package:teacherapp_cleanarchitect/features/notes/presentation/pages/home/dashboard_notes.dart';
import '../../controllers/auth_controller.dart';

class Dash extends StatefulWidget {
  final String userName;
  const Dash({super.key, required this.userName});

  @override
  State<Dash> createState() => _DashState();
}

class _DashState extends State<Dash> {
  bool isHovered = false;
  final Map<String, Color> _subjectColors = {};
  final Random _random = Random();

  Color _getColorForSubject(String subject) {
    if (subject.trim().isEmpty) subject = "Default";
    return _subjectColors.putIfAbsent(
      subject,
      () =>
          Color.fromARGB(255, _random.nextInt(200), _random.nextInt(200), 255),
    );
  }

  @override
  void initState() {
    super.initState();
    final posterId = (context.read<AppUserCubit>().state as AppUserLoggedIn)
        .loggedInUserCred
        .uid;
    context.read<NoteBloc>().add(NotesFetchAllNotes(posterId: posterId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
        backgroundColor: Colors.blue.shade700,
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() {
              final userName = Get.find<AuthController>().userName.value;
              return Text(
                "Hi, $userName!",
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              );
            }),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: "Search lessons...",
                  prefixIcon: Icon(Icons.search, color: Colors.blue),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(16),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: BlocBuilder<NoteBloc, NoteState>(
                builder: (context, state) {
                  if (state is NoteLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is NoteDisplaySuccess) {
                    if (state.notes.isEmpty) {
                      return const Center(child: Text("No lessons found."));
                    }
                    return ListView.builder(
                      // ✅ Add 'return' here!
                      itemCount: state.notes.length,
                      itemBuilder: (context, index) {
                        final note = state.notes[index];
                        final color = _getColorForSubject(note.Subject);
                        return NoteItem(
                          note: note,
                          color: color,
                          onEdit: _editLesson,
                          onDelete: _deleteLesson,
                          onShowPopup: _showLessonPopup,
                        );
                      },
                    );
                  } else {
                    return const Center(child: Text("An error occurred."));
                  }
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewLesson,
        backgroundColor: Colors.blue.shade700,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildNoteItem(note, Color color) {
    final hoveredTransform = Matrix4.identity()..scale(1.5);
    final transform = isHovered ? hoveredTransform : Matrix4.identity();
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: transform,
        child: GestureDetector(
          onTap: () => _showLessonPopup(context, note),
          child: Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            color: color.withOpacity(0.3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              side: BorderSide(color: Colors.blue.shade700, width: 1),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(12),
              title: const Text(
                "Lesson",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(note.indicators),
                  Text(
                    "Updated: ${DateFormat("d MMM, yyyy").format(note.updatedAt)}",
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
              trailing: PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == "Edit") {
                    _editLesson(note);
                  } else if (value == "Delete") {
                    _deleteLesson(note);
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(value: "Edit", child: Text("Edit")),
                  const PopupMenuItem(value: "Delete", child: Text("Delete")),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _editLesson(note) {
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController controller =
            TextEditingController(text: note.indicators);
        return AlertDialog(
          title: const Text("Edit Lesson"),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: "Edit lesson details"),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel")),
            ElevatedButton(
              onPressed: () {
                // Save changes to database
                Navigator.pop(context);
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  void _deleteLesson(note) {
    // Implement delete functionality
  }

  void _addNewLesson() {
    // Implement add new lesson functionality
  }

  void _showLessonPopup(BuildContext context, note) {
    final userName = Get.find<AuthController>().userName.value;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Lesson"),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Text("Grade: ${note.grade}"),
                Text("Subject: ${note.Subject}"),
                Text(
                    "Updated: ${DateFormat("d MMM, yyyy").format(note.updatedAt)}"),
                Text("AI Generated Lesson:",
                    style: Theme.of(context).textTheme.titleLarge),
                Text(note.lessonNote),
                const SizedBox(height: 10),
                Text("Created By:",
                    style: Theme.of(context).textTheme.titleMedium),
                Text(userName),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Close"),
            ),
               const SizedBox(width: 70),
            ElevatedButton.icon(
              onPressed: () {
                // Combine all information into a single string
                final fullContent = '''
                    Grade: ${note.grade}
                     Subject: ${note.Subject}
                     Updated: ${DateFormat("d MMM, yyyy").format(note.updatedAt)}

                       AI Generated Lesson:
                       ${note.lessonNote}

                       Created By:
                        ${userName}
                           ''';

                // Copy everything to clipboard
                Clipboard.setData(ClipboardData(text: fullContent));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Text copied to clipboard!')),
                );
              },
              icon: const Icon(Icons.copy, color: Colors.white),
              label: const Text("Copy", style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
