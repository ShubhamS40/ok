import 'package:flutter/material.dart';

class StudentReviews extends StatelessWidget {
  final List<Map<String, String>> reviews = [
    {
      "name": "Ankit R.",
      "review": "This platform made finding past papers super easy!",
    },
    {
      "name": "Priya S.",
      "review": "Well-organized and very helpful for exam preparation.",
    },
    {
      "name": "Rahul M.",
      "review": "A must-have for every SRM student. Loved the UI!",
    },
    {
      "name": "Sneha K.",
      "review": "The papers are up-to-date and easy to download.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "What Students Say",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.amber,
            ),
          ),
          SizedBox(height: 12),
          SizedBox(
            height: 250, // Adjust the height as needed
            child: ListView.builder(
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              itemCount: reviews.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: _buildReviewCard(
                      reviews[index]["name"]!, reviews[index]["review"]!),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard(String name, String review) {
    return Container(
      padding: EdgeInsets.all(12),
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
            blurRadius: 6,
            offset: Offset(2, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.person, size: 40, color: Colors.white),
          SizedBox(height: 8),
          Text(
            name,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 4),
          Text(
            review,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}
