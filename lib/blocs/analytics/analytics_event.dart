abstract class AnalyticsEvent {}

class LoadAnalytics extends AnalyticsEvent {}

class UpdateProgress extends AnalyticsEvent {
  final String courseId;
  final double progress;
  UpdateProgress(this.courseId, this.progress);
}

class UpdateQuizScore extends AnalyticsEvent {
  final String quizId;
  final double score;
  UpdateQuizScore(this.quizId, this.score);
}
