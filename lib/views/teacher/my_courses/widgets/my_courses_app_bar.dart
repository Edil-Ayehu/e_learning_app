import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:e_learning_app/core/theme/app_colors.dart';
import 'package:e_learning_app/routes/app_routes.dart';

class MyCoursesAppBar extends StatelessWidget {
  const MyCoursesAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 200,
      collapsedHeight: kToolbarHeight,
      toolbarHeight: kToolbarHeight,
      pinned: true,
      backgroundColor: AppColors.primary,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: AppColors.accent),
        onPressed: () => Get.back(),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.add, color: AppColors.accent),
          onPressed: () => Get.toNamed(AppRoutes.createCourse),
        ),
        const SizedBox(width: 8),
      ],
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: EdgeInsets.only(
          left: MediaQuery.of(context).size.width * 0.15,
          bottom: 16,
        ),
        title: Text(
          'My Courses',
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
    );
  }
}
