import 'package:flutter/material.dart';
import 'package:srmone/component/navbar.dart';
import 'package:srmone/screen/branch.dart';
import 'package:srmone/screen/home.dart';
import 'package:srmone/splashscreen/splashscreen.dart';
import 'package:srmone/verification/signup.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(),
        home: SplashScreen());
  }
}
