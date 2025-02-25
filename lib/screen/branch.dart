import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:srm_exam_x/screen/paper_list_screen.dart';

class Branch extends StatefulWidget {
  final String branchName;
  const Branch({super.key, required this.branchName});

  @override
  State<Branch> createState() => _BranchState();
}

class _BranchState extends State<Branch> {
  List<String> specializations = [];
  List<String> years = [];
  List<String> semesters = [];
  List<String> subjects = [];
  List<String> paperTypes = ["MAST_2", "End-term", "MAST_1"];

  String? selectedSpecialization;
  String? selectedYear;
  String? selectedSemester;
  String? selectedSubject;
  String? selectedPaperType;
  String? fileUrl;

  @override
  void initState() {
    super.initState();
    fetchSpecializations();
  }

  Future<void> fetchSpecializations() async {
    try {
      final response = await http.get(Uri.parse(
          "http://13.203.192.194:3000/${widget.branchName.toLowerCase()}/specializations"));
      if (response.statusCode == 200) {
        setState(() {
          specializations = List<String>.from(jsonDecode(response.body));
          selectedSpecialization = null; // Reset dependent fields
          years.clear();
          semesters.clear();
          subjects.clear();
          fileUrl = null;
        });
      } else {
        _showDialog("Error", "Failed to fetch specializations.");
      }
    } catch (error) {
      _showDialog("Error", "Could not connect to the server.");
    }
  }

  Future<void> fetchYears() async {
    if (selectedSpecialization == null) return;
    try {
      final response = await http.get(Uri.parse(
          "http://13.203.192.194:3000/${widget.branchName.toLowerCase()}/$selectedSpecialization/years"));
      if (response.statusCode == 200) {
        setState(() {
          years = List<String>.from(jsonDecode(response.body));
          selectedYear = null;
          semesters.clear();
          subjects.clear();
          fileUrl = null;
        });
      } else {
        _showDialog("Error", "Failed to fetch years.");
      }
    } catch (error) {
      _showDialog("Error", "Could not connect to the server.");
    }
  }

  Future<void> fetchSemesters() async {
    if (selectedYear == null) return;
    try {
      final response = await http.get(Uri.parse(
          "http://13.203.192.194:3000/${widget.branchName.toLowerCase()}/$selectedSpecialization/$selectedYear/semesters"));
      if (response.statusCode == 200) {
        setState(() {
          semesters = List<String>.from(jsonDecode(response.body));
          selectedSemester = null;
          subjects.clear();
          fileUrl = null;
        });
      } else {
        _showDialog("Error", "Failed to fetch semesters.");
      }
    } catch (error) {
      _showDialog("Error", "Could not connect to the server.");
    }
  }

  Future<void> fetchSubjects() async {
    if (selectedSemester == null) return;
    try {
      final response = await http.get(Uri.parse(
          "http://13.203.192.194:3000/${widget.branchName.toLowerCase()}/$selectedSpecialization/$selectedYear/$selectedSemester/subjects"));
      if (response.statusCode == 200) {
        setState(() {
          subjects = List<String>.from(jsonDecode(response.body));
          selectedSubject = null;
          fileUrl = null;
        });
      } else {
        _showDialog("Error", "Failed to fetch subjects.");
      }
    } catch (error) {
      _showDialog("Error", "Could not connect to the server.");
    }
  }

  Future<void> fetchFileUrl() async {
    if (selectedSubject == null || selectedPaperType == null) {
      _showDialog("Error", "Please select all options before proceeding.");
      return;
    }
    try {
      final response = await http.post(
        Uri.parse("http://13.203.192.194:3000/fetch-file"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "branch": widget.branchName.toLowerCase(),
          "specialization": selectedSpecialization,
          "year": selectedYear,
          "semester": selectedSemester,
          "subject": selectedSubject,
          "examType": selectedPaperType,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        // Ensure fileUrl is a valid list or single string
        List<Map<String, String>> papers = [];
        if (responseData["fileUrl"] is List) {
          for (var url in responseData["fileUrl"]) {
            papers.add({
              "title": selectedSubject!,
              "year": selectedYear!,
              "examType": selectedPaperType!,
              "fileUrl": url,
            });
          }
        } else if (responseData["fileUrl"] is String) {
          papers.add({
            "title": selectedSubject!,
            "year": selectedYear!,
            "examType": selectedPaperType!,
            "fileUrl": responseData["fileUrl"],
          });
        } else {
          _showDialog("Error", "Invalid response from server.");
          return;
        }

        if (papers.isEmpty) {
          _showDialog("Error", "No papers found.");
          return;
        }

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PaperListScreen(papers: papers),
          ),
        );
      } else {
        _showDialog("Process",
            "Switch the Paper Type Choose Diffrent Paper Type Because this Subject is not Belongs to This Paper Type.");
      }
    } catch (error) {
      _showDialog("Error", "Could not connect to the server.");
    }
  }

  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: Text(title,
              style: const TextStyle(
                  color: Colors.blue, fontWeight: FontWeight.bold)),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK", style: TextStyle(color: Colors.blue)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("SRM UNIVERSITY",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Color(0xFF003D99),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildDropdown("Select Specialization", specializations,
                selectedSpecialization, (value) {
              setState(() {
                selectedSpecialization = value;
                fetchYears();
              });
            }),
            SizedBox(
              height: 20,
            ),
            buildDropdown("Select Year", years, selectedYear, (value) {
              setState(() {
                selectedYear = value;
                fetchSemesters();
              });
            }),
            SizedBox(
              height: 20,
            ),
            buildDropdown("Select Semester", semesters, selectedSemester,
                (value) {
              setState(() {
                selectedSemester = value;
                fetchSubjects();
              });
            }),
            SizedBox(
              height: 20,
            ),
            buildDropdown("Select Subject", subjects, selectedSubject, (value) {
              setState(() {
                selectedSubject = value;
              });
            }),
            SizedBox(
              height: 20,
            ),
            buildDropdown("Select Paper Type", paperTypes, selectedPaperType,
                (value) {
              setState(() {
                selectedPaperType = value;
              });
            }),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: fetchFileUrl,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF003D99),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 5,
                ),
                child: const Text("Fetch File",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
              ),
            ),
            if (fileUrl != null)
              Center(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Text("File Found:"),
                    TextButton(
                      onPressed: () {
                        // Open the file in browser
                        (Uri.parse(fileUrl!));
                      },
                      child: Text(fileUrl!,
                          style: const TextStyle(
                              color: Colors.blue,
                              decoration: TextDecoration.underline)),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

Widget buildDropdown(String hint, List<String> items, String? value,
    Function(String?) onChanged) {
  return DropdownButtonFormField<String>(
    isExpanded: true,
    value: value,
    items: items
        .map((item) => DropdownMenuItem(value: item, child: Text(item)))
        .toList(),
    onChanged: onChanged,
    decoration: InputDecoration(
        labelText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
  );
}
