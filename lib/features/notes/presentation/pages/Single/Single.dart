import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter/services.dart';
import 'package:teacherapp_cleanarchitect/features/notes/presentation/bloc/note_bloc.dart';

import '../../../../../core/common/cubits/app_user/app_user_cubit_cubit.dart';

class SinglePage extends StatefulWidget {
  const SinglePage({super.key});

  @override
  State<SinglePage> createState() => _SinglePageState();
}

class _SinglePageState extends State<SinglePage> {
  final Gemini gemini = Gemini.instance;
  String cleanedResponse = '';
  bool isLoading = false;
  bool isSaved = false; // State variable to track if the note is saved

  final TextEditingController grade = TextEditingController();
  final TextEditingController indicators = TextEditingController();
  final TextEditingController contentstandard = TextEditingController();
  final TextEditingController substrand = TextEditingController();
  final TextEditingController strand = TextEditingController();
 // final TextEditingController noteId = TextEditingController();
  final TextEditingController classSize = TextEditingController();
  final TextEditingController Subject = TextEditingController();
  // final TextEditingController updatedAt = TextEditingController();
  String posterId = "";
  void _sendRequest() async {
    setState(() {
      isLoading = true; // Start loading
    });
    int? input1;
    String input2 = indicators.text.trim();
    String input3 = contentstandard.text.trim();
    String input4 = substrand.text.trim();
    String input5 = strand.text.trim();
    int? input6;
    int? input7;
    String input8 = Subject.text.trim();

    // String input9 = updatedAt: DateTime.now();
    // lessonNote: ;
    try {
      input1 = int.tryParse(grade.text.trim());
     // input6 = int.tryParse(noteId.text.trim());
      input7 = int.tryParse(classSize.text.trim());

      if (  input7 == null || input1 == null) {
          setState(() {
          isLoading = false;
        });
        _showAlertDialog('Invalid Input',
            ' Class Size  and Grade must be valid integers.');
        return;
      }
    } catch (e) {
      _showAlertDialog('Error', 'An error occurred while parsing inputs.');
      return;
    }

    if ([input2, input3, input4, input5, input8]
        .any((element) => element.isEmpty)) {
            setState(() {
          isLoading = false;
        });
      _showAlertDialog(
          'Empty Fields', 'Please fill out all fields before submitting.');
      return;
    }

    try {
      final response = await gemini.text(
          """Generate a lesson note for $input1 students using the indicators $input2.
        - **Content Standard:** $input3
        - **Sub-Strand:** $input4
        - **Strand:** $input5
         - ** ClassSize: ** $input7
        - ** Subject: ** $input8
        - ** 
        The lesson note should be in the following format:
        -   ** Subject: **, **Strand**, **Sub-Strand**, **Content Standard**, **Indicators**, **Performance Indicator**, **Core Competencies**
        - **Learner Activities** (Phase 1: Starter (10 mins), Phase 2: Main Learning (40 mins), Phase 3: Reflection (10 mins))
        - Include relevant resources and concise explanations for each phase.
        - ** Date: ${DateTime.now()}**
        """);

      if (response != null) {
        setState(() {
        cleanedResponse = response.content?.parts
            ?.whereType<TextPart>() // ✅ Extract only text parts
            .map((part) => part.text) // ✅ Get text safely
            .join(" ") // ✅ Combine text parts into a single response
            .replaceAll('*', '') ?? "No response received.";
        isLoading = false;
      });
      } else {
        setState(() {
          isLoading = false;
        });
        _showAlertDialog('Error', 'No data received. Please try again.');
      }
    } catch (e) {
      setState(() {
          isLoading = false;
        });
      _showAlertDialog('Error',
          'Something went wrong. Please check your internet connection and try again.');
      print(e);
    }
  }

  void _showAlertDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('Lesson Note Generator',
            style: TextStyle(color: Colors.white, fontSize: 18)),
        centerTitle: true,
        backgroundColor: Colors.blue,
        elevation: 5,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                _buildInputForm(),
                const SizedBox(height: 20),
                _buildGenerateButton(),
                const SizedBox(height: 20),
                _buildResponseContainer(),
              ],
            ),
          ),
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInputForm() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSection('General Info', [
              _buildTextField(grade, 'Grade', Icons.grade),
              _buildTextField(Subject, 'Subject', Icons.subject),
            ]),
            _buildSection('Details', [
              _buildTextField(indicators, 'Indicators', Icons.analytics),
              _buildTextField(contentstandard, 'Content Standard', Icons.book),
              _buildTextField(substrand, 'Sub-Strand', Icons.category),
              _buildTextField(strand, 'Strand', Icons.linear_scale),
            ]),
            _buildSection('Identifiers', [
              //_buildTextField(noteId, 'Note ID', Icons.numbers),
              _buildTextField(classSize, 'Class Size', Icons.people),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return ExpansionTile(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      children: children,
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.deepPurple),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.deepPurple, width: 2),
            borderRadius: BorderRadius.circular(10),
          ),
          errorText: _validateInput(controller.text, label),
        ),
        onChanged: (value) {
          setState(() {}); // Rebuild to show updated error text
        },
      ),
    );
  }

  String? _validateInput(String value, String fieldName) {
    if (value.trim().isEmpty) {
      return '$fieldName cannot be empty';
    }
    if ((fieldName == 'Grade' ||
            fieldName == 'ClassSize'
            
          //  || fieldName == 'noteId'
          ) &&
        int.tryParse(value.trim()) == null) {
      return '$fieldName must be a valid number';
    }
    return null;
  }

  Widget _buildGenerateButton() {
    return ElevatedButton.icon(
      onPressed: isLoading ? null :_sendRequest,  // Disable button if loading
      icon: const Icon(
        Icons.auto_stories,
        color: Colors.white,
      ),
      label: const Text('Generate My Lesson', style: TextStyle(color: Colors.white)),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        textStyle: const TextStyle(fontSize: 16),
        backgroundColor: Colors.blue,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _showToast(String message, {Color backgroundColor = Colors.black}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Widget _buildResponseContainer() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        height: 250.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  cleanedResponse.isNotEmpty
                      ? cleanedResponse
                      : "Your generated lesson note will appear here.",
                  style: const TextStyle(fontSize: 14.0, color: Colors.black87),
                ),
              ),
            ),
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween, // Distributes buttons evenly
              children: [
                ElevatedButton.icon(
                  onPressed: isSaved
                      ? null // Disable button if already saved
                      : () {
                          // Get posterId from the app user
                          final posterId = (context.read<AppUserCubit>().state
                                  as AppUserLoggedIn)
                              .loggedInUserCred
                              .uid;

                          // Prepare data to pass into the event
                          final gradevalue =
                              int.tryParse(grade.text.trim()) ?? 0;
                         // final noteIdValue =
                             // int.tryParse(noteId.text.trim()) ?? 0;
                          final classSizeValue =
                              int.tryParse(classSize.text.trim()) ?? 0;
                          final lessonNote = cleanedResponse;
                          final DateTime updatedAthere = DateTime.now();

                          // Ensure that lesson note content exists before saving
                          if (lessonNote.isEmpty) {
                            _showToast('No lesson note to save!',
                                backgroundColor: Colors.red);
                            return;
                          }

                          // Dispatch event to upload note
                          context.read<NoteBloc>().add(
                                NotesUploadNotes(
                                  posterId: posterId,
                                  noteId:  '',
                                  grade: gradevalue,
                                  indicators: indicators.text.trim(),
                                  contentStandard: contentstandard.text.trim(),
                                  substrand: substrand.text.trim(),
                                  strand: strand.text.trim(),
                                  classSize: classSizeValue,
                                  Subject: Subject.text.trim(),
                                  updatedAt: updatedAthere,
                                  lessonNote: lessonNote,
                                ),
                              );

                          // Show success message
                          _showToast('Note Saved Successfully!',
                              backgroundColor: Colors.green);
                          // Update saved state
                          setState(() {
                            isSaved = true;
                          });

                          // Clear fields
                          setState(() {
                            grade.clear();
                            indicators.clear();
                            contentstandard.clear();
                            substrand.clear();
                            strand.clear();
                           // noteId.clear();
                            classSize.clear();
                            Subject.clear();
                          });
                        },
                  icon: const Icon(Icons.save, color: Colors.white),
                  label:
                      const Text("Save", style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    // Copy lesson note to clipboard
                    Clipboard.setData(ClipboardData(text: cleanedResponse));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Text copied to clipboard!')),
                    );
                  },
                  icon: const Icon(Icons.copy, color: Colors.white),
                  label:
                      const Text("Copy", style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
