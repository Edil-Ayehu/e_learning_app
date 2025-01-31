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
  }

  Future<void> _onLoadAnalytics(LoadAnalytics event, Emitter<AnalyticsState> emit) async {
    emit(AnalyticsLoading());
    try {
      final analytics = await _analyticsService.getUserAnalytics('current_user_id');
      emit(AnalyticsLoaded(analytics));
    } catch (e) {
      emit(AnalyticsError(e.toString()));
    }
  }

  Future<void> _onUpdateProgress(UpdateProgress event, Emitter<AnalyticsState> emit) async {
    try {
      await _analyticsService.trackLessonProgress(
        'current_user_id',
        event.courseId,
        event.progress,
      );
      add(LoadAnalytics()); // Reload analytics after update
    } catch (e) {
      emit(AnalyticsError(e.toString()));
    }
  }

  Future<void> _onUpdateQuizScore(UpdateQuizScore event, Emitter<AnalyticsState> emit) async {
    try {
      await _analyticsService.trackQuizAttempt(
        'current_user_id',
        event.quizId,
        event.score,
      );
      add(LoadAnalytics()); // Reload analytics after update
    } catch (e) {
      emit(AnalyticsError(e.toString()));
    }
  }
}
