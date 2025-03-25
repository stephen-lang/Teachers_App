import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdf_render/pdf_render.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter/services.dart';

import '../../../../../core/common/cubits/app_user/app_user_cubit_cubit.dart';
import '../../bloc/note_bloc.dart';

class UploadPage extends StatefulWidget {
  const UploadPage({super.key});
  static const String routeName = '/upload';

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  final Gemini gemini = Gemini.instance;
  bool _isLoading = false;
  final bool _uploadisLoading = false;
  String _statusMessage = "Upload a PDF to generate your lesson plan.";
  String _lessonPlan = "";
  final TextEditingController _promptController = TextEditingController();
  File? _selectedFile;

  Future<File?> pickPdfDocument() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      final sizeKb = result.files.first.size / 1024;
      const int maxSizeKb = 900;

      if (sizeKb > maxSizeKb) {
        _showSnackBar("File too large! Max size: $maxSizeKb KB", Colors.red,
            Colors.white, Icons.warning);
        return null;
      } else {
        _showSnackBar("File selected successfully!", Colors.green, Colors.white,
            Icons.check_circle);
        setState(() {
          _selectedFile = File(result.files.single.path!);
        });
        return _selectedFile;
      }
    }
    return null;
  }

  Future<List<Uint8List>> convertPDFtoImages(File pdfFile) async {
    final doc = await PdfDocument.openFile(pdfFile.path);
    List<Uint8List> images = [];

    for (int i = 1; i <= doc.pageCount; i++) {
      var page = await doc.getPage(i);
      var imgPDF = await page.render();
      var img = await imgPDF.createImageDetached();
      var imgBytes = await img.toByteData(format: ImageByteFormat.png);
      images.add(imgBytes!.buffer.asUint8List());
    }
    return images;
  }

 Future<void> sendImagesToGemini(List<Uint8List> images) async {
  if (_promptController.text.isEmpty) {
    _showSnackBar("Please enter a prompt before generating the lesson plan.",
        Colors.red, Colors.white, Icons.error);
    return;
  }

  setState(() {
    _isLoading = true;
    _statusMessage = "Processing your document...";
  });

  try {
    var response = await gemini.textAndImage(
      text: _promptController.text,
      images: images,
    );

    if (response != null) {
      var responseText = response.content?.parts
          ?.whereType<TextPart>() // ✅ Extract only TextPart
          .map((part) => part.text) // ✅ Get text safely
          .join(" ") // ✅ Combine text parts
          .replaceAll('*', '') ?? "No response received.";

      setState(() {
        _lessonPlan = responseText;
        _statusMessage = "Lesson Plan Generated! ✅";
      });
    } else {
      _showSnackBar("Failed to generate lesson plan.", Colors.red,
          Colors.white, Icons.error_outline);
    }
  } catch (e) {
    _showSnackBar("Error: $e", Colors.red, Colors.black, Icons.error_outline);
  }

  setState(() {
    _isLoading = false;
  });
}

  @override
  void initState() {
    super.initState();
    final posterId = (context.read<AppUserCubit>().state as AppUserLoggedIn)
        .loggedInUserCred
        .uid;
    context.read<NoteBloc>().add(NotesFetchPDFNotes(posterId: posterId));
  }

  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: _lessonPlan));
    _showSnackBar("Lesson Plan copied to clipboard! ✅", Colors.green,
        Colors.white, Icons.copy);
  }

  void _showFileNameDialog() {
    TextEditingController fileNameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Enter PDF Name"),
          content: TextField(
            controller: fileNameController,
            decoration: const InputDecoration(
              hintText: "Enter file name",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // Close dialog
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                String fileName = fileNameController.text.trim();
                final DateTime generatedAt = DateTime.now();
                final posterId =
                    (context.read<AppUserCubit>().state as AppUserLoggedIn)
                        .loggedInUserCred
                        .uid;
                String Pdfid = '';
                String lessonplanUpload = _lessonPlan;
                if (fileName.isNotEmpty) {
                  _saveLessonPlan(
                    Pdfid,
                    posterId,
                    fileName,
                    lessonplanUpload,
                    generatedAt,
                  );
                  Navigator.pop(context); // Close dialog
                }
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _saveLessonPlan(
    String Pdfid,
    String posterId,
    String fileName,
    String lessonplanUpload,
    DateTime generatedAt,
  ) async {
    context.read<NoteBloc>().add(NotesUploadPDFNotes(
        Pdfid: Pdfid,
        posterId: posterId,
        fileName: fileName,
        lessonplanUpload: lessonplanUpload,
        generatedAt: generatedAt));
  }

  void _showSnackBar(
      String message, Color backgroundColor, Color textColor, IconData icon) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: textColor), // Add icon
            const SizedBox(width: 10),
            Expanded(child: Text(message, style: TextStyle(color: textColor))),
          ],
        ),
        backgroundColor: backgroundColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Upload PDF"),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _promptController,
                decoration: const InputDecoration(
                  labelText: "Enter your prompt",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.edit, color: Colors.deepPurple),
                ),
              ),
              const SizedBox(height: 10),
              if (_selectedFile != null)
                Text(
                  "Selected File: ${_selectedFile!.path.split('/').last}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple),
                ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: _isLoading ? null : pickPdfDocument,
                icon: const Icon(Icons.upload_file),
                label: const Text("Select PDF"),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(15),
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: _isLoading || _selectedFile == null
                    ? null
                    : () async {
                        final images = await convertPDFtoImages(_selectedFile!);
                        await sendImagesToGemini(images);
                      },
                icon: const Icon(Icons.play_arrow),
                label: const Text("Generate Lesson Plan"),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(15),
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 20),
              if (_isLoading) const Center(child: CircularProgressIndicator()),
              if (_lessonPlan.isNotEmpty) ...[
                const SizedBox(height: 20),
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Generated Lesson Plan:",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.all(10),
                          height: 200,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.deepPurple),
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.grey[200],
                          ),
                          child: SingleChildScrollView(
                            child: Text(
                              _lessonPlan,
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ElevatedButton.icon(
                              onPressed: _copyToClipboard,
                              icon: const Icon(Icons.copy),
                              label: const Text("Copy"),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.all(12),
                                backgroundColor: Colors.orange,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                              ),
                            ),
                            const SizedBox(width: 130),
                            ElevatedButton.icon(
                              onPressed: _showFileNameDialog,
                              icon: const Icon(Icons.save),
                              label: const Text("Save"),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.all(12),
                                backgroundColor: Colors.blue,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 40),
              // code should go here
              /*
              Expanded(
                child: BlocBuilder<NoteBloc, NoteState>(
                  builder: (context, state) {
                    if (state is NoteLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (state is NoteError) {
                      return const Center(
                          child: Text("Error fetching lesson notes ❌"));
                    }
                    if (state is NoteLoaded) {
                      if (state.notes.isEmpty) {
                        return const Center(
                            child: Text("No lesson notes available 📂"));
                      }
                      List<Map<String, dynamic>> notes = state.notes;
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: notes.length,
                        itemBuilder: (context, index) {
                          return Card(
                            elevation: 4,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ExpansionTile(
                              title: Text(
                                notes[index]['fileName'],
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(notes[index]['lessonNote']),
                                ),
                                ButtonBar(
                                  alignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    TextButton.icon(
                                      onPressed: () => _copyToClipboard(
                                          notes[index]['lessonNote']),
                                      icon: const Icon(Icons.copy,
                                          color: Colors.orange),
                                      label: const Text("Copy Note"),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    }
                    return const SizedBox(); // Default case to avoid returning null
                  },
                ),
              ),

              */
            ],
          ),
        ),
      ),
    );
  }
}
