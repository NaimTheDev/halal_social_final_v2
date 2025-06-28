// lib/shared/widgets/zoom_launch_page.dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ZoomLaunchPage extends StatelessWidget {
  final String meetingUrl;
  const ZoomLaunchPage({super.key, required this.meetingUrl});

  Future<void> _launch() async {
    final uri = Uri.parse(meetingUrl);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      // show an error if it fails
      throw 'Could not launch $meetingUrl';
    }
  }

  @override
  Widget build(BuildContext context) {
    // kick off the launch as soon as this page builds
    WidgetsBinding.instance.addPostFrameCallback((_) => _launch());
    return Scaffold(
      appBar: AppBar(title: const Text('Joining Zoom…')),
      body: const Center(child: Text('Opening your Zoom app or browser…')),
    );
  }
}
