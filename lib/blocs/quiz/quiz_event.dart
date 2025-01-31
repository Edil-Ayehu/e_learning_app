import 'package:equatable/equatable.dart';

abstract class QuizEvent extends Equatable {
  const QuizEvent();

  @override
  List<Object?> get props => [];
}

class LoadQuizzes extends QuizEvent {}

class StartQuiz extends QuizEvent {
  final String quizId;

  const StartQuiz(this.quizId);

  @override
  List<Object?> get props => [quizId];
}

class SubmitAnswer extends QuizEvent {
  final String questionId;
  final String optionId;

  const SubmitAnswer({
    required this.questionId,
    required this.optionId,
  });

  @override
  List<Object?> get props => [questionId, optionId];
}

class SubmitQuiz extends QuizEvent {}

class UpdateTimer extends QuizEvent {
  final int remainingTime;

  const UpdateTimer(this.remainingTime);

  @override
  List<Object?> get props => [remainingTime];
}
