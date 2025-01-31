import 'package:e_learning_app/models/quiz.dart';
import 'package:equatable/equatable.dart';

class QuizState extends Equatable {
  final List<Quiz> quizzes;
  final Quiz? currentQuiz;
  final int currentQuestionIndex;
  final Map<String, String> userAnswers;
  final bool isLoading;
  final int remainingTime;
  final String? error;

  const QuizState({
    this.quizzes = const [],
    this.currentQuiz,
    this.currentQuestionIndex = 0,
    this.userAnswers = const {},
    this.isLoading = false,
    this.remainingTime = 0,
    this.error,
  });

  QuizState copyWith({
    List<Quiz>? quizzes,
    Quiz? currentQuiz,
    int? currentQuestionIndex,
    Map<String, String>? userAnswers,
    bool? isLoading,
    int? remainingTime,
    String? error,
  }) {
    return QuizState(
      quizzes: quizzes ?? this.quizzes,
      currentQuiz: currentQuiz ?? this.currentQuiz,
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      userAnswers: userAnswers ?? this.userAnswers,
      isLoading: isLoading ?? this.isLoading,
      remainingTime: remainingTime ?? this.remainingTime,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
        quizzes,
        currentQuiz,
        currentQuestionIndex,
        userAnswers,
        isLoading,
        remainingTime,
        error,
      ];
}
