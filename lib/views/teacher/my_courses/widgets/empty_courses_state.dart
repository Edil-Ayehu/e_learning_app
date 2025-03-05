import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:e_learning_app/core/theme/app_colors.dart';
import 'package:e_learning_app/routes/app_routes.dart';

class EmptyCoursesState extends StatelessWidget {
  const EmptyCoursesState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.school_outlined,
            size: 64,
            color: AppColors.primary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No courses yet',
            style: TextStyle(
              fontSize: 20,
              color: AppColors.primary.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () => Get.toNamed(AppRoutes.createCourse),
            child: const Text('Create Your First Course'),
          ),
        ],
      ),
    );
  }
}
