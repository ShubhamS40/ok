import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:srm_exam_x/firebase_options.dart';
import 'package:srm_exam_x/screen/home.dart';
import 'package:srm_exam_x/screen/upload.dart';
import 'package:srm_exam_x/splashscreen/splashscreen.dart';
import 'package:srm_exam_x/verification/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SRM Exam X',
      theme: ThemeData(),
      home: SplashScreen(), // Ensure LoginPage is defined
    );
  }
}
