import 'package:e_learning_app/core/theme/app_colors.dart';
import 'package:e_learning_app/models/course.dart';
import 'package:e_learning_app/routes/app_routes.dart';
import 'package:e_learning_app/services/dummy_data_service.dart';
import 'package:e_learning_app/views/widgets/course/review_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:e_learning_app/services/offline_course_service.dart';
import 'package:e_learning_app/views/chat/chat_screen.dart';

class CourseDetailScreen extends StatefulWidget {
  final String courseId;
  const CourseDetailScreen({
    super.key,
    required this.courseId,
  });

  @override
  State<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final lastLesson = Get.parameters['lastLesson'];
    final id = Get.parameters['id'] ?? widget.courseId;
    final course = DummyDataService.getCourseById(id);
    final isCompleted = DummyDataService.isCourseCompleted(course.id);
    final isUnlocked = DummyDataService.isCourseUnlocked(widget.courseId);

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
                    imageUrl: course.imageUrl,
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
                    course.title,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text(
                        course.rating.toString(),
                        style: theme.textTheme.bodyMedium,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '(${course.reviewCount} reviews)',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.secondary,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '\$${course.price}',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    course.description,
                    style: theme.textTheme.bodyLarge,
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
                  _buildLessonsList(context, isUnlocked),
                  const SizedBox(height: 24),
                  _buildReviewsSection(context),
                  const SizedBox(height: 16),
                  _buildActionButtons(course),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: course.isPremium && !isUnlocked
          ? Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.scaffoldBackgroundColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () {
                  Get.toNamed(
                    AppRoutes.payment,
                    arguments: {
                      'courseId': widget.courseId,
                      'courseName': course.title,
                      'price': course.price,
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.all(16),
                ),
                child: Text('Buy Now for \$${course.price}'),
              ),
            )
          : null,
    );
  }

  Widget _buildInfoCard(BuildContext context) {
    final theme = Theme.of(context);
    final course = DummyDataService.getCourseById(widget.courseId);

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
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildInfoItem(
                  context,
                  Icons.people,
                  '${course.enrollmentCount}+',
                  'Students',
                ),
                _buildInfoItem(
                  context,
                  Icons.star,
                  course.rating.toString(),
                  '${course.reviewCount} Reviews',
                ),
                _buildInfoItem(
                  context,
                  Icons.library_books,
                  '${course.lessons.length}',
                  'Lessons',
                ),
                _buildInfoItem(
                  context,
                  Icons.signal_cellular_alt,
                  course.level,
                  'Level',
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (course.requirements.isNotEmpty) ...[
              _buildSectionTitle(context, 'Requirements'),
              const SizedBox(height: 8),
              ...course.requirements.map((requirement) => _buildRequirementItem(context, requirement)),
              const SizedBox(height: 16),
            ],
            if (course.whatYouWillLearn.isNotEmpty) ...[
              _buildSectionTitle(context, 'What you\'ll learn'),
              const SizedBox(height: 8),
              ...course.whatYouWillLearn.map((item) => _buildLearningItem(context, item)),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(
    BuildContext context,
    IconData icon,
    String value,
    String label,
  ) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Icon(icon, color: AppColors.primary),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: AppColors.secondary,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    final theme = Theme.of(context);
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildRequirementItem(BuildContext context, String requirement) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(color: AppColors.primary)),
          Expanded(
            child: Text(
              requirement,
              style: theme.textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLearningItem(BuildContext context, String item) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.check_circle,
            color: AppColors.primary,
            size: 16,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              item,
              style: theme.textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLessonsList(BuildContext context, bool isUnlocked) {
    final course = DummyDataService.getCourseById(widget.courseId);

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
                parameters: {'courseId': widget.courseId},
              );
              
              if (result == true) {
                setState(() {}); // Rebuild screen after lesson completion
              }
            }
          },
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

  void _showCertificateDialog(BuildContext context, Course course) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Congratulations! 🎉'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.workspace_premium,
                size: 64,
                color: AppColors.primary,
              ),
              const SizedBox(height: 16),
              Text(
                'You have completed all lessons in "${course.title}"',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'You can now download your certificate of completion!',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.secondary),
              ),
            ],
          ),
          actions: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                    ),
                    onPressed: () => Get.back(),
                    child: const Text(
                      'Later',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 12),
                      backgroundColor: AppColors.primary,
                    ),
                    onPressed: () {
                      Get.back();
                      _downloadCertificate(course);
                    },
                    child: const Text(
                      'Get Certificate',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  void _downloadCertificate(Course course) {
    // Here you would implement the actual certificate generation and download
    // For now, we'll just show a success message
    Get.snackbar(
      'Certificate Ready!',
      'Your certificate for ${course.title} has been generated.',
      backgroundColor: AppColors.primary,
      colorText: Colors.white,
      duration: const Duration(seconds: 5),
    );
  }

  Widget _buildActionButtons(Course course) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              if (course.isPremium && !DummyDataService.isCourseUnlocked(course.id)) {
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
        if (!course.isPremium || DummyDataService.isCourseUnlocked(course.id)) ...[
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
