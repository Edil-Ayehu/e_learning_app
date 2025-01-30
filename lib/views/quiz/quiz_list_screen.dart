import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:e_learning_app/routes/app_routes.dart';

class QuizListScreen extends StatelessWidget {
  const QuizListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Available Quizzes',
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: theme.colorScheme.onPrimary,
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      theme.colorScheme.primary,
                      theme.colorScheme.primary.withOpacity(0.8),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => _QuizCard(
                  title: 'Quiz ${index + 1}',
                  description: 'Test your knowledge on Module ${index + 1}',
                  questionCount: 10,
                  timeLimit: 30,
                  onTap: () => Get.toNamed(
                    AppRoutes.quizAttempt.replaceAll(':id', index.toString()),
                  ),
                ),
                childCount: 5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuizCard extends StatelessWidget {
  final String title;
  final String description;
  final int questionCount;
  final int timeLimit;
  final VoidCallback onTap;

  const _QuizCard({
    required this.title,
    required this.description,
    required this.questionCount,
    required this.timeLimit,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Icon(
                    Icons.quiz,
                    size: 16,
                    color: theme.colorScheme.secondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '$questionCount Questions',
                    style: theme.textTheme.bodySmall,
                  ),
                  const SizedBox(width: 16),
                  Icon(
                    Icons.timer,
                    size: 16,
                    color: theme.colorScheme.secondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '$timeLimit minutes',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
