import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import 'package:srmone/component/navbar.dart';
import 'package:srmone/screen/branch.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Reduced Navbar Height
              AnimatedContainer(
                duration: const Duration(seconds: 1),
                height: MediaQuery.of(context).size.height / 10,
                decoration: const BoxDecoration(
                  color: Color(0xFF003D99),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Image.network(
                            "https://imgs.search.brave.com/7ht6JzSCc7AdtL8to5Qr6UkmftyTOqOcq5Uv5yBl-r0/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9sb2dv/ZGl4LmNvbS9sb2dv/LzE3ODcwNDAucG5n",
                            height: 60,
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            "SRM University",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.notifications,
                            color: Colors.white, size: 24),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ),
              // Main Content
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 16),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: const Text(
                        "Previous Year Question Papers",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFFFA500),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Select Branch",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // ✅ Image Slider Replacing Text Slider
                    CarouselSlider(
                      options: CarouselOptions(
                        height: 180, // Adjust height as needed
                        autoPlay: true,
                        enlargeCenterPage: true,
                      ),
                      items: [
                        "assets/srm.png", // Use your actual asset image
                      ]
                          .map((imagePath) => ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.asset(
                                  imagePath,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ))
                          .toList(),
                    ),

                    const SizedBox(height: 16),
                    // Branch Grid with Responsive Adjustments
                    const BranchSelection(),
                    const SizedBox(height: 16),
                    // Random Student Reviews Section
                    Container(
                      padding: EdgeInsets.all(16),
                      color: Colors.blueGrey.shade100,
                      child: Text(
                        "Students love this platform! \"It made finding past papers super easy!\" - Ankit R.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16, fontStyle: FontStyle.italic),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BranchSelection extends StatelessWidget {
  const BranchSelection({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(8.0),
      children: [
        BranchCard(label: "BCA", icon: Icons.computer),
        BranchCard(label: "B.Tech", icon: Icons.engineering),
        BranchCard(label: "BBA", icon: Icons.business),
        BranchCard(label: "BCom", icon: Icons.account_balance),
      ],
    );
  }
}

class BranchCard extends StatelessWidget {
  final String label;
  final IconData icon;
  const BranchCard({required this.label, required this.icon, super.key});

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      closedElevation: 5,
      closedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      transitionDuration: const Duration(milliseconds: 500),
      closedColor: Color(0xFF003D99),
      closedBuilder: (context, action) => Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.white),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      openBuilder: (context, action) => Branch(
        branchName: label,
      ),
    );
  }
}
