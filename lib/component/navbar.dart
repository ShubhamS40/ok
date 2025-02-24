import 'package:flutter/material.dart';
import 'package:srm_exam_x/screen/home.dart';
import 'package:srm_exam_x/screen/profile%20.dart';

import 'package:srm_exam_x/screen/upload.dart';

class Navbar extends StatefulWidget {
  final String name;
  final String email;
  final String role;

  const Navbar(
      {super.key, required this.name, required this.email, required this.role});

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _animationController.forward(from: 0.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      const HomeScreen(),
      UploadPaperPage(),
      ProfileScreen(
        name: widget.name,
        email: widget.email,
        role: widget.role,
      ),
    ];

    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: pages[_selectedIndex],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 5,
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home,
                  color: _selectedIndex == 0 ? Colors.blueAccent : Colors.grey),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.upload,
                  color: _selectedIndex == 1 ? Colors.blueAccent : Colors.grey),
              label: 'Upload',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person,
                  color: _selectedIndex == 2 ? Colors.blueAccent : Colors.grey),
              label: 'Profile',
            ),
          ],
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          elevation: 5,
          backgroundColor: Colors.white.withOpacity(0.8),
          type: BottomNavigationBarType.fixed,
        ),
      ),
    );
  }
}
