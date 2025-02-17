import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:e_learning_app/models/course.dart';
import 'package:e_learning_app/routes/app_routes.dart';
import 'package:e_learning_app/services/dummy_data_service.dart';
import 'package:e_learning_app/views/chat/chat_screen.dart';

class ActionButtons extends StatelessWidget {
  final Course course;

  const ActionButtons({
    super.key,
    required this.course,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              if (course.isPremium &&
                  !DummyDataService.isCourseUnlocked(course.id)) {
                // Navigate to payment screen if course is premium and not purchased
                Get.toNamed(
                  AppRoutes.payment,
                  arguments: {
                    'courseId': course.id,
                    'courseName': course.title,
                    'price': course.price,
                  },
                );
              } else {
                // Navigate to first lesson if course is free or already purchased
                Get.toNamed(
                  AppRoutes.lesson.replaceAll(':id', course.lessons.first.id),
                  parameters: {
                    'courseId': course.id,
                  },
                );
              }
            },
            icon: const Icon(Icons.play_circle),
            label: const Text('Start Learning'),
          ),
        ),
        // Only show chat button if course is not premium or if it's unlocked
        if (!course.isPremium ||
            DummyDataService.isCourseUnlocked(course.id)) ...[
          const SizedBox(width: 16),
          IconButton(
            icon: const Icon(Icons.chat),
            onPressed: () => Get.to(() => ChatScreen(
                  courseId: course.id,
                  instructorId: course.instructorId,
                  isTeacherView: false,
                )),
          ),
        ],
      ],
    );
  }
}
