/* 📄 Allow Editing: Let users tweak the lesson plan before copying.
💾 Save Feature: Save the lesson plan for future reference.
🌍 Export Options: Allow users to download as PDF or Word.

🖼 Allow Image Uploads: Add image upload support alongside PDFs.
🌍 Multi-Language Support: Enable translations for different users.
💾 Save Results: Allow users to save lesson plans for later.
 Use Dark Mode Support for a more adaptive UI.
*/

import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
//import 'package:image/image.dart' as imglib;
//import 'package:path_provider/path_provider.dart';
import 'package:pdf_render/pdf_render.dart';
//import 'package:path/path.dart' as p;
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter/services.dart'; // For clipboard functionality

class UploadPage extends StatefulWidget {
  const UploadPage({super.key});
  static const String routeName = '/upload';

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  final Gemini gemini = Gemini.instance;
  bool _isLoading = false;
  String _statusMessage = "Upload a PDF to generate your lesson plan.";
  String _lessonPlan = ""; // Stores the generated lesson plan

  Future<File?> pickPdfDocument() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      final sizeKb = result.files.first.size / 1024;
      const int maxSizeKb = 900;

      if (sizeKb > maxSizeKb) {
        _showSnackBar("File too large! Max size: $maxSizeKb KB");
        return null;
      } else {
        _showSnackBar("File selected successfully!");
        return File(result.files.single.path!);
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
    setState(() {
      _isLoading = true;
      _statusMessage = "Processing your document...";
    });

    try {
      var response = await gemini.textAndImage(
        text: "Can you generate a lesson plan for health education B7, term 1 for 2 weeks using the attached document?",
        images: images,
      );

      if (response != null) {
        var responseText = response.content?.parts
                ?.fold("", (prev, curr) => "$prev ${curr.text}") ??
            "No response received.";
        
        setState(() {
          _lessonPlan = responseText; // Store the lesson plan
          _statusMessage = "Lesson Plan Generated! ✅";
        });
      } else {
        _showSnackBar("Failed to generate lesson plan.");
      }
    } catch (e) {
      _showSnackBar("Error: $e");
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: _lessonPlan));
    _showSnackBar("Lesson Plan copied to clipboard! ✅");
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Upload PDF"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              _statusMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _isLoading
                  ? null
                  : () async {
                      final pdfFile = await pickPdfDocument();
                      if (pdfFile != null) {
                        final images = await convertPDFtoImages(pdfFile);
                        await sendImagesToGemini(images);
                      }
                    },
              icon: const Icon(Icons.upload_file),
              label: const Text("Generate My Lesson"),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(15),
                backgroundColor: Colors.deepPurple,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 20),
            if (_isLoading)
              const Center(child: CircularProgressIndicator()),

            // Display the generated lesson plan
            if (_lessonPlan.isNotEmpty) ...[
              const SizedBox(height: 20),
              const Text(
                "Generated Lesson Plan:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
              ElevatedButton.icon(
                onPressed: _copyToClipboard,
                icon: const Icon(Icons.copy),
                label: const Text("Copy Lesson Plan"),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(12),
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
