import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter/services.dart';

class SinglePage extends StatefulWidget {
  const SinglePage({super.key});
 
  @override
  State<SinglePage> createState() => _SinglePageState();
}

class _SinglePageState extends State<SinglePage> {
  final Gemini gemini = Gemini.instance;
  String cleanedResponse = '';

  final TextEditingController grade = TextEditingController();
  final TextEditingController indicators = TextEditingController();
  final TextEditingController contentstandard = TextEditingController();
  final TextEditingController substrand = TextEditingController();
  final TextEditingController strand = TextEditingController();

  void _sendRequest() async {
    String input1 = grade.text.trim();
    String input2 = indicators.text.trim();
    String input3 = contentstandard.text.trim();
    String input4 = substrand.text.trim();
    String input5 = strand.text.trim();

    if ([input1, input2, input3, input4, input5].any((element) => element.isEmpty)) {
      _showAlertDialog('Empty Fields', 'Please fill out all fields before submitting.');
      return;
    }

    try {
      final response = await gemini.text(
        """Generate a lesson note for $input1 students using the indicators $input2.
        - **Content Standard:** $input3
        - **Sub-Strand:** $input4
        - **Strand:** $input5

        The lesson note should be in the following format:
        - **Strand**, **Sub-Strand**, **Content Standard**, **Indicators**, **Performance Indicator**, **Core Competencies**
        - **Learner Activities** (Phase 1: Starter (10 mins), Phase 2: Main Learning (40 mins), Phase 3: Reflection (10 mins))
        - Include relevant resources and concise explanations for each phase.
        """
      );

      if (response != null) {
        setState(() {
          cleanedResponse = response.content?.parts?.fold("", (prev, curr) => "$prev ${curr.text}")?.replaceAll('*', '') ?? "No response received.";
        });
      } else {
        _showAlertDialog('Error', 'No data received. Please try again.');
      }
    } catch (e) {
      _showAlertDialog('Error', 'Something went wrong. Please check your internet connection and try again.');
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
              child: Text('OK'),
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
      backgroundColor: Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Text('Lesson Note Generator', style: TextStyle(color:Colors.white,fontSize: 18)),
        centerTitle: true,
        backgroundColor: Colors.blue,
        elevation: 5,
      ),
      body: SingleChildScrollView(
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
            _buildTextField(grade, 'Grade', Icons.grade),
            _buildTextField(indicators, 'Indicators', Icons.analytics),
            _buildTextField(contentstandard, 'Content Standard', Icons.book),
            _buildTextField(substrand, 'Sub-Strand', Icons.category),
            _buildTextField(strand, 'Strand', Icons.linear_scale),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon) {
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
            borderSide: BorderSide(color: Colors.deepPurple, width: 2),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  Widget _buildGenerateButton() {
    return ElevatedButton.icon(
      onPressed: _sendRequest,
      icon: Icon(Icons.auto_stories, color: Colors.white,),
      label: Text('Generate My Lesson',style: TextStyle(color:Colors.white)),
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        textStyle: TextStyle(fontSize: 16),
        backgroundColor: Colors.blue,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                  cleanedResponse.isNotEmpty ? cleanedResponse : "Your generated lesson note will appear here.",
                  style: const TextStyle(fontSize: 14.0, color: Colors.black87),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton.icon(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: cleanedResponse));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Text copied to clipboard!')),
                  );
                },
                icon: Icon(Icons.copy,  color:Colors.white ),
                label: Text("Copy" , style: TextStyle(color:Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
