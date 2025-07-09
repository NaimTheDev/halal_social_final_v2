import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mentor_app/features/calls/providers/calls_providers.dart';
import 'package:mentor_app/models/scheduled_call.dart';
import 'package:mentor_app/shared/widgets/zoom_launch_page.dart';

class CallsPage extends ConsumerWidget {
  const CallsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final callsAsync = ref.watch(scheduledCallsProvider);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Calendar', style: TextStyle(color: Colors.white)),
          iconTheme: const IconThemeData(color: Colors.white),
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
            tabs: [Tab(text: 'Upcoming'), Tab(text: 'Past')],
          ),
        ),
        body: callsAsync.when(
          data: (calls) {
            final upcomingCalls =
                calls
                    .where(
                      (call) => DateTime.parse(
                        call.startTime,
                      ).isAfter(DateTime.now()),
                    )
                    .toList();
            final pastCalls =
                calls
                    .where(
                      (call) => DateTime.parse(
                        call.startTime,
                      ).isBefore(DateTime.now()),
                    )
                    .toList();

            return TabBarView(
              children: [
                _CallsListTab(
                  calls: upcomingCalls,
                  emptyLabel: 'No upcoming calls',
                ),
                _CallsListTab(calls: pastCalls, emptyLabel: 'No past calls'),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error:
              (error, stackTrace) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Error loading calls',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      error.toString(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        ref.invalidate(scheduledCallsProvider);
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
        ),
      ),
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
                    // Start time → End time
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
              Navigator.pushNamed(context, '/mentors');
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
