import 'package:flutter/material.dart';

class LatestPaperDrawer extends StatelessWidget {
  const LatestPaperDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Color(0xFF003D99),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        "Latest Uploaded Paper Notification",
                        style: TextStyle(
                          color: Color(0xFF003D99),
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Image.asset(
                        'assets/srm_logo.png',
                        height: 60,
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Divider(color: Color(0xFF003D99), thickness: 2),
                ],
              ),
            ),
            Container(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                              color: Colors.white,
                              width: 4,
                              strokeAlign: BorderSide.strokeAlignCenter)),
                      child: Column(
                        children: [
                          ListTile(
                            leading: Icon(Icons.book, color: Colors.white),
                            title: Text(
                              "Subject: Data Structures & Algorithms",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          ListTile(
                            leading:
                                Icon(Icons.calendar_today, color: Colors.white),
                            title: Text(
                              "Year: 2023",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          ListTile(
                            leading: Icon(Icons.school, color: Colors.white),
                            title: Text(
                              "Branch: B.Tech CSE",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                              color: Colors.white,
                              width: 4,
                              strokeAlign: BorderSide.strokeAlignCenter)),
                      child: Column(
                        children: [
                          ListTile(
                            leading: Icon(Icons.book, color: Colors.white),
                            title: Text(
                              "Subject: Artificial Intelligence & Machine Learning",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          ListTile(
                            leading:
                                Icon(Icons.calendar_today, color: Colors.white),
                            title: Text(
                              "Year: 2024",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          ListTile(
                            leading: Icon(Icons.school, color: Colors.white),
                            title: Text(
                              "Branch: B.Tech CSE",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Color(0xFF003D99),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () => Navigator.pop(context),
                child: Text("Close"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
