import 'dart:async';
import 'package:e_learning_app/blocs/quiz/quiz_event.dart';
import 'package:e_learning_app/blocs/quiz/quiz_state.dart';
import 'package:e_learning_app/models/quiz.dart';
import 'package:e_learning_app/models/quiz_attempt.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class QuizBloc extends Bloc<QuizEvent, QuizState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Timer? _timer;

  QuizBloc() : super(const QuizState()) {
    on<LoadQuizzes>(_onLoadQuizzes);
    on<StartQuiz>(_onStartQuiz);
    on<SubmitAnswer>(_onSubmitAnswer);
    on<SubmitQuiz>(_onSubmitQuiz);
    on<UpdateTimer>(_onUpdateTimer);
  }

  Future<void> _onLoadQuizzes(
    LoadQuizzes event,
    Emitter<QuizState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true));
      final snapshot = await _firestore
          .collection('quizzes')
          .where('isActive', isEqualTo: true)
          .get();

      final quizzes = snapshot.docs
          .map((doc) => Quiz.fromFirestore(doc))
          .toList();

      emit(state.copyWith(
        quizzes: quizzes,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        error: 'Failed to load quizzes',
        isLoading: false,
      ));
    }
  }

  Future<void> _onStartQuiz(
    StartQuiz event,
    Emitter<QuizState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true));
      final doc = await _firestore.collection('quizzes').doc(event.quizId).get();
      final quiz = Quiz.fromFirestore(doc);

      _startTimer();

      emit(state.copyWith(
        currentQuiz: quiz,
        currentQuestionIndex: 0,
        userAnswers: {},
        remainingTime: quiz.timeLimit * 60,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        error: 'Failed to start quiz',
        isLoading: false,
      ));
    }
  }

  void _onSubmitAnswer(
    SubmitAnswer event,
    Emitter<QuizState> emit,
  ) {
    final newAnswers = Map<String, String>.from(state.userAnswers);
    newAnswers[event.questionId] = event.optionId;
    emit(state.copyWith(userAnswers: newAnswers));
  }

  Future<void> _onSubmitQuiz(
    SubmitQuiz event,
    Emitter<QuizState> emit,
  ) async {
    try {
      if (state.currentQuiz == null) return;

      final score = _calculateScore();
      final attempt = QuizAttempt(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        quizId: state.currentQuiz!.id,
        userId: 'currentUserId', // Replace with actual user ID
        answers: state.userAnswers,
        score: score,
        startedAt: DateTime.now().subtract(
          Duration(seconds: state.currentQuiz!.timeLimit * 60 - state.remainingTime),
        ),
        completedAt: DateTime.now(),
        timeSpent: state.currentQuiz!.timeLimit * 60 - state.remainingTime,
      );

      await _firestore
          .collection('quiz_attempts')
          .doc(attempt.id)
          .set(attempt.toMap());

      _timer?.cancel();
      emit(state.copyWith(
        currentQuiz: null,
        userAnswers: {},
        remainingTime: 0,
      ));
    } catch (e) {
      emit(state.copyWith(error: 'Failed to submit quiz'));
    }
  }

  void _onUpdateTimer(
    UpdateTimer event,
    Emitter<QuizState> emit,
  ) {
    emit(state.copyWith(remainingTime: event.remainingTime));
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.remainingTime > 0) {
        add(UpdateTimer(state.remainingTime - 1));
      } else {
        timer.cancel();
        add(SubmitQuiz());
      }
    });
  }

  int _calculateScore() {
    if (state.currentQuiz == null) return 0;
    
    int score = 0;
    for (final question in state.currentQuiz!.questions) {
      if (state.userAnswers[question.id] == question.correctOptionId) {
        score += question.points;
      }
    }
    return score;
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
