import 'package:e_learning_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:e_learning_app/services/dummy_data_service.dart';
import 'package:e_learning_app/views/teacher/student_progress/widgets/student_progress_card.dart';
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
        return StudentProgressCard(progress: progress);
      },
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
