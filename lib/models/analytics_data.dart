class AnalyticsData {
  final double completionRate;
  final int totalTimeSpent;
  final double averageQuizScore;
  final Map<String, double> skillProgress;
  final List<String> recommendations;

  AnalyticsData({
    required this.completionRate,
    required this.totalTimeSpent,
    required this.averageQuizScore,
    required this.skillProgress,
    required this.recommendations,
  });

  factory AnalyticsData.fromJson(Map<String, dynamic> json) {
    return AnalyticsData(
      completionRate: json['completionRate'] ?? 0.0,
      totalTimeSpent: json['totalTimeSpent'] ?? 0,
      averageQuizScore: json['averageQuizScore'] ?? 0.0,
      skillProgress: Map<String, double>.from(json['skillProgress'] ?? {}),
      recommendations: List<String>.from(json['recommendations'] ?? []),
    );
  }
}
