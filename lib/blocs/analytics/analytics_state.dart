import 'package:e_learning_app/models/analytics_data.dart';

abstract class AnalyticsState {}

class AnalyticsInitial extends AnalyticsState {}

class AnalyticsLoading extends AnalyticsState {}

class AnalyticsLoaded extends AnalyticsState {
  final AnalyticsData analytics;
  AnalyticsLoaded(this.analytics);
}

class AnalyticsError extends AnalyticsState {
  final String message;
  AnalyticsError(this.message);
}
