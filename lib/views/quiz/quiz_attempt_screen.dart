import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:e_learning_app/core/theme/app_colors.dart';

class QuizAttemptScreen extends StatelessWidget {
  const QuizAttemptScreen({super.key});

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
              Icon(Icons.timer_outlined, color: AppColors.accent, size: 20),
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
        physics: const BouncingScrollPhysics(),
        itemCount: 10,
        itemBuilder: (context, index) => _QuestionPage(
          questionNumber: index + 1,
          totalQuestions: 10,
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
              () {},
              isNext: false,
            ),
            _buildNavigationButton(
              theme,
              Icons.arrow_forward_rounded,
              'Next',
              () {},
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
    VoidCallback onPressed, {
    bool isNext = false,
  }) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        backgroundColor: isNext ? AppColors.primary : AppColors.accent,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: isNext ? BorderSide.none : BorderSide(color: AppColors.primary),
        ),
      ),
      child: Row(
        children: [
          if (!isNext) Icon(icon, color: AppColors.primary, size: 20),
          if (!isNext) const SizedBox(width: 8),
          Text(
            label,
            style: theme.textTheme.labelLarge?.copyWith(
              color: isNext ? AppColors.accent : AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (isNext) const SizedBox(width: 8),
          if (isNext) Icon(icon, color: AppColors.accent, size: 20),
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
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Question $questionNumber of $totalQuestions',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.secondary,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'What is the main advantage of using Flutter for mobile app development?',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
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

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: RadioListTile(
        value: option,
        groupValue: null,
        onChanged: (value) {},
        title: Text(text),
        secondary: Text(
          option,
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
