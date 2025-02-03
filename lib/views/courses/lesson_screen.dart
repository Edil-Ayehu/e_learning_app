import 'package:e_learning_app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:e_learning_app/core/theme/app_colors.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:e_learning_app/services/dummy_data_service.dart';

class LessonScreen extends StatefulWidget {
  final String lessonId;
  const LessonScreen({super.key, required this.lessonId});

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    try {
      final courseId = Get.parameters['courseId'];
      debugPrint('CourseId: $courseId');

      if (courseId == null) {
        debugPrint('No courseId found in parameters');
        setState(() => _isLoading = false);
        return;
      }

      final course = DummyDataService.getCourseById(courseId);
      debugPrint('Course found: ${course.title}');

      final lesson = course.lessons.firstWhere(
        (lesson) => lesson.id == widget.lessonId,
        orElse: () => course.lessons.first,
      );

      // Check if lesson is locked
      final lessonIndex = course.lessons.indexOf(lesson);
      final previousLessonsCompleted = course.lessons
          .sublist(0, lessonIndex)
          .every((lesson) => lesson.isCompleted);

      if (!previousLessonsCompleted && !lesson.isPreview) {
        Get.snackbar(
          'Lesson Locked',
          'Please complete the previous lessons first',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        Get.back();
        return;
      }

      print('Video URL: ${lesson.videoUrl}');

      _videoPlayerController = VideoPlayerController.network(lesson.videoUrl);

      // Initialize the video controller
      await _videoPlayerController.initialize();

      // Create and configure the Chewie Controller
      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController
          ..addListener(() {
            if (_videoPlayerController.value.position >=
                _videoPlayerController.value.duration) {
              _markLessonAsCompleted();
            }
          }),
        autoPlay: true,
        looping: false,
        aspectRatio: 16 / 9,
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Text(
              'Error: $errorMessage',
              style: const TextStyle(color: Colors.white),
            ),
          );
        },
        showControls: true,
        allowFullScreen: true,
        showOptions: false,
        allowPlaybackSpeedChanging: false,
      );

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error initializing video: $e');
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _markLessonAsCompleted() {
    final courseId = Get.parameters['courseId'];
    if (courseId != null) {
      final course = DummyDataService.getCourseById(courseId);
      final lessonIndex = course.lessons.indexWhere((l) => l.id == widget.lessonId);
      
      if (lessonIndex != -1) {
        // Update the lesson completion status
        course.lessons[lessonIndex] = course.lessons[lessonIndex].copyWith(
          isCompleted: true,
        );

        // Check if there's a next lesson
        if (lessonIndex < course.lessons.length - 1) {
          final nextLesson = course.lessons[lessonIndex + 1];
          // Navigate to the next lesson with both lessonId and courseId
          Get.offNamed(
            AppRoutes.lesson,
            arguments: nextLesson.id,
            parameters: {'courseId': courseId},
          );
        } else {
          // If this was the last lesson, go back to course details
          Get.offNamed(
            AppRoutes.courseDetail.replaceAll(':id', courseId),
            arguments: courseId,
          );
          Get.snackbar(
            'Congratulations!',
            'You have completed all lessons in this course',
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        }
      }
    }
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Column(
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: _isLoading
                ? Container(
                    color: theme.colorScheme.surface,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : _chewieController != null
                    ? Chewie(controller: _chewieController!)
                    : Container(
                        color: theme.colorScheme.surface,
                        child: const Center(
                          child: Text('Error loading video'),
                        ),
                      ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Introduction to Flutter',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 16,
                        color: theme.colorScheme.secondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '30 minutes',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.secondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Description',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Learn the basics of Flutter framework and how to create beautiful, native applications for iOS and Android with a single codebase.',
                    style: theme.textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Resources',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildResourceTile(
                    context,
                    'Presentation Slides',
                    Icons.picture_as_pdf,
                    () {},
                  ),
                  _buildResourceTile(
                    context,
                    'Source Code',
                    Icons.code,
                    () {},
                  ),
                  _buildResourceTile(
                    context,
                    'Exercise Files',
                    Icons.folder,
                    () {},
                  ),
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton.icon(
              onPressed: () {
                final currentId = Get.parameters['id'];
                if (currentId != null) {
                  final prevId = (int.parse(currentId) - 1).toString();
                  Get.toNamed(AppRoutes.lesson.replaceAll(':id', prevId));
                }
              },
              icon: const Icon(Icons.arrow_back),
              label: const Text('Previous'),
            ),
            TextButton.icon(
              onPressed: () {
                final currentId = Get.parameters['id'];
                if (currentId != null) {
                  final nextId = (int.parse(currentId) + 1).toString();
                  Get.toNamed(AppRoutes.lesson.replaceAll(':id', nextId));
                }
              },
              icon: const Icon(Icons.arrow_forward),
              label: const Text('Next'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResourceTile(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: AppColors.primary,
                  size: 24,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ),
                Icon(
                  Icons.download,
                  color: AppColors.secondary,
                  size: 24,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
