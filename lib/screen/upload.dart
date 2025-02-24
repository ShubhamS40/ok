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
  final List<String> branches = ["btech", "law", "bca", "bcom"];
  final List<String> years = ["YEAR_2023", "YEAR_2024", "YEAR_2025"];
  final List<String> semesters = [
    "SEM_1",
    "SEM_2",
    "SEM_3",
    "SEM_4",
    "SEM_5",
    "SEM_6"
  ];
  final List<String> examTypes = ["END_TERM", "MAST_1", "MAST_2"];
  final Map<String, List<String>> specializationOptions = {
    "btech": ["CORE", "AIML", "DEVOPS"],
    "law": ["BA_LLB", "BBA_LLB", "LLB"],
    "bca": ["CORE"],
    "bcom": ["HONS", "CORE"],
  };

  String? selectedBranch;
  String? selectedSpecialization;
  String? selectedYear;
  String? selectedSemester;
  String? selectedSubject;
  String? selectedExamType;
  Uint8List? fileBytes;
  String? selectedFileName;
  String successMessage = "";
  String errorMessage = "";

  void pickFile() async {
    final ImagePicker picker = ImagePicker();
    XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      fileBytes = await image.readAsBytes();
      selectedFileName = image.name;
      setState(() {});
    }
  }

  Future<void> uploadPaper() async {
    if ([
          selectedBranch,
          selectedSpecialization,
          selectedYear,
          selectedSemester,
          selectedSubject,
          selectedExamType,
        ].contains(null) ||
        fileBytes == null) {
      setState(() {
        errorMessage = "Please fill all fields and select a file.";
        successMessage = "";
      });
      return;
    }

    try {
      var request = http.MultipartRequest(
        "POST",
        Uri.parse("http://13.203.192.194:3000/api/upload-paper"),
      );
      request.fields["branch"] = selectedBranch!;
      request.fields["specialization"] = selectedSpecialization!;
      request.fields["year"] = selectedYear!;
      request.fields["semester"] = selectedSemester!;
      request.fields["subject"] = selectedSubject!;
      request.fields["examType"] = selectedExamType!;
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
      selectedYear = null;
      selectedSemester = null;
      selectedSubject = null;
      selectedExamType = null;
      fileBytes = null;
      selectedFileName = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Upload Paper"),
        backgroundColor: Color(0xFF003D99),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            buildDropdown("Select Branch", branches, selectedBranch, (val) {
              setState(() {
                selectedBranch = val;
                selectedSpecialization = null;
              });
            }),
            SizedBox(
              height: 8,
            ),
            if (selectedBranch != null)
              buildDropdown(
                  "Select Specialization",
                  specializationOptions[selectedBranch] ?? [],
                  selectedSpecialization, (val) {
                setState(() => selectedSpecialization = val);
              }),
            SizedBox(
              height: 20,
            ),
            buildDropdown("Select Year", years, selectedYear,
                (val) => setState(() => selectedYear = val)),
            SizedBox(
              height: 20,
            ),
            buildDropdown("Select Semester", semesters, selectedSemester,
                (val) => setState(() => selectedSemester = val)),
            SizedBox(
              height: 20,
            ),
            buildTextField("Enter Subject", (val) => selectedSubject = val),
            SizedBox(
              height: 20,
            ),
            buildDropdown("Select Exam Type", examTypes, selectedExamType,
                (val) => setState(() => selectedExamType = val)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: pickFile,
              child: const Text("Choose File"),
            ),
            if (selectedFileName != null)
              Text("Selected File: $selectedFileName"),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: uploadPaper,
              child: const Text("Upload Paper"),
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

  Widget buildDropdown(String label, List<String> items, String? value,
      Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      decoration:
          InputDecoration(labelText: label, border: OutlineInputBorder()),
      value: value,
      items: items
          .map((item) => DropdownMenuItem(value: item, child: Text(item)))
          .toList(),
      onChanged: onChanged,
    );
  }

  Widget buildTextField(String label, Function(String) onChanged) {
    return TextField(
      decoration:
          InputDecoration(labelText: label, border: OutlineInputBorder()),
      onChanged: onChanged,
    );
  }
}
