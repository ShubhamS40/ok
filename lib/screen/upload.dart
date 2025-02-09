import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class UploadPaperPage extends StatefulWidget {
  const UploadPaperPage({super.key});

  @override
  State<UploadPaperPage> createState() => _UploadPaperPageState();
}

class _UploadPaperPageState extends State<UploadPaperPage> {
  String? selectedBranch;
  String? selectedSpecialization;
  String? selectedExamType;
  File? selectedFile;

  final TextEditingController semesterYearController = TextEditingController();
  final TextEditingController semesterNumberController =
      TextEditingController();
  final TextEditingController subjectNameController = TextEditingController();
  final TextEditingController paperTitleController = TextEditingController();
  final TextEditingController paperYearController = TextEditingController();

  bool get isFormValid {
    return selectedBranch != null &&
        selectedSpecialization != null &&
        selectedExamType != null &&
        semesterYearController.text.isNotEmpty &&
        semesterNumberController.text.isNotEmpty &&
        subjectNameController.text.isNotEmpty &&
        paperTitleController.text.isNotEmpty &&
        paperYearController.text.isNotEmpty &&
        selectedFile != null;
  }

  void showFilePickerDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext ctx) {
        return Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text("Take a Photo"),
              onTap: () {
                pickImage(ImageSource.camera);
                Navigator.pop(ctx);
              },
            ),
            ListTile(
              leading: const Icon(Icons.image),
              title: const Text("Choose from Gallery"),
              onTap: () {
                pickImage(ImageSource.gallery);
                Navigator.pop(ctx);
              },
            ),
            ListTile(
              leading: const Icon(Icons.upload_file),
              title: const Text("Choose a File"),
              onTap: () {
                pickFile();
                Navigator.pop(ctx);
              },
            ),
          ],
        );
      },
    );
  }

  void pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        selectedFile = File(pickedFile.path);
      });
    }
  }

  void pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'png', 'jpg', 'jpeg'],
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        selectedFile = File(result.files.single.path!);
      });
    }
  }

  Future<void> uploadPaper() async {
    if (!isFormValid) return;

    var request = http.MultipartRequest(
      "POST",
      Uri.parse("http://3.109.21.20:3000/api/create-paper"),
    );

    request.fields["branch"] = selectedBranch!;
    request.fields["specialization"] = selectedSpecialization!;
    request.fields["exam_type"] = selectedExamType!;
    request.fields["semester_year"] = semesterYearController.text;
    request.fields["semester_number"] = semesterNumberController.text;
    request.fields["subject_name"] = subjectNameController.text;
    request.fields["paper_title"] = paperTitleController.text;
    request.fields["paper_year"] = paperYearController.text;

    request.files
        .add(await http.MultipartFile.fromPath("file", selectedFile!.path));

    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("File uploaded successfully!"),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Failed to upload file. Please try again."),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: ${e.toString()}"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Upload Paper"),
        backgroundColor: const Color(0xFF003D99),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildDropdownField(
                  "Branch Name",
                  ["BCA", "B.Tech", "BBA", "BCom"],
                  (value) => setState(() => selectedBranch = value)),
              buildDropdownField(
                  "Specialization Name",
                  ["AI", "Cyber Security", "Core", "Data Science"],
                  (value) => setState(() => selectedSpecialization = value)),
              buildTextField("Semester Year", semesterYearController,
                  TextInputType.number),
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
              const SizedBox(height: 10),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () => showFilePickerDialog(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF003D99),
                      foregroundColor: Colors.white,
                    ),
                    child: const Text("Choose File"),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      selectedFile != null
                          ? selectedFile!.path.split('/').last
                          : "No file chosen",
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.black87),
                    ),
                  ),
                ],
              ),
              if (selectedFile != null &&
                  (selectedFile!.path.endsWith(".png") ||
                      selectedFile!.path.endsWith(".jpg") ||
                      selectedFile!.path.endsWith(".jpeg")))
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Image.file(selectedFile!, height: 150),
                ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: isFormValid ? uploadPaper : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        isFormValid ? const Color(0xFFFFA500) : Colors.grey,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 12),
                    textStyle: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  child: const Text("Submit"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(
      String label, TextEditingController controller, TextInputType type) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: controller,
        keyboardType: type,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  Widget buildDropdownField(
      String label, List<String> items, ValueChanged<String?> onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
        items: items
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }
}
