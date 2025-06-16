import 'package:flutter/material.dart';

class CallsPage extends StatelessWidget {
  const CallsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Calendar'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Upcoming'),
              Tab(text: 'Past'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _EmptyCallTab(label: 'No upcoming calls'),
            _EmptyCallTab(label: 'No past calls'),
          ],
        ),
      ),
    );
  }
}

class _EmptyCallTab extends StatelessWidget {
  final String label;

  const _EmptyCallTab({required this.label});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.calendar_month, size: 60, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(label, style: const TextStyle(fontSize: 16, color: Colors.black54)),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // TODO: Navigate to browse expert or home
              Navigator.pushNamed(context, '/Mentor');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Find an Expert'),
          ),
        ],
      ),
    );
  }
}