import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QuizAttemptScreen extends StatelessWidget {
  const QuizAttemptScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.timer),
            const SizedBox(width: 8),
            Text('25:00'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => _showSubmitDialog(context),
            child: const Text('Submit'),
          ),
        ],
      ),
      body: PageView.builder(
        itemCount: 10,
        itemBuilder: (context, index) => _QuestionPage(
          questionNumber: index + 1,
          totalQuestions: 10,
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.arrow_back),
              label: const Text('Previous'),
            ),
            TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.arrow_forward),
              label: const Text('Next'),
            ),
          ],
        ),
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
