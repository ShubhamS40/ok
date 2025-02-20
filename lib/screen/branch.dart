import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'paper_list_screen.dart';

class Branch extends StatefulWidget {
  final String branchName;
  const Branch({super.key, required this.branchName});

  @override
  State<Branch> createState() => _BranchState();
}

class _BranchState extends State<Branch> {
  final List<String> specializations = ['Core', 'DevOps', 'AI ML', 'Cloud'];
  final List<String> paperTypes = ['Theory', 'Practical', 'End-term'];

  List<int> years = [];
  List<int> semesters = [];
  List<String> subjects = [];

  String selectedSpecialization = "Core";
  String selectedPaperType = "End-term";
  int? selectedYear;
  int? selectedSemester;
  String? selectedSubject;

  @override
  void initState() {
    super.initState();
    fetchYears();
    fetchSemesters();
    fetchSubjects();
  }

  /// Fetch Years
  Future<void> fetchYears() async {
    try {
      final response =
          await http.get(Uri.parse("http://13.232.59.110:3000/get-year"));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is Map && data.containsKey("year") && data["year"] is List) {
          setState(() {
            years = List<int>.from((data["year"] as List)
                .map((e) => int.parse(e.toString()))
                .toSet());
            selectedYear = years.isNotEmpty ? years.first : null;
          });
        }
      }
    } catch (error) {
      _showDialog("Error", "Failed to fetch years.");
    }
  }

  /// Fetch Semesters
  Future<void> fetchSemesters() async {
    try {
      final response =
          await http.get(Uri.parse("http://13.232.59.110:3000/get-semester"));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is Map &&
            data.containsKey("number") &&
            data["number"] is List) {
          setState(() {
            semesters = List<int>.from((data["number"] as List)
                .map((e) => int.parse(e.toString()))
                .toSet());
            selectedSemester = semesters.isNotEmpty ? semesters.first : null;
          });
        }
      }
    } catch (error) {
      _showDialog("Error", "Failed to fetch semesters.");
    }
  }

  /// Fetch Subjects
  Future<void> fetchSubjects() async {
    try {
      final response =
          await http.get(Uri.parse("http://13.232.59.110:3000/get-subject"));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is List) {
          setState(() {
            subjects = List<String>.from(data
                .map((e) => (e as Map<String, dynamic>)["name"].toString())
                .toSet());
            selectedSubject = subjects.isNotEmpty ? subjects.first : null;
          });
        }
      }
    } catch (error) {
      _showDialog("Error", "Failed to fetch subjects.");
    }
  }

  /// Fetch Papers
  Future<void> fetchPaper() async {
    if (selectedYear == null ||
        selectedSemester == null ||
        selectedSubject == null) {
      _showDialog("Error", "Please select all options before proceeding.");
      return;
    }

    final url = Uri.parse("http://13.232.59.110:3000/api/paper");
    final requestBody = {
      "branchName": widget.branchName,
      "specializationName": selectedSpecialization,
      "semesterYear": selectedYear,
      "semesterNumber": selectedSemester,
      "subjectName": selectedSubject,
      "examType": selectedPaperType,
    };

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        List<dynamic> papers = responseData["papers"] ?? [];

        if (papers.isEmpty) {
          _showDialog("No Papers Found", "No matching papers were found.");
          return;
        }

        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PaperListScreen(papers: papers)),
        );
      } else {
        _showDialog("Error", "Failed to fetch papers.");
      }
    } catch (error) {
      _showDialog("Error", "Could not connect to the server.");
    }
  }

  /// Show Alert Dialog
  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: Text(title,
              style: const TextStyle(
                  color: Color(0xFF0E17D2), fontWeight: FontWeight.bold)),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child:
                  const Text("OK", style: TextStyle(color: Color(0xFF0E17D2))),
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
        backgroundColor: const Color(0xFF0E17D2),
        elevation: 5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildDropdown("Select Specialization", specializations,
                  selectedSpecialization, (value) {
                setState(() =>
                    selectedSpecialization = value ?? specializations.first);
              }),
              const SizedBox(height: 15),
              buildDropdown(
                  "Select Year",
                  years.map((e) => e.toString()).toList(),
                  selectedYear?.toString(), (value) {
                setState(() => selectedYear = int.tryParse(value!));
              }),
              const SizedBox(height: 15),
              buildDropdown(
                  "Select Semester",
                  semesters.map((e) => e.toString()).toList(),
                  selectedSemester?.toString(), (value) {
                setState(() => selectedSemester = int.tryParse(value!));
              }),
              const SizedBox(height: 15),
              buildDropdown("Select Subject", subjects, selectedSubject,
                  (value) {
                setState(() => selectedSubject = value);
              }),
              const SizedBox(height: 15),
              buildDropdown("Select Paper Type", paperTypes, selectedPaperType,
                  (value) {
                setState(() => selectedPaperType = value ?? paperTypes.first);
              }),
              const SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: fetchPaper,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 5,
                  ),
                  child: const Text("Next",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Fixed Dropdown with Overflow Handling
Widget buildDropdown(String hint, List<String> items, String? value,
    Function(String?) onChanged) {
  return DropdownButtonFormField<String>(
    isExpanded: true,
    value: items.contains(value) ? value : null,
    items: items
        .map((item) => DropdownMenuItem(
            value: item,
            child: Text(item, overflow: TextOverflow.ellipsis, maxLines: 1)))
        .toList(),
    onChanged: onChanged,
    decoration: InputDecoration(
        labelText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        filled: true,
        fillColor: Colors.grey[200]),
  );
}
