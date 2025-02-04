import 'package:e_learning_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class StudentProgressScreen extends StatelessWidget {
  const StudentProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Student Progress'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Course Progress'),
              Tab(text: 'Performance'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildCourseProgressTab(),
            _buildPerformanceTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildCourseProgressTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 10, // Replace with actual student count
      itemBuilder: (context, index) {
        return _buildStudentProgressCard();
      },
    );
  }

  Widget _buildStudentProgressCard() {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.primary.withOpacity(0.1),
                  child: const Text('JS'),
                ),
                const SizedBox(width: 12),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'John Smith',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      'Flutter Development Course',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Progress'),
                Text('75%'),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: 0.75,
              backgroundColor: Colors.grey[200],
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPerformanceTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 10, // Replace with actual student count
      itemBuilder: (context, index) {
        return _buildPerformanceCard();
      },
    );
  }

  Widget _buildPerformanceCard() {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Similar to progress card but with quiz scores and completion rates
            // Add implementation here
          ],
        ),
      ),
    );
  }
}
