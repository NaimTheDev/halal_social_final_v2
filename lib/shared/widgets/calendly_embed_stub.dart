import 'package:flutter/material.dart';

class CalendlyEmbed extends StatelessWidget {
  final String calendlyUrl;

  const CalendlyEmbed({super.key, required this.calendlyUrl});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Calendly embed not supported on this platform'),
    );
  }
}