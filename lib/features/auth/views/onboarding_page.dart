import 'package:flutter/material.dart';
import '../models/app_user.dart';

class CustomOnboarding extends StatelessWidget {
  final bool isMentor;

  const CustomOnboarding({super.key, required this.isMentor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isMentor ? 'Mentor Onboarding' : 'Mentee Onboarding'),
      ),
      body: Center(
        child: Text(
          isMentor ? 'Welcome Mentor!' : 'Welcome Mentee!',
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
