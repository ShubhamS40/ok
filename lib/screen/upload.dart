import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class UploadPaperPage extends StatefulWidget {
  const UploadPaperPage({super.key});

  @override
  State<UploadPaperPage> createState() => _UploadPaperPageState();
}

class _UploadPaperPageState extends State<UploadPaperPage> {
  String? selectedBranch;
  String? selectedSpecialization;
  String? selectedExamType;
  Uint8List? fileBytes;
  String? selectedFileName;
  String successMessage = "";
  String errorMessage = "";

  final TextEditingController semesterYearController = TextEditingController();
  final TextEditingController semesterNumberController =
      TextEditingController();
  final TextEditingController subjectNameController = TextEditingController();
  final TextEditingController paperTitleController = TextEditingController();
  final TextEditingController paperYearController = TextEditingController();

  void pickImage() async {
    final ImagePicker picker = ImagePicker();
    XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      fileBytes = await image.readAsBytes();
      selectedFileName = image.name;
      setState(() {});
    }
  }

  Future<void> uploadPaper() async {
    if (selectedBranch == null ||
        selectedSpecialization == null ||
        selectedExamType == null ||
        semesterYearController.text.isEmpty ||
        semesterNumberController.text.isEmpty ||
        subjectNameController.text.isEmpty ||
        paperTitleController.text.isEmpty ||
        paperYearController.text.isEmpty ||
        fileBytes == null) {
      setState(() {
        errorMessage = "Please fill all fields and select an image.";
        successMessage = "";
      });
      return;
    }

    try {
      var request = http.MultipartRequest(
        "POST",
        Uri.parse("http://13.232.59.110:3000/api/create-paper"),
      );
      request.fields["branchName"] = selectedBranch!;
      request.fields["specializationName"] = selectedSpecialization!;
      request.fields["examType"] = selectedExamType!;
      request.fields["semesterYear"] = semesterYearController.text;
      request.fields["semesterNumber"] = semesterNumberController.text;
      request.fields["subjectName"] = subjectNameController.text;
      request.fields["paperTitle"] = paperTitleController.text;
      request.fields["paperYear"] = paperYearController.text;
      request.files.add(http.MultipartFile.fromBytes(
        "file",
        fileBytes!,
        filename: selectedFileName!,
      ));
      var response = await request.send();

      if (response.statusCode == 200) {
        setState(() {
          successMessage = "Paper uploaded successfully!";
          errorMessage = "";
          clearFields();
        });
      } else {
        setState(() {
          errorMessage = "Failed to upload paper.";
          successMessage = "";
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = "Error: ${e.toString()}";
        successMessage = "";
      });
    }
  }

  void clearFields() {
    setState(() {
      selectedBranch = null;
      selectedSpecialization = null;
      selectedExamType = null;
      fileBytes = null;
      selectedFileName = null;
      semesterYearController.clear();
      semesterNumberController.clear();
      subjectNameController.clear();
      paperTitleController.clear();
      paperYearController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Upload Paper"),
        backgroundColor: const Color(0xFF003D99),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset("assets/srm_logo.png", height: 80),
            const SizedBox(height: 20),
            buildDropdownField("Branch Name", ["BCA", "B.Tech", "BBA", "BCom"],
                (value) => setState(() => selectedBranch = value)),
            buildDropdownField(
                "Specialization Name",
                ["AI", "Cyber Security", "Core", "Data Science"],
                (value) => setState(() => selectedSpecialization = value)),
            buildTextField(
                "Semester Year", semesterYearController, TextInputType.number),
            buildTextField("Semester Number", semesterNumberController,
                TextInputType.number),
            buildTextField(
                "Subject Name", subjectNameController, TextInputType.text),
            buildDropdownField("Exam Type", ["End-term", "Mst-1", "Mst-2"],
                (value) => setState(() => selectedExamType = value)),
            buildTextField(
                "Paper Title", paperTitleController, TextInputType.text),
            buildTextField(
                "Paper Year", paperYearController, TextInputType.number),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: pickImage,
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  minimumSize: const Size(200, 50)),
              child: const Text("Choose Image", style: TextStyle(fontSize: 16)),
            ),
            if (fileBytes != null)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Image.memory(fileBytes!, height: 150),
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: uploadPaper,
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  minimumSize: const Size(200, 50)),
              child: const Text("Submit", style: TextStyle(fontSize: 18)),
            ),
            if (successMessage.isNotEmpty)
              Text(successMessage, style: const TextStyle(color: Colors.green)),
            if (errorMessage.isNotEmpty)
              Text(errorMessage, style: const TextStyle(color: Colors.red)),
          ],
        ),
      ),
    );
  }

  Widget buildDropdownField(
      String label, List<String> options, Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: DropdownButtonFormField<String>(
        decoration:
            InputDecoration(labelText: label, border: OutlineInputBorder()),
        items: options
            .map((item) => DropdownMenuItem(value: item, child: Text(item)))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller,
      TextInputType keyboardType) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration:
            InputDecoration(labelText: label, border: OutlineInputBorder()),
      ),
    );
  }
}
