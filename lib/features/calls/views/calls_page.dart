import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mentor_app/models/scheduled_call.dart';
import 'package:mentor_app/shared/widgets/zoom_launch_page.dart';

class CallsPage extends StatelessWidget {
  const CallsPage({super.key});

  Future<List<ScheduledCall>> _fetchScheduledCalls() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('User not logged in');
    }

    final scheduledCallsRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('scheduled_calls');

    final snapshot = await scheduledCallsRef.get();
    return snapshot.docs
        .map((doc) => ScheduledCall.fromFirestore(doc.data()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ScheduledCall>>(
      future: _fetchScheduledCalls(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Error loading calls'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Go Back'),
                  ),
                ],
              ),
            ),
          );
        }

        final calls = snapshot.data ?? [];
        final upcomingCalls =
            calls
                .where(
                  (call) =>
                      DateTime.parse(call.startTime).isAfter(DateTime.now()),
                )
                .toList();
        final pastCalls =
            calls
                .where(
                  (call) =>
                      DateTime.parse(call.startTime).isBefore(DateTime.now()),
                )
                .toList();

        return DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              title: const Text(
                'Calendar',
                style: TextStyle(color: Colors.white),
              ),
              iconTheme: const IconThemeData(color: Colors.white),
              bottom: const TabBar(
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white70,
                indicatorColor: Colors.white,
                tabs: [Tab(text: 'Upcoming'), Tab(text: 'Past')],
              ),
            ),
            body: TabBarView(
              children: [
                _CallsListTab(
                  calls: upcomingCalls,
                  emptyLabel: 'No upcoming calls',
                ),
                _CallsListTab(calls: pastCalls, emptyLabel: 'No past calls'),
              ],
            ),
          ),
        );
      },
    );
  }
}

class AppointmentCard extends StatelessWidget {
  final ScheduledCall call;

  const AppointmentCard({super.key, required this.call});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final startTime = DateTime.parse(call.startTime);
    final isUpcoming = startTime.isAfter(now);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${call.eventType} with ${call.inviteeName}',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.access_time, size: 20, color: Colors.grey),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Date in mm/dd/yyyy
                    Text(
                      '${startTime.toLocal().month.toString().padLeft(2, '0')}/'
                      '${startTime.toLocal().day.toString().padLeft(2, '0')}/'
                      '${startTime.toLocal().year}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    // Start time -> End time
                    Text(
                      '${TimeOfDay.fromDateTime(startTime.toLocal()).format(context)}'
                      ' → '
                      '${TimeOfDay.fromDateTime(DateTime.parse(call.endTime).toLocal()).format(context)}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (isUpcoming)
              Align(
                alignment: Alignment.centerRight,
                child: Visibility(
                  visible: call.joinUrl != null,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder:
                              (_) => ZoomLaunchPage(meetingUrl: call.joinUrl!),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Join Now'),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _CallsListTab extends StatelessWidget {
  final List<ScheduledCall> calls;
  final String emptyLabel;

  const _CallsListTab({required this.calls, required this.emptyLabel});

  @override
  Widget build(BuildContext context) {
    if (calls.isEmpty) {
      return _EmptyCallTab(label: emptyLabel);
    }

    return ListView.builder(
      itemCount: calls.length,
      itemBuilder: (context, index) {
        final call = calls[index];
        return GestureDetector(
          onTap: () {
            // TODO: Navigate to detailed call view if needed
          },
          child: AppointmentCard(call: call),
        );
      },
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
          Text(
            label,
            style: const TextStyle(fontSize: 16, color: Colors.black54),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/Mentor');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Find an Expert'),
          ),
        ],
      ),
    );
  }
}
