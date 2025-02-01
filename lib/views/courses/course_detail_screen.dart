import 'package:e_learning_app/core/theme/app_colors.dart';
import 'package:e_learning_app/routes/app_routes.dart';
import 'package:e_learning_app/services/dummy_data_service.dart';
import 'package:e_learning_app/views/widgets/course/review_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:e_learning_app/views/courses/payment_screen.dart';
import 'package:e_learning_app/services/offline_course_service.dart';

class CourseDetailScreen extends StatelessWidget {
  final String courseId;
  const CourseDetailScreen({
    super.key,
    required this.courseId,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final lastLesson = Get.parameters['lastLesson'];
    final id = Get.parameters['id'] ?? courseId;

    // If coming from in-progress, scroll to last lesson
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (lastLesson != null) {
        // Implement scroll to last lesson logic here
      }
    });

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            leading: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.accent.withOpacity(0.8),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: AppColors.primary,
                ),
                onPressed: () => Get.back(),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl: 'https://picsum.photos/800/400',
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Shimmer.fromColors(
                      baseColor: AppColors.primary.withOpacity(0.1),
                      highlightColor: AppColors.accent,
                      child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        color: Colors.white,
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: AppColors.primary.withOpacity(0.1),
                      child: const Icon(Icons.error),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          theme.colorScheme.background.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Advanced Mobile Development',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.person, color: theme.colorScheme.primary),
                      const SizedBox(width: 8),
                      Text('John Doe', style: theme.textTheme.bodyLarge),
                      const Spacer(),
                      Icon(Icons.star, color: theme.colorScheme.primary),
                      const SizedBox(width: 4),
                      Text('4.8 (2.5k reviews)',
                          style: theme.textTheme.bodyLarge),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildInfoCard(context),
                  const SizedBox(height: 24),
                  Text(
                    'Course Content',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildLessonsList(context),
                  const SizedBox(height: 24),
                  _buildReviewsSection(context),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Row(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '\$99.99',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
                Text('Lifetime Access', style: theme.textTheme.bodySmall),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: () => Get.to(
                  () => PaymentScreen(
                    courseId: Get.parameters['id'] ?? '',
                    courseName: 'Advanced Mobile Development',
                    price: 99.99,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Enroll Now'),
              ),
            ),
            IconButton(
              onPressed: () => _downloadCourse(context),
              icon: const Icon(Icons.download),
              tooltip: 'Download for offline access',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
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
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildInfoItem(
              context,
              Icons.access_time,
              '12 Hours',
              'Duration',
            ),
            _buildInfoItem(
              context,
              Icons.assignment,
              '10 Modules',
              'Lessons',
            ),
            _buildInfoItem(
              context,
              Icons.people,
              '2.5k',
              'Students',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
  ) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Icon(icon, color: theme.colorScheme.primary),
        const SizedBox(height: 8),
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          subtitle,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.secondary,
          ),
        ),
      ],
    );
  }

Widget _buildLessonsList(BuildContext context) {
  final course = DummyDataService.getCourseById(courseId);
  
  return ListView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemCount: course.lessons.length,
    itemBuilder: (context, index) {
      final lesson = course.lessons[index];
      return _LessonTile(
        title: lesson.title,
        duration: '${lesson.duration} min',
        isCompleted: index < 2,
        onTap: () => Get.toNamed(
          AppRoutes.lesson.replaceAll(':id', lesson.id),
          parameters: {'courseId': courseId},
        ),
      );
    },
  );
}

  Widget _buildReviewsSection(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Reviews',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton.icon(
              onPressed: () async {
                final result = await Get.dialog<Map<String, dynamic>>(
                  ReviewDialog(courseId: Get.parameters['id'] ?? ''),
                );
                if (result != null) {
                  // TODO: Handle review submission
                  Get.snackbar(
                    'Success',
                    'Thank you for your review!',
                    backgroundColor: AppColors.primary,
                    colorText: Colors.white,
                  );
                }
              },
              icon: const Icon(Icons.rate_review),
              label: const Text('Write a Review'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 3, // Replace with actual reviews count
          itemBuilder: (context, index) {
            return _buildReviewTile(
              context,
              name: 'User ${index + 1}',
              rating: 4.5,
              comment: 'Great course! Very informative and well-structured.',
              date: '2 days ago',
            );
          },
        ),
      ],
    );
  }

  Widget _buildReviewTile(
    BuildContext context, {
    required String name,
    required double rating,
    required String comment,
    required String date,
  }) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: AppColors.primary,
                child: Text(
                  name[0],
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        ...List.generate(5, (index) {
                          return Icon(
                            index < rating ? Icons.star : Icons.star_border,
                            size: 16,
                            color: AppColors.primary,
                          );
                        }),
                        const SizedBox(width: 8),
                        Text(
                          date,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppColors.secondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(comment),
        ],
      ),
    );
  }

  Future<void> _downloadCourse(BuildContext context) async {
    final offlineCourseService = OfflineCourseService();

    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      await offlineCourseService.downloadCourse(
        Get.parameters['id'] ?? '',
        'Advanced Mobile Development',
        'Learn the basics of Flutter framework and how to create beautiful, native applications for iOS and Android with a single codebase.',
        'https://picsum.photos/800/400',
        [
          {
            'id': '1',
            'title': 'Introduction to Flutter',
            'videoUrl': 'https://example.com/video1.mp4',
            'resourceUrls': [
              'https://example.com/slides1.pdf',
              'https://example.com/code1.zip',
            ],
          },
          // Add more lessons as needed
        ],
      );

      Navigator.pop(context); // Close loading dialog
      Get.snackbar(
        'Success',
        'Course downloaded successfully',
        backgroundColor: AppColors.primary,
        colorText: Colors.white,
      );
    } catch (e) {
      Navigator.pop(context); // Close loading dialog
      Get.snackbar(
        'Error',
        'Failed to download course',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}

class _LessonTile extends StatelessWidget {
  final String title;
  final String duration;
  final bool isCompleted;
  final VoidCallback onTap;

  const _LessonTile({
    required this.title,
    required this.duration,
    required this.isCompleted,
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
            : theme.colorScheme.secondary.withOpacity(0.2),
        child: Icon(
          isCompleted ? Icons.check : Icons.play_arrow,
          color: isCompleted
              ? theme.colorScheme.onPrimary
              : theme.colorScheme.secondary,
        ),
      ),
      title: Text(title),
      subtitle: Text(duration),
      trailing: const Icon(Icons.chevron_right),
    );
  }
}
