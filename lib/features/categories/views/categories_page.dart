import 'package:flutter/material.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  final List<String> categories = const [
    'Addiction', 'Advisory', 'Arabic', 'Architecture',
    'Art', 'Business', 'Career Planning', 'Charity & Non-Profits',
    'Coaching', 'Comedy', 'Content Creation', 'Dawah',
    'Debate & Apologetics', 'E-Commerce', 'Education', 'Entertainment',
    'Entrepreneurship', 'Faith & Spirituality', 'Family', 'Fiqh Studies',
    'Fitness & Nutrition', 'Health Studies', 'Health & Wellness', 'Home Economics',
    'Islamic Finance', 'Marriage', 'Martial Arts', 'Mental Health',
    'Parenting', 'Philosophy', 'Podcasting', 'Politics',
    'Public Speaking', 'Quran Studies', 'Real Estate', 'Relationships',
    'Self-Improvement', 'Stocks & Crypto', 'Strength & Conditioning', 'Theology',
    'Therapy', 'Wealth Management', 'YouTube Creator',
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildSearchBar(),
              const SizedBox(height: 16),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text("Choose a category",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: SingleChildScrollView(
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 12,
                    children: categories.map((category) {
                      return GestureDetector(
                        onTap: () {
                          // TODO: Navigate to mentor results for that category
                        },
                        child: Container(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade400),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(category),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Find an expert...',
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}