import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mentor_app/features/auth/controllers/auth_controller.dart';
import 'package:mentor_app/theme/app_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../shell/main_shell_page.dart';

class OnboardingFlow extends ConsumerStatefulWidget {
  final bool isMentor;

  const OnboardingFlow({Key? key, required this.isMentor}) : super(key: key);

  @override
  _OnboardingFlowState createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends ConsumerState<OnboardingFlow>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final PageController _pageController = PageController();

  // Text controllers for better input handling
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _expertiseController = TextEditingController();
  final TextEditingController _calendlyController = TextEditingController();

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
  int _currentPage = 0;

  int get _totalPages => widget.isMentor ? 4 : 2;

  void _nextPage() {
    if (_currentPage < _totalPages - 1) {
      _animationController.reset();
      _animationController.forward();
      setState(() {
        _currentPage++;
      });
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _finish();
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _animationController.reset();
      _animationController.forward();
      setState(() {
        _currentPage--;
      });
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _finish() async {
    final authService = ref.read(authServiceProvider);
    final firestore = FirebaseFirestore.instance;

    // Update profile data and navigate to home
    await authService.updateProfileData(
      _selectedCategories,
      _calendlyController.text.trim().isEmpty
          ? null
          : _calendlyController.text.trim(),
      bio: widget.isMentor ? _bioController.text.trim() : null,
      expertise: widget.isMentor ? _expertiseController.text.trim() : null,
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
    );

    if (widget.isMentor) {
      final currentUser = await authService.getCurrentUserData();
      final mentorData = {
        'email': currentUser?.email ?? '',
        'name':
            "${_firstNameController.text.trim()} ${_lastNameController.text.trim()}",
        'firstName': _firstNameController.text.trim(),
        'lastName': _lastNameController.text.trim(),
        'bio': _bioController.text.trim(),
        'expertise': _expertiseController.text.trim(),
        'calendlyUrl': _calendlyController.text.trim(),
        'categories': _selectedCategories,
      };
      await firestore
          .collection('mentors')
          .doc(currentUser?.uid)
          .set(mentorData);
    }

    // Invalidate currentUserProvider to refresh user data
    ref.invalidate(currentUserProvider);

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const MainShellPage()),
    );
  }

  Widget _buildCategoriesPage() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPageHeader(
            widget.isMentor ? 'Select your expertise' : 'Choose your interests',
            widget.isMentor
                ? 'What areas can you mentor others in?'
                : 'What topics are you interested in learning about?',
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Selected (${_selectedCategories.length})',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children:
                      _allCategories.map((category) {
                        final isSelected = _selectedCategories.contains(
                          category,
                        );
                        return FilterChip(
                          label: Text(
                            category,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color:
                                  isSelected
                                      ? Colors.white
                                      : Theme.of(context).colorScheme.primary,
                            ),
                          ),
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
                          backgroundColor: Colors.white,
                          selectedColor: Theme.of(context).colorScheme.primary,
                          checkmarkColor: Colors.white,
                          elevation: 0,
                          pressElevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(
                              color:
                                  isSelected
                                      ? Theme.of(context).colorScheme.primary
                                      : Colors.grey[300]!,
                            ),
                          ),
                        );
                      }).toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          _buildActionButtons(
            onNext: _nextPage,
            onPrevious: _previousPage,
            isNextEnabled: _selectedCategories.isNotEmpty,
          ),
        ],
      ),
    );
  }

  Widget _buildMentorPage() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPageHeader(
            'Almost done!',
            'Add your Calendly URL to let mentees schedule calls with you (optional)',
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FA),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE9ECEF)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.info_outline,
                    color: Theme.of(context).colorScheme.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Why add Calendly?',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Mentees can easily schedule calls with you through your Calendly link. You can always add this later in your profile.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _buildStyledTextField(
            label: 'Calendly URL',
            hint: 'https://calendly.com/your-username',
            controller: _calendlyController,
            keyboardType: TextInputType.url,
            suffixIcon: const Icon(
              Icons.calendar_today,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 40),
          _buildActionButtons(onNext: _nextPage, onPrevious: _previousPage),
        ],
      ),
    );
  }

  Widget _buildBioAndExpertisePage() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPageHeader(
            'Tell us about yourself',
            'Share your background and expertise to help mentees find you',
          ),
          const SizedBox(height: 20),
          _buildStyledTextField(
            label: 'Bio',
            hint:
                'Write a brief description about yourself, your experience, and your passion for mentoring...',
            controller: _bioController,
            maxLines: 4,
          ),
          _buildStyledTextField(
            label: 'Expertise',
            hint: 'What specific skills or knowledge do you excel in?',
            controller: _expertiseController,
          ),
          const SizedBox(height: 40),
          _buildActionButtons(
            onNext: _nextPage,
            onPrevious: _previousPage,
            isNextEnabled:
                _bioController.text.isNotEmpty &&
                _expertiseController.text.isNotEmpty,
          ),
        ],
      ),
    );
  }

  Widget _buildNamePage() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPageHeader(
            'Welcome! Let\'s get started',
            'Please enter your name to personalize your experience',
          ),
          const SizedBox(height: 20),
          _buildStyledTextField(
            label: 'First Name',
            hint: 'Enter your first name',
            controller: _firstNameController,
          ),
          _buildStyledTextField(
            label: 'Last Name',
            hint: 'Enter your last name',
            controller: _lastNameController,
          ),
          const SizedBox(height: 40),
          _buildActionButtons(
            onNext: _nextPage,
            isNextEnabled:
                _firstNameController.text.isNotEmpty &&
                _lastNameController.text.isNotEmpty,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryPage() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPageHeader(
            'Review your information',
            'Take a moment to review everything looks correct before finishing',
          ),
          const SizedBox(height: 20),
          _buildSummaryCard('Personal Information', [
            _buildSummaryItem('First Name', _firstNameController.text),
            _buildSummaryItem('Last Name', _lastNameController.text),
          ]),
          const SizedBox(height: 16),
          _buildSummaryCard(
            widget.isMentor ? 'Expertise Areas' : 'Interests',
            _selectedCategories
                .map((category) => _buildSummaryChip(category))
                .toList(),
          ),
          if (widget.isMentor && _calendlyController.text.isNotEmpty) ...[
            const SizedBox(height: 16),
            _buildSummaryCard('Calendly URL', [
              _buildSummaryItem('URL', _calendlyController.text),
            ]),
          ],
          if (widget.isMentor) ...[
            const SizedBox(height: 16),
            _buildSummaryCard('About You', [
              _buildSummaryItem('Bio', _bioController.text),
              _buildSummaryItem('Expertise', _expertiseController.text),
            ]),
          ],
          const SizedBox(height: 40),
          _buildActionButtons(
            onNext: _finish,
            onPrevious: _previousPage,
            nextText: 'Complete Setup',
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String title, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value.isEmpty ? 'Not provided' : value,
            style: TextStyle(
              fontSize: 16,
              color: value.isEmpty ? Colors.grey[400] : Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryChip(String category) {
    return Container(
      margin: const EdgeInsets.only(right: 8, bottom: 8),
      child: Chip(
        label: Text(
          category,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
        side: BorderSide(color: Theme.of(context).colorScheme.primary, width: 1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  Widget _buildStyledTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    Widget? suffixIcon,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            maxLines: maxLines,
            keyboardType: keyboardType,
            style: TextStyle(fontSize: 16),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: Colors.grey[400], fontSize: 16),
              filled: true,
              fillColor: Colors.grey[50],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                  width: 2,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Color(0xFFE74C3C),
                  width: 2,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              suffixIcon: suffixIcon,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        children: List.generate(_totalPages, (index) {
          final isActive = index <= _currentPage;
          final isCurrent = index == _currentPage;
          return Expanded(
            child: Container(
              height: 4,
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                color:
                    isCurrent
                        ? Theme.of(context).colorScheme.primary
                        : isActive
                        ? Theme.of(context).colorScheme.primary.withOpacity(0.6)
                        : Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildPageHeader(String title, String subtitle) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons({
    required VoidCallback onNext,
    VoidCallback? onPrevious,
    String nextText = 'Next',
    bool isNextEnabled = true,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        children: [
          if (onPrevious != null) ...[
            Expanded(
              child: OutlinedButton(
                onPressed: onPrevious,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: BorderSide(color: Theme.of(context).colorScheme.primary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Previous',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
          ],
          Expanded(
            flex: onPrevious != null ? 1 : 2,
            child: ElevatedButton(
              onPressed: isNextEnabled ? onNext : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: Text(
                nextText,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();

    // Add listeners to text controllers to trigger rebuilds
    _firstNameController.addListener(() => setState(() {}));
    _lastNameController.addListener(() => setState(() {}));
    _bioController.addListener(() => setState(() {}));
    _expertiseController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pageController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _bioController.dispose();
    _expertiseController.dispose();
    _calendlyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [_buildNamePage(), _buildCategoriesPage()];

    if (widget.isMentor) {
      pages.add(_buildBioAndExpertisePage());
      pages.add(_buildMentorPage());
    }

    pages.add(_buildSummaryPage());

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Setup Profile',
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading:
            _currentPage > 0
                ? IconButton(
                  icon: Icon(Icons.arrow_back, color: Theme.of(context).colorScheme.primary),
                  onPressed: _previousPage,
                )
                : null,
      ),
      body: Column(
        children: [
          _buildProgressIndicator(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: pages,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
