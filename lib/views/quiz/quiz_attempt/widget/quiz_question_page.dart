import 'package:e_learning_app/core/theme/app_colors.dart';
import 'package:e_learning_app/models/question.dart';
import 'package:e_learning_app/views/quiz/quiz_attempt/widget/quiz_option_tile.dart';
import 'package:flutter/material.dart';

class QuizQuestionPage extends StatelessWidget {
  final int questionNumber;
  final int totalQuestions;
  final Question question;
  final String? selectedOptionId;
  final Function(String) onOptionSelected;

  const QuizQuestionPage({
    super.key,
    required this.questionNumber,
    required this.totalQuestions,
    required this.question,
    required this.selectedOptionId,
    required this.onOptionSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
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
            question.text,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 32),
          ...question.options.map((option) => QuizOptionTile(
                optionId: option.id,
                text: option.text,
                isSelected: selectedOptionId == option.id,
                onTap: () => onOptionSelected(option.id),
                selectedOptionId: selectedOptionId,
              )),
        ],
      ),
    );
  }
}
