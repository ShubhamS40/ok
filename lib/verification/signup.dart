import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:srmone/verification/login.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  bool isLoading = false;

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    final response = await http.post(
      Uri.parse("http://3.109.21.20:3000/api/signup"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "name": _nameController.text.trim(),
        "email": _emailController.text.trim(),
        "password": _passwordController.text.trim(),
      }),
    );

    setState(() => isLoading = false);

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Signup Successful! Please login.")),
      );
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
    } else {
      final error = jsonDecode(response.body)['message'] ?? "Signup failed!";
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error)),
      );
    }
  }

  void _signInWithGoogle() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Google Sign-Up Coming Soon!")),
    );
  }

  void _signInWithGitHub() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("GitHub Sign-Up Coming Soon!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFFF8F8F8),
        body: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/ok.png",
                    height: 200,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(Icons.image_not_supported, size: 80);
                    },
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Sign Up",
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0E17D2)),
                  ),
                  SizedBox(height: 10),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            labelText: "Full Name",
                            prefixIcon:
                                Icon(Icons.person, color: Color(0xFF0E17D2)),
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) =>
                              value!.isEmpty ? "Enter your name" : null,
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: "Email",
                            prefixIcon:
                                Icon(Icons.email, color: Color(0xFF0E17D2)),
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) => !value!.contains("@")
                              ? "Enter a valid email"
                              : null,
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            labelText: "Password",
                            prefixIcon:
                                Icon(Icons.lock, color: Color(0xFF0E17D2)),
                            border: OutlineInputBorder(),
                          ),
                          obscureText: true,
                          validator: (value) => value!.length < 6
                              ? "Password must be 6+ chars"
                              : null,
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          controller: _confirmPasswordController,
                          decoration: InputDecoration(
                            labelText: "Confirm Password",
                            prefixIcon:
                                Icon(Icons.lock, color: Color(0xFF0E17D2)),
                            border: OutlineInputBorder(),
                          ),
                          obscureText: true,
                          validator: (value) =>
                              value != _passwordController.text
                                  ? "Passwords don't match"
                                  : null,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 15),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF0E17D2),
                        padding: EdgeInsets.symmetric(vertical: 12.0),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0)),
                      ),
                      onPressed: isLoading ? null : _signUp,
                      child: isLoading
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text("Sign Up",
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white)),
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: _signInWithGoogle,
                        child: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          radius: 18,
                          child: FaIcon(FontAwesomeIcons.google,
                              color: Colors.red, size: 24),
                        ),
                      ),
                      SizedBox(width: 20),
                      GestureDetector(
                        onTap: _signInWithGitHub,
                        child: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          radius: 18,
                          child: FaIcon(FontAwesomeIcons.github,
                              color: Colors.black, size: 24),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  TextButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => LoginPage()));
                    },
                    child: Text("Already have an account? Login",
                        style: TextStyle(color: Color(0xFF0E17D2))),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
