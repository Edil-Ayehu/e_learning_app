import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:e_learning_app/core/theme/app_colors.dart';

class QuizAttemptScreen extends StatefulWidget {
  const QuizAttemptScreen({super.key});

  @override
  State<QuizAttemptScreen> createState() => _QuizAttemptScreenState();
}

class _QuizAttemptScreenState extends State<QuizAttemptScreen> {
  late final PageController _pageController;
  int _currentPage = 0;
  final int _totalPages = 10;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _pageController.addListener(_onPageChanged);
  }

  @override
  void dispose() {
    _pageController.removeListener(_onPageChanged);
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged() {
    if (_pageController.page != null) {
      setState(() {
        _currentPage = _pageController.page!.round();
      });
    }
  }

  void _navigateToPage(int page) {
    _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.accent.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.timer_outlined, color: AppColors.accent, size: 20),
              const SizedBox(width: 8),
              Text(
                '25:00',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: AppColors.accent,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            child: TextButton(
              onPressed: () => _showSubmitDialog(context),
              style: TextButton.styleFrom(
                backgroundColor: AppColors.accent.withOpacity(0.1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(
                'Submit',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: AppColors.accent,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: PageView.builder(
        controller: _pageController,
        physics: const BouncingScrollPhysics(),
        itemCount: _totalPages,
        itemBuilder: (context, index) => _QuestionPage(
          questionNumber: index + 1,
          totalQuestions: _totalPages,
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.accent,
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildNavigationButton(
              theme,
              Icons.arrow_back_rounded,
              'Previous',
              _currentPage > 0 ? () => _navigateToPage(_currentPage - 1) : null,
              isNext: false,
            ),
            _buildNavigationButton(
              theme,
              Icons.arrow_forward_rounded,
              'Next',
              _currentPage < _totalPages - 1
                  ? () => _navigateToPage(_currentPage + 1)
                  : null,
              isNext: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationButton(
    ThemeData theme,
    IconData icon,
    String label,
    VoidCallback? onPressed, {
    bool isNext = false,
  }) {
    final isEnabled = onPressed != null;

    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        backgroundColor: isNext ? AppColors.primary : AppColors.accent,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: isNext ? BorderSide.none : BorderSide(color: AppColors.primary),
        ),
        disabledBackgroundColor: isNext
            ? AppColors.primary.withOpacity(0.5)
            : AppColors.accent.withOpacity(0.5),
      ),
      child: Row(
        children: [
          if (!isNext)
            Icon(icon,
                color: isEnabled
                    ? AppColors.primary
                    : AppColors.primary.withOpacity(0.5),
                size: 20),
          if (!isNext) const SizedBox(width: 8),
          Text(
            label,
            style: theme.textTheme.labelLarge?.copyWith(
              color: isEnabled
                  ? (isNext ? AppColors.accent : AppColors.primary)
                  : (isNext ? AppColors.accent : AppColors.primary)
                      .withOpacity(0.5),
              fontWeight: FontWeight.bold,
            ),
          ),
          if (isNext) const SizedBox(width: 8),
          if (isNext)
            Icon(icon,
                color: isEnabled
                    ? AppColors.accent
                    : AppColors.accent.withOpacity(0.5),
                size: 20),
        ],
      ),
    );
  }

  Future<void> _showSubmitDialog(BuildContext context) async {
    final theme = Theme.of(context);

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Submit Quiz'),
        content: const Text('Are you sure you want to submit your answers?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              Get.back();
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}

class _QuestionPage extends StatelessWidget {
  final int questionNumber;
  final int totalQuestions;

  const _QuestionPage({
    required this.questionNumber,
    required this.totalQuestions,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Question $questionNumber of $totalQuestions',
              style: theme.textTheme.titleMedium?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'What is the main advantage of using Flutter for mobile app development?',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 32),
          _buildOptionTile(context, 'A', 'Cross-platform development'),
          _buildOptionTile(context, 'B', 'Native performance'),
          _buildOptionTile(context, 'C', 'Hot reload feature'),
          _buildOptionTile(context, 'D', 'Rich widget library'),
        ],
      ),
    );
  }

  Widget _buildOptionTile(BuildContext context, String option, String text) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.accent,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      option,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    text,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ),
                Radio(
                  value: option,
                  groupValue: null,
                  onChanged: (value) {},
                  activeColor: AppColors.primary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
