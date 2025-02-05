import 'package:e_learning_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:e_learning_app/services/dummy_data_service.dart';
import 'package:get/get.dart';


class StudentProgressScreen extends StatelessWidget {
  const StudentProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final studentProgress = DummyDataService.getStudentProgress('inst_1');
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.lightBackground,
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverAppBar(
              expandedHeight: 200,
              collapsedHeight: kToolbarHeight + 48,
              toolbarHeight: kToolbarHeight,
              pinned: true,
              backgroundColor: AppColors.primary,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: AppColors.accent),
                onPressed: () => Get.back(),
              ),
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.15,
                  bottom: 64,
                ),
                title: Text(
                  'Student Progress',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: AppColors.accent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                background: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.primary, AppColors.primaryLight],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(48),
                child: TabBar(
                  indicatorColor: AppColors.accent,
                  labelColor: AppColors.accent,
                  unselectedLabelColor: AppColors.accent.withOpacity(0.7),
                  tabs: const [
                    Tab(text: 'Course Progress'),
                    Tab(text: 'Performance'),
                  ],
                ),
              ),
            ),
          ],
          body: TabBarView(
            children: [
              _buildCourseProgressTab(studentProgress),
              _buildPerformanceTab(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCourseProgressTab(List<StudentProgress> studentProgress) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: studentProgress.length,
      itemBuilder: (context, index) {
        final progress = studentProgress[index];
        return _buildStudentProgressCard(progress);
      },
    );
  }

  Widget _buildStudentProgressCard(StudentProgress progress) {
    // Get initials from student name
    final initials = progress.studentName
        .split(' ')
        .map((e) => e[0])
        .take(2)
        .join('')
        .toUpperCase();

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {}, // Add student detail navigation
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: AppColors.primary.withOpacity(0.1),
                      ),
                      child: Center(
                        child: Text(
                          initials,
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            progress.studentName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            progress.courseName,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${(progress.progress * 100).toInt()}%',
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress.progress,
                    backgroundColor: Colors.grey[200],
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(AppColors.primary),
                    minHeight: 8,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildMetric(
                        'Completed',
                        '${progress.completedLessons}/${progress.totalLessons}',
                        Icons.check_circle),
                    _buildMetric('Time Spent',
                        '${progress.averageTimePerLesson}h', Icons.access_time),
                    _buildMetric(
                        'Avg. Score',
                        '${(progress.averageScore * 100).toInt()}%',
                        Icons.analytics),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMetric(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primary, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildPerformanceTab() {
    final teacherStats = DummyDataService.getTeacherStats('inst_1');
    final engagement = teacherStats.studentEngagement;

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: engagement.courseCompletionRates.length,
      itemBuilder: (context, index) {
        final courseName = engagement.courseCompletionRates.keys.elementAt(index);
        final completionRate = engagement.courseCompletionRates[courseName] ?? 0.0;
        return _buildPerformanceCard(
          courseName: courseName,
          completionRate: completionRate,
          averageTimePerLesson: engagement.averageTimePerLesson,
          averageCompletionRate: engagement.averageCompletionRate,
        );
      },
    );
  }

  Widget _buildPerformanceCard({
    required String courseName,
    required double completionRate,
    required int averageTimePerLesson,
    required double averageCompletionRate,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.assessment, color: AppColors.primary),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        courseName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildPerformanceMetric('Course Completion', completionRate),
                const SizedBox(height: 12),
                _buildPerformanceMetric(
                    'Average Time per Lesson', averageTimePerLesson / 60),
                const SizedBox(height: 12),
                _buildPerformanceMetric(
                    'Overall Progress', averageCompletionRate),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPerformanceMetric(String label, double value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(color: Colors.grey[600]),
            ),
            Text(
              '${(value * 100).toInt()}%',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: value,
            backgroundColor: Colors.grey[200],
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
            minHeight: 8,
          ),
        ),
      ],
    );
  }
}
