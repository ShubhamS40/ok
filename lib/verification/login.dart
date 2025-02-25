import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:srm_exam_x/component/navbar.dart';
import 'package:srm_exam_x/screen/home.dart';
// Import ProfileScreen
import 'package:srm_exam_x/screen/profile%20.dart';
import 'package:srm_exam_x/verification/signup.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  void login() async {
    setState(() => isLoading = true);

    final url = Uri.parse("http://13.203.192.194:3000/api/login");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": emailController.text.trim(),
          "password": passwordController.text.trim(),
        }),
      );

      final responseData = jsonDecode(response.body);
      print(responseData);

      if (response.statusCode == 200) {
        // Extract user details
        String name = responseData['username'] ?? 'Unknown';
        String email = responseData['email'] ?? emailController.text.trim();
        String role = responseData['role'] ?? 'User';

        // Pass user data to ProfileScreen (just creating object, not navigating)
        ProfileScreen profileScreen =
            ProfileScreen(name: name, email: email, role: role);

        // Redirect to Navbar
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Navbar(
              name: name,
              email: email,
              role: role,
            ), // Pass profile data
          ),
        );
      } else {
        _showErrorDialog(
            responseData['message'] ?? "Invalid login credentials.");
      }
    } catch (error) {
      _showErrorDialog("An error occurred. Check your internet connection.");
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> loginwithgithub() async {
    print("Hello SHubham");
  }

  Future<void> loginWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn(
        clientId:
            "686267504344-19vbqgdt8benue5i4l7fp9npqir5et09.apps.googleusercontent.com",
      );

      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      User? user = userCredential.user;

      if (user != null) {
        String name = user.displayName ?? "Google User";
        String email = user.email ?? "No Email Provided";
        String role =
            "Google User"; // You can modify this based on your app logic

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ProfileScreen(name: name, email: email, role: role),
          ),
        );
      }
    } catch (error) {
      print(error);
      _showErrorDialog("Google Sign-In failed: ${error.toString()}");
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Login Failed"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 248, 248, 248),
        body: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    SizedBox(height: screenHeight * 0.05),

                    // SRM Logo
                    SizedBox(
                      height: screenHeight * 0.3,
                      child: Image.asset(
                        "assets/ok.png",
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.image_not_supported,
                              size: 80);
                        },
                      ),
                    ),
                    const SizedBox(height: 10),

                    const Text(
                      "Welcome Back!",
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0E17D2)),
                    ),
                    const SizedBox(height: 8),

                    const Text(
                      "Login to continue to Previous Year Question Paper App",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black54),
                    ),
                    const SizedBox(height: 20),

                    // Input Fields
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        children: [
                          TextField(
                            controller: emailController,
                            decoration: InputDecoration(
                              labelText: "Email",
                              prefixIcon: const Icon(Icons.email,
                                  color: Color(0xFF0E17D2)),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                            keyboardType: TextInputType.emailAddress,
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: passwordController,
                            decoration: InputDecoration(
                              labelText: "Password",
                              prefixIcon: const Icon(Icons.lock,
                                  color: Color(0xFF0E17D2)),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                            obscureText: true,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Login Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0E17D2),
                          padding: const EdgeInsets.symmetric(vertical: 14.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white)
                            : const Text("Login",
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white)),
                      ),
                    ),
                    const SizedBox(height: 15),

                    // Social Login Buttons
                    // Social Login Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: loginWithGoogle,
                          icon: const FaIcon(FontAwesomeIcons.google,
                              color: Colors.red),
                          iconSize: 30,
                        ),
                        const SizedBox(width: 20), // Space between icons
                        IconButton(
                          onPressed:
                              loginwithgithub, // Define this function for GitHub login
                          icon: const FaIcon(FontAwesomeIcons.github,
                              color: Colors.black),
                          iconSize: 30,
                        ),
                      ],
                    ),

                    const SizedBox(height: 15),

                    // Signup Navigation
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don't have an account?"),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignUpPage()));
                          },
                          child: const Text("Sign Up",
                              style: TextStyle(color: Color(0xFF0E17D2))),
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.05),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
