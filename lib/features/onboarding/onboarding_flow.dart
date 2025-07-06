import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mentor_app/features/auth/controllers/auth_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OnboardingFlow extends ConsumerStatefulWidget {
  final bool isMentor;

  const OnboardingFlow({Key? key, required this.isMentor}) : super(key: key);

  @override
  _OnboardingFlowState createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends ConsumerState<OnboardingFlow> {
  final List<String> _allCategories = [
    'Addiction',
    'Advisory',
    'Arabic',
    'Architecture',
    'Art',
    'Business',
    'Career Planning',
    'Charity & Non-Profits',
    'Coaching',
    'Comedy',
    'Content Creation',
    'Dawah',
    'Debate & Apologetics',
    'E-Commerce',
    'Education',
    'Entertainment',
    'Entrepreneurship',
    'Faith & Spirituality',
    'Family',
    'Fiqh Studies',
    'Fitness & Nutrition',
    'Health Studies',
    'Health & Wellness',
    'Home Economics',
    'Islamic Finance',
    'Marriage',
    'Martial Arts',
    'Mental Health',
    'Parenting',
    'Philosophy',
    'Podcasting',
    'Politics',
    'Public Speaking',
    'Quran Studies',
    'Real Estate',
    'Relationships',
    'Self-Improvement',
    'Stocks & Crypto',
    'Strength & Conditioning',
    'Theology',
    'Therapy',
    'Wealth Management',
    'YouTube Creator',
  ];
  final List<String> _selectedCategories = [];
  String? _calendlyUrl;
  int _currentPage = 0;

  String? _bio;
  String? _expertise;

  String? _firstName;
  String? _lastName;

  int get _totalPages => widget.isMentor ? 4 : 2;

  void _nextPage() {
    if (_currentPage < _totalPages - 1) {
      setState(() {
        _currentPage++;
      });
    } else {
      _finish();
    }
  }

  void _finish() async {
    final authService = ref.read(authServiceProvider);
    final firestore = FirebaseFirestore.instance;

    // Update profile data and navigate to home
    await authService.updateProfileData(
      _selectedCategories,
      _calendlyUrl,
      bio: widget.isMentor ? _bio : null,
      expertise: widget.isMentor ? _expertise : null,
      firstName: _firstName,
      lastName: _lastName,
    );

    if (widget.isMentor) {
      final currentUser = await authService.getCurrentUserData();
      final mentorData = {
        'email': currentUser?.email ?? '',
        'name': "$_firstName $_lastName",
        'firstName': _firstName,
        'lastName': _lastName,
        'bio': _bio ?? '',
        'expertise': _expertise ?? '',
        'calendlyUrl': _calendlyUrl ?? '',
        'categories': _selectedCategories,
      };
      await firestore
          .collection('mentors')
          .doc(currentUser?.uid)
          .set(mentorData);
    }

    // Invalidate currentUserProvider to refresh user data
    ref.invalidate(currentUserProvider);

    Navigator.of(context).pushReplacementNamed('/Home');
  }

  Widget _buildCategoriesPage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          widget.isMentor ? 'Select your expertise' : 'Select your interests',
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children:
              _allCategories.map((category) {
                final isSelected = _selectedCategories.contains(category);
                return FilterChip(
                  label: Text(category),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedCategories.add(category);
                      } else {
                        _selectedCategories.remove(category);
                      }
                    });
                  },
                );
              }).toList(),
        ),
        const Spacer(),
        ElevatedButton(
          onPressed: _selectedCategories.isEmpty ? null : _nextPage,
          child: const Text('Next'),
        ),
      ],
    );
  }

  Widget _buildMentorPage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Your Calendly URL (optional)',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        TextField(
          decoration: const InputDecoration(
            labelText: 'Calendly URL',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) => _calendlyUrl = value,
        ),
        const Spacer(),
        ElevatedButton(onPressed: _nextPage, child: const Text('Next')),
      ],
    );
  }

  Widget _buildBioAndExpertisePage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Tell us about yourself',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        TextField(
          decoration: const InputDecoration(
            labelText: 'Bio',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) => _bio = value,
        ),
        const SizedBox(height: 16),
        TextField(
          decoration: const InputDecoration(
            labelText: 'Expertise',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) => _expertise = value,
        ),
        const Spacer(),
        ElevatedButton(onPressed: _nextPage, child: const Text('Next')),
      ],
    );
  }

  Widget _buildNamePage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Enter your name',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        TextField(
          decoration: const InputDecoration(
            labelText: 'First Name',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) => _firstName = value,
        ),
        const SizedBox(height: 16),
        TextField(
          decoration: const InputDecoration(
            labelText: 'Last Name',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) => _lastName = value,
        ),
        const Spacer(),
        ElevatedButton(onPressed: _nextPage, child: const Text('Next')),
      ],
    );
  }

  Widget _buildSummaryPage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Summary',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        const Text(
          'Selected Categories:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        ..._selectedCategories.map((cat) => ListTile(title: Text(cat))),
        if (widget.isMentor && (_calendlyUrl?.isNotEmpty ?? false)) ...[
          const SizedBox(height: 16),
          const Text(
            'Calendly URL:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          ListTile(title: Text(_calendlyUrl!)),
        ],
        if (widget.isMentor) ...[
          const SizedBox(height: 16),
          const Text(
            'Bio:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          ListTile(title: Text(_bio ?? '')),
          const SizedBox(height: 16),
          const Text(
            'Expertise:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          ListTile(title: Text(_expertise ?? '')),
        ],
        const Spacer(),
        ElevatedButton(onPressed: _finish, child: const Text('Finish')),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget body;
    switch (_currentPage) {
      case 0:
        body = _buildNamePage();
        break;
      case 1:
        body = _buildCategoriesPage();
        break;
      case 2:
        body =
            widget.isMentor ? _buildBioAndExpertisePage() : _buildSummaryPage();
        break;
      case 3:
        body = widget.isMentor ? _buildMentorPage() : _buildSummaryPage();
        break;
      case 4:
        body = _buildSummaryPage();
        break;
      default:
        body = const SizedBox.shrink();
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Onboarding')),
      body: Padding(padding: const EdgeInsets.all(16.0), child: body),
    );
  }
}
