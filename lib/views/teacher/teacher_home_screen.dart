import 'package:flutter/material.dart';
import 'package:e_learning_app/core/theme/app_colors.dart';
import 'package:e_learning_app/routes/app_routes.dart';
import 'package:get/get.dart';

class TeacherHomeScreen extends StatelessWidget {
  const TeacherHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: AppColors.primary,
            actions: [
              IconButton(
                icon: const Icon(Icons.logout, color: AppColors.accent),
                onPressed: () => _showLogoutDialog(context),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'Teacher Dashboard',
                style: TextStyle(color: AppColors.accent),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryLight],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 1,
              ),
              delegate: SliverChildListDelegate([
                _buildDashboardCard(
                  'My Courses',
                  Icons.book,
                  () => Get.toNamed(AppRoutes.myCourses),
                ),
                _buildDashboardCard(
                  'Create Course',
                  Icons.add_circle,
                  () => Get.toNamed(AppRoutes.createCourse),
                ),
                _buildDashboardCard(
                  'Analytics',
                  Icons.analytics,
                  () => Get.toNamed(AppRoutes.teacherAnalytics),
                ),
                _buildDashboardCard(
                  'Student Progress',
                  Icons.people,
                  () => Get.toNamed(AppRoutes.studentProgress),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor:
            isDark ? AppColors.darkSurface : AppColors.lightSurface,
        title: Text(
          'Logout',
          style: theme.textTheme.titleLarge?.copyWith(
            color: AppColors.error,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Are you sure you want to logout?',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: isDark ? AppColors.accent : AppColors.secondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: theme.textTheme.labelLarge?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Get.offAllNamed(AppRoutes.login);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: AppColors.accent,
            ),
            child: Text(
              'Logout',
              style: theme.textTheme.labelLarge?.copyWith(
                color: AppColors.accent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  Widget _buildDashboardCard(String title, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.accent,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: AppColors.primary),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
