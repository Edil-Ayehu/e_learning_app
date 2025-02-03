abstract class AnalyticsEvent {
  final String userId;
  AnalyticsEvent(this.userId);
}

class LoadAnalytics extends AnalyticsEvent {
  LoadAnalytics(String userId) : super(userId);
}

class UpdateProgress extends AnalyticsEvent {
  final String courseId;
  final double progress;
  UpdateProgress(String userId, this.courseId, this.progress) : super(userId);
}

class UpdateQuizScore extends AnalyticsEvent {
  final String quizId;
  final double score;
  UpdateQuizScore(String userId, this.quizId, this.score) : super(userId);
}

class UpdateLearningStreak extends AnalyticsEvent {
  UpdateLearningStreak(String userId) : super(userId);
}

class UpdateSkillProgress extends AnalyticsEvent {
  final String skillName;
  final double progress;
  UpdateSkillProgress(String userId, this.skillName, this.progress) : super(userId);
}

class CompleteLesson extends AnalyticsEvent {
  final String courseId;
  final String lessonId;
  CompleteLesson(String userId, this.courseId, this.lessonId) : super(userId);
}

class EarnCertificate extends AnalyticsEvent {
  final String courseId;
  EarnCertificate(String userId, this.courseId) : super(userId);
}
