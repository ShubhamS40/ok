import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import 'package:srm_exam_x/component/branch_card.dart';
import 'package:srm_exam_x/component/navbar.dart';
import 'package:srm_exam_x/component/notification_bell.dart';
import 'package:srm_exam_x/component/student_review.dart';
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
              LayoutBuilder(
                builder: (context, constraints) {
                  double navbarHeight = constraints.maxWidth > 600 ? 80 : 60;
                  return AnimatedContainer(
                    duration: const Duration(seconds: 1),
                    height: navbarHeight,
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
                              Image.asset(
                                'assets/srm_logo.png',
                                height: navbarHeight * 0.8,
                              ),
                              const SizedBox(width: 10),
                              const Text(
                                "SRM University",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Stack(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.notifications,
                                    color: Colors.white, size: 24),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) =>
                                        const LatestPaperDrawer(),
                                  );
                                },
                              ),
                              Positioned(
                                right: 5,
                                top: -2,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  constraints: const BoxConstraints(
                                    minWidth: 10,
                                    minHeight: 10,
                                  ),
                                  child: const Text(
                                    '1',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 16),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: const Text(
                        "Previous Year Question Papers",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFFFA500),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    CarouselSlider(
                      options: CarouselOptions(
                        height:
                            MediaQuery.of(context).size.width > 600 ? 250 : 180,
                        autoPlay: true,
                        enlargeCenterPage: true,
                      ),
                      items: [
                        "assets/srm.png",
                        "assets/srm_3.png",
                        "assets/ban.png"
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
                    const SizedBox(height: 20),
                    InteractiveTitle(title: "Select Branch"),
                    const SizedBox(height: 16),
                    const BranchSelection(),
                    InteractiveTitle(title: "Student Review"),
                    StudentReviews(),
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
    int crossAxisCount = MediaQuery.of(context).size.width > 800
        ? 4
        : MediaQuery.of(context).size.width > 600
            ? 3
            : 2;

    return LayoutBuilder(
      builder: (context, constraints) {
        return GridView.count(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(8.0),
          children: const [
            BranchCard(label: "BCA", icon: Icons.computer),
            BranchCard(label: "BTech", icon: Icons.engineering),
            BranchCard(label: "Law", icon: Icons.gavel),
            BranchCard(label: "BCom", icon: Icons.account_balance),
          ],
        );
      },
    );
  }
}

class InteractiveTitle extends StatefulWidget {
  final String title;
  const InteractiveTitle({super.key, required this.title});

  @override
  _InteractiveTitleState createState() => _InteractiveTitleState();
}

class _InteractiveTitleState extends State<InteractiveTitle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Text(
        widget.title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          decoration: TextDecoration.underline,
          decorationColor: Color(0xFFFFA500),
          color: Color(0xFFFFA500),
        ),
      ),
    );
  }
}
