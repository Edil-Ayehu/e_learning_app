import 'package:e_learning_app/blocs/analytics/analytics_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_learning_app/services/analytics_service.dart';
import 'package:e_learning_app/blocs/analytics/analytics_event.dart';


class AnalyticsBloc extends Bloc<AnalyticsEvent, AnalyticsState> {
  final AnalyticsService _analyticsService;

  AnalyticsBloc(this._analyticsService) : super(AnalyticsInitial()) {
    on<LoadAnalytics>(_onLoadAnalytics);
    on<UpdateProgress>(_onUpdateProgress);
    on<UpdateQuizScore>(_onUpdateQuizScore);
    on<UpdateLearningStreak>(_onUpdateLearningStreak);
    on<UpdateSkillProgress>(_onUpdateSkillProgress);
    on<CompleteLesson>(_onCompleteLesson);
    on<EarnCertificate>(_onEarnCertificate);
  }

  Future<void> _onLoadAnalytics(LoadAnalytics event, Emitter<AnalyticsState> emit) async {
    emit(AnalyticsLoading());
    try {
      final analytics = await _analyticsService.getUserAnalytics(event.userId);
      emit(AnalyticsLoaded(analytics));
    } catch (e) {
      emit(AnalyticsError(e.toString()));
    }
  }

  Future<void> _onUpdateProgress(UpdateProgress event, Emitter<AnalyticsState> emit) async {
    if (state is AnalyticsLoaded) {
      try {
        final currentState = state as AnalyticsLoaded;
        final updatedAnalytics = await _analyticsService.updateCourseProgress(
          event.userId,
          event.courseId,
          event.progress,
          currentState.analytics,
        );
        emit(AnalyticsLoaded(updatedAnalytics));
      } catch (e) {
        emit(AnalyticsError(e.toString()));
      }
    }
  }

  Future<void> _onUpdateQuizScore(UpdateQuizScore event, Emitter<AnalyticsState> emit) async {
    if (state is AnalyticsLoaded) {
      try {
        final currentState = state as AnalyticsLoaded;
        final updatedAnalytics = await _analyticsService.updateQuizScore(
          event.userId,
          event.quizId,
          event.score,
          currentState.analytics,
        );
        emit(AnalyticsLoaded(updatedAnalytics));
      } catch (e) {
        emit(AnalyticsError(e.toString()));
      }
    }
  }

  Future<void> _onUpdateLearningStreak(UpdateLearningStreak event, Emitter<AnalyticsState> emit) async {
    if (state is AnalyticsLoaded) {
      try {
        final currentState = state as AnalyticsLoaded;
        final updatedAnalytics = await _analyticsService.updateLearningStreak(
          event.userId,
          currentState.analytics,
        );
        emit(AnalyticsLoaded(updatedAnalytics));
      } catch (e) {
        emit(AnalyticsError(e.toString()));
      }
    }
  }

  Future<void> _onUpdateSkillProgress(UpdateSkillProgress event, Emitter<AnalyticsState> emit) async {
    if (state is AnalyticsLoaded) {
      try {
        final currentState = state as AnalyticsLoaded;
        final updatedAnalytics = await _analyticsService.updateSkillProgress(
          event.userId,
          event.skillName,
          event.progress,
          currentState.analytics,
        );
        emit(AnalyticsLoaded(updatedAnalytics));
      } catch (e) {
        emit(AnalyticsError(e.toString()));
      }
    }
  }

  Future<void> _onCompleteLesson(CompleteLesson event, Emitter<AnalyticsState> emit) async {
    if (state is AnalyticsLoaded) {
      try {
        final currentState = state as AnalyticsLoaded;
        final updatedAnalytics = await _analyticsService.completeLesson(
          event.userId,
          event.courseId,
          event.lessonId,
          currentState.analytics,
        );
        emit(AnalyticsLoaded(updatedAnalytics));
      } catch (e) {
        emit(AnalyticsError(e.toString()));
      }
    }
  }

  Future<void> _onEarnCertificate(EarnCertificate event, Emitter<AnalyticsState> emit) async {
    if (state is AnalyticsLoaded) {
      try {
        final currentState = state as AnalyticsLoaded;
        final updatedAnalytics = await _analyticsService.earnCertificate(
          event.userId,
          event.courseId,
          currentState.analytics,
        );
        emit(AnalyticsLoaded(updatedAnalytics));
      } catch (e) {
        emit(AnalyticsError(e.toString()));
      }
    }
  }
}
