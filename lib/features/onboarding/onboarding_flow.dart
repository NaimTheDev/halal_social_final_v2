import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mentor_app/features/auth/controllers/auth_controller.dart';

class CustomOnboarding extends ConsumerStatefulWidget {
  final bool isMentor;
  const CustomOnboarding({Key? key, required this.isMentor}) : super(key: key);

  @override
  ConsumerState<CustomOnboarding> createState() => _CustomOnboardingState();
}

class _CustomOnboardingState extends ConsumerState<CustomOnboarding> {
  final PageController _controller = PageController();
  final List<String> _allCategories = [
    'Faith',
    'Coaching',
    'Marriage',
    'Career',
    'Health',
    'Finance',
  ];
  final Set<String> _selected = {};
  String? _calendlyUrl;

  int get _totalPages => 2 + (widget.isMentor ? 1 : 0);

  void _next() {
    final next = _controller.page!.toInt() + 1;
    if (next < _totalPages) {
      _controller.animateToPage(
        next,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _finish();
    }
  }

  void _skip() => _finish();

  Future<void> _finish() async {
    final auth = ref.read(authServiceProvider);
    await auth.updateProfileData(
      categories: _selected.toList(),
      calendlyUrl: widget.isMentor ? _calendlyUrl : null,
    );
    Navigator.of(context).pushReplacementNamed('/Home');
  }

  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(onPressed: _skip, child: const Text('Skip')),
          ElevatedButton(
            onPressed: _next,
            child: Text(
              _controller.hasClients && _controller.page == _totalPages - 1
                  ? 'Finish'
                  : 'Next',
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tell us about you'), centerTitle: true),
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _controller,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                // 1) Categories
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      const SizedBox(height: 32),
                      const Text(
                        'Select your interests',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children:
                              _allCategories.map((c) {
                                return FilterChip(
                                  label: Text(c),
                                  selected: _selected.contains(c),
                                  onSelected: (yes) {
                                    setState(() {
                                      yes
                                          ? _selected.add(c)
                                          : _selected.remove(c);
                                    });
                                  },
                                );
                              }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),

                // 2) Calendly URL (mentors only)
                if (widget.isMentor)
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        const SizedBox(height: 32),
                        const Text(
                          'Your Calendly URL (optional)',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'https://calendly.com/you/meet',
                          ),
                          onChanged: (v) => _calendlyUrl = v.trim(),
                        ),
                      ],
                    ),
                  ),

                // Last) Summary
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      const SizedBox(height: 32),
                      const Text(
                        'All Set!',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text('Categories: ${_selected.join(', ')}'),
                      if (widget.isMentor &&
                          (_calendlyUrl?.isNotEmpty ?? false))
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text('Calendly: $_calendlyUrl'),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          _buildFooter(),
        ],
      ),
    );
  }
}
