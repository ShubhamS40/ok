import 'dart:async';
import 'package:flutter/material.dart';
import 'package:srmone/screen/home.dart';
import 'package:srmone/verification/login.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String getGreeting() {
    int hour = DateTime.now().hour;
    if (hour < 12) {
      return "Good Morning! ☀️";
    } else if (hour < 17) {
      return "Good Afternoon! 🌤";
    } else {
      return "Good Evening! 🌙";
    }
  }

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0E17D2), // SRM Theme Blue
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // SRM Logo
            Image.network(
              "https://imgs.search.brave.com/7ht6JzSCc7AdtL8to5Qr6UkmftyTOqOcq5Uv5yBl-r0/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9sb2dv/ZGl4LmNvbS9sb2dv/LzE3ODcwNDAucG5n",
              height: 120,
            ),
            SizedBox(height: 20),
            // Animated Greeting Text
            TweenAnimationBuilder(
              tween: Tween<double>(begin: 0, end: 1),
              duration: Duration(seconds: 2),
              builder: (context, double opacity, child) {
                return Opacity(
                  opacity: opacity,
                  child: Text(
                    getGreeting(),
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 10),
            // App Name
            Text(
              "Previous Year Question Paper App",
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 10),
            // SRM University Title
            Text(
              "Welcome to SRM University",
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 50),
            // Loading Indicator
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
