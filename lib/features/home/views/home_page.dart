import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _buildSearchBar(context)),
            SliverToBoxAdapter(child: _buildCategoryChips()),
            SliverToBoxAdapter(child: _buildSectionHeader('Featured Experts')),
            SliverToBoxAdapter(child: _buildHorizontalMentorCards()),

            SliverToBoxAdapter(child: _buildSectionHeader('Coaching')),
            SliverToBoxAdapter(child: _buildHorizontalMentorCards()),

            SliverToBoxAdapter(child: _buildSectionHeader('Marriage')),
            SliverToBoxAdapter(child: _buildHorizontalMentorCards()),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Find an expert...',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  Widget _buildCategoryChips() {
    final categories = [
      'Fitness & Nutrition',
      'Theology',
      'Quranic Studies',
      'Coaching',
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children:
            categories.map((cat) {
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Chip(label: Text(cat)),
              );
            }).toList(),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const Text('See all', style: TextStyle(color: Colors.blue)),
        ],
      ),
    );
  }

  Widget _buildHorizontalMentorCards() {
    return SizedBox(
      height: 140,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: 5,
        itemBuilder: (context, index) {
          return Container(
            width: 120,
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.grey[200],
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(radius: 24),
                SizedBox(height: 8),
                Text(
                  'Mohamed Mohamed',
                  style: TextStyle(fontSize: 12),
                  textAlign: TextAlign.center,
                ),
                Text('5.0 ★', style: TextStyle(fontSize: 10)),
              ],
            ),
          );
        },
      ),
    );
  }
}
