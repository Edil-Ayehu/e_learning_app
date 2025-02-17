import 'package:e_learning_app/models/question.dart';
import 'package:e_learning_app/models/quiz.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:e_learning_app/core/theme/app_colors.dart';
import 'package:e_learning_app/services/dummy_data_service.dart';
import 'dart:async';
import 'package:e_learning_app/models/quiz_attempt.dart';
import 'package:e_learning_app/views/quiz/quiz_result_screen.dart';
import 'package:e_learning_app/routes/app_routes.dart';

class QuizAttemptScreen extends StatefulWidget {
  final String quizId;
  const QuizAttemptScreen({super.key, required this.quizId});

  @override
  State<QuizAttemptScreen> createState() => _QuizAttemptScreenState();
}

class _QuizAttemptScreenState extends State<QuizAttemptScreen> {
  late final Quiz quiz;
  late final PageController _pageController;
  int _currentPage = 0;
  Map<String, String> selectedAnswers = {}; // questionId: optionId
  int remainingSeconds = 0;
  Timer? _timer;
  QuizAttempt? currentAttempt;

  @override
  void initState() {
    super.initState();
    quiz = DummyDataService.getQuizById(widget.quizId);
    _pageController = PageController();
    _pageController.addListener(_onPageChanged);
    remainingSeconds = quiz.timeLimit * 60;
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
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

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds > 0) {
        setState(() {
          remainingSeconds--;
        });
      } else {
        _submitQuiz();
      }
    });
  }

  String get formattedTime {
    final minutes = (remainingSeconds / 60).floor();
    final seconds = remainingSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  void _selectAnswer(String questionId, String optionId) {
    setState(() {
      selectedAnswers[questionId] = optionId;
    });
  }

  void _submitQuiz() {
    _timer?.cancel();
    final score = _calculateScore();
    currentAttempt = QuizAttempt(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      quizId: quiz.id,
      userId: 'current_user_id',
      answers: selectedAnswers,
      score: score,
      startedAt: DateTime.now()
          .subtract(Duration(seconds: quiz.timeLimit * 60 - remainingSeconds)),
      completedAt: DateTime.now(),
      timeSpent: quiz.timeLimit * 60 - remainingSeconds,
    );

    DummyDataService.saveQuizAttempt(currentAttempt!);

    Get.off(
      () => QuizResultScreen(
        attempt: currentAttempt!,
        quiz: quiz,
      ),
    );
  }

  int _calculateScore() {
    int score = 0;
    for (final question in quiz.questions) {
      if (selectedAnswers[question.id] == question.correctOptionId) {
        score += question.points;
      }
    }
    return score;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: AppColors.accent,
        ),
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.accent.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.timer_outlined,
                  color: AppColors.accent, size: 20),
              const SizedBox(width: 8),
              Text(
                formattedTime,
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
        itemCount: quiz.questions.length,
        itemBuilder: (context, index) => _QuestionPage(
          questionNumber: index + 1,
          totalQuestions: quiz.questions.length,
          question: quiz.questions[index],
          selectedOptionId: selectedAnswers[quiz.questions[index].id],
          onOptionSelected: (optionId) =>
              _selectAnswer(quiz.questions[index].id, optionId),
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
              _currentPage < quiz.questions.length - 1
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
    final score = _calculateScore();
    currentAttempt = QuizAttempt(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      quizId: quiz.id,
      userId: 'current_user_id',
      answers: selectedAnswers,
      score: score,
      startedAt: DateTime.now()
          .subtract(Duration(seconds: quiz.timeLimit * 60 - remainingSeconds)),
      completedAt: DateTime.now(),
      timeSpent: quiz.timeLimit * 60 - remainingSeconds,
    );

    // Save attempt
    DummyDataService.saveQuizAttempt(currentAttempt!);

    return showDialog(
      context: context,
      barrierDismissible: false,
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
              Get.off(
                () => QuizResultScreen(
                  attempt: currentAttempt!,
                  quiz: quiz,
                ),
              );
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
  final Question question;
  final String? selectedOptionId;
  final Function(String) onOptionSelected;

  const _QuestionPage({
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
          ...question.options.map((option) => _buildOptionTile(
                context,
                option.id,
                option.text,
                isSelected: selectedOptionId == option.id,
                onTap: () => onOptionSelected(option.id),
              )),
        ],
      ),
    );
  }

  Widget _buildOptionTile(BuildContext context, String optionId, String text,
      {required bool isSelected, required VoidCallback onTap}) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color:
            isSelected ? AppColors.primary.withOpacity(0.1) : AppColors.accent,
        borderRadius: BorderRadius.circular(16),
        border:
            isSelected ? Border.all(color: AppColors.primary, width: 2) : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
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
                      optionId,
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
                Radio<String>(
                  value: optionId,
                  groupValue: selectedOptionId,
                  onChanged: (_) => onTap(),
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
