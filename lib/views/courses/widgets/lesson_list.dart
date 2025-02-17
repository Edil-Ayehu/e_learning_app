import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:e_learning_app/core/theme/app_colors.dart';
import 'package:e_learning_app/routes/app_routes.dart';
import 'package:e_learning_app/services/dummy_data_service.dart';

class LessonsList extends StatelessWidget {
  final String courseId;
  final bool isUnlocked;
  final VoidCallback? onLessonComplete;

  const LessonsList({
    super.key,
    required this.courseId,
    required this.isUnlocked,
    this.onLessonComplete,
  });

  @override
  Widget build(BuildContext context) {
    final course = DummyDataService.getCourseById(courseId);

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: course.lessons.length,
      itemBuilder: (context, index) {
        final lesson = course.lessons[index];
        final isLocked = !lesson.isPreview && 
            (index > 0 && !DummyDataService.isLessonCompleted(course.id, course.lessons[index - 1].id));

        return _LessonTile(
          title: lesson.title,
          duration: '${lesson.duration} min',
          isCompleted: DummyDataService.isLessonCompleted(course.id, lesson.id),
          isLocked: isLocked,
          isUnlocked: isUnlocked,
          onTap: () async {
            if (course.isPremium && !isUnlocked) {
              Get.snackbar(
                'Premium Course',
                'Please purchase this course to access all lessons',
                backgroundColor: AppColors.primary,
                colorText: Colors.white,
                duration: const Duration(seconds: 3),
              );
            } else if (isLocked) {
              Get.snackbar(
                'Lesson Locked',
                'Please complete the previous lesson first',
                backgroundColor: Colors.red,
                colorText: Colors.white,
              );
            } else {
              final result = await Get.toNamed(
                AppRoutes.lesson.replaceAll(':id', lesson.id),
                parameters: {'courseId': courseId},
              );
              
              if (result == true) {
                onLessonComplete?.call();
              }
            }
          },
        );
      },
    );
  }
}

class _LessonTile extends StatelessWidget {
  final String title;
  final String duration;
  final bool isCompleted;
  final bool isLocked;
  final bool isUnlocked;
  final VoidCallback onTap;

  const _LessonTile({
    required this.title,
    required this.duration,
    required this.isCompleted,
    required this.isLocked,
    required this.isUnlocked,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        backgroundColor: isCompleted
            ? theme.colorScheme.primary
            : isLocked
                ? theme.colorScheme.secondary.withOpacity(0.1)
                : theme.colorScheme.secondary.withOpacity(0.2),
        child: Icon(
          isCompleted
              ? Icons.check
              : isLocked
                  ? Icons.lock
                  : Icons.play_arrow,
          color: isCompleted
              ? theme.colorScheme.onPrimary
              : isLocked
                  ? theme.colorScheme.secondary
                  : theme.colorScheme.secondary,
        ),
      ),
      title: Text(
        title,
        style: theme.textTheme.bodyLarge?.copyWith(
          color: isLocked ? theme.colorScheme.secondary : null,
        ),
      ),
      subtitle: Text(
        duration,
        style: theme.textTheme.bodySmall?.copyWith(
          color: isLocked ? theme.colorScheme.secondary : null,
        ),
      ),
      trailing: const Icon(Icons.chevron_right),
    );
  }
}
