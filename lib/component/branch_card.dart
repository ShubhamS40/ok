import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import 'package:srm_exam_x/component/navbar.dart';
import 'package:srm_exam_x/component/notification_bell.dart';
import 'package:srm_exam_x/screen/branch.dart';
import 'package:carousel_slider/carousel_slider.dart';

class BranchCard extends StatelessWidget {
  final String label;
  final IconData icon;

  const BranchCard({required this.label, required this.icon, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Branch(branchName: label)),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [Color(0xFF003D99), Color(0xFF007FFF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8,
              offset: Offset(2, 4),
            ),
          ],
        ),
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.2),
              ),
              child: Icon(icon, size: 40, color: Colors.white),
            ),
            SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
