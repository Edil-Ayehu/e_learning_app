import 'package:e_learning_app/core/theme/app_colors.dart';
import 'package:e_learning_app/models/analytics_data.dart';
import 'package:e_learning_app/services/analytics_service.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';

class AnalyticsDashboardScreen extends StatelessWidget {
  AnalyticsDashboardScreen({super.key});

  final _analyticsService = AnalyticsService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Learning Analytics'),
        backgroundColor: AppColors.primary,
      ),
      body: FutureBuilder<AnalyticsData>(
        future: _analyticsService.getUserAnalytics('current_user_id'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData) {
            return const Center(child: Text('No data available'));
          }

          final analytics = snapshot.data!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProgressOverview(analytics),
                const SizedBox(height: 24),
                _buildSkillsChart(analytics),
                const SizedBox(height: 24),
                _buildAIRecommendations(analytics),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProgressOverview(AnalyticsData analytics) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Overall Progress',
              style: Get.textTheme.titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildProgressItem(
                  'Completion',
                  '${(analytics.completionRate * 100).toInt()}%',
                  Icons.check_circle,
                ),
                _buildProgressItem(
                  'Time Spent',
                  '${(analytics.totalTimeSpent / 3600).toStringAsFixed(1)}h',
                  Icons.access_time,
                ),
                _buildProgressItem(
                  'Quiz Score',
                  '${analytics.averageQuizScore.toInt()}%',
                  Icons.quiz,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primary, size: 32),
        const SizedBox(height: 8),
        Text(
          value,
          style: Get.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        Text(label, style: Get.textTheme.bodyMedium),
      ],
    );
  }

  Widget _buildSkillsChart(AnalyticsData analytics) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Skills Progress',
              style: Get.textTheme.titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: RadarChart(
                RadarChartData(
                  radarShape: RadarShape.polygon,
                  ticksTextStyle: const TextStyle(color: Colors.transparent),
                  gridBorderData:
                      BorderSide(color: AppColors.primary.withOpacity(0.2)),
                  tickBorderData:
                      BorderSide(color: AppColors.primary.withOpacity(0.2)),
                  dataSets: [
                    RadarDataSet(
                      fillColor: AppColors.primary.withOpacity(0.2),
                      borderColor: AppColors.primary,
                      entryRadius: 2,
                      dataEntries: analytics.skillProgress.entries
                          .map((e) => RadarEntry(value: e.value))
                          .toList(),
                    ),
                  ],
                  titleTextStyle: Get.textTheme.bodySmall!,
                  getTitle: (index, angle) {
                    return RadarChartTitle(
                      text: analytics.skillProgress.keys.elementAt(index),
                      angle: angle,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAIRecommendations(AnalyticsData analytics) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'AI Recommendations',
              style: Get.textTheme.titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...analytics.recommendations.map((recommendation) => ListTile(
                  leading:
                      const Icon(Icons.lightbulb, color: AppColors.primary),
                  title: Text(recommendation),
                  trailing: IconButton(
                    icon: const Icon(Icons.arrow_forward),
                    onPressed: () {
                      // TODO: Navigate to recommended course/quiz
                    },
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
