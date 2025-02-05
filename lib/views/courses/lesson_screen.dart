import 'package:e_learning_app/models/course.dart';
import 'package:e_learning_app/models/lesson.dart';
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
  VideoPlayerController? _videoPlayerController;
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

      // Check if course is premium and not purchased
      if (course.isPremium && !DummyDataService.isCourseUnlocked(courseId)) {
        setState(() => _isLoading = false); // Set loading to false before showing dialog
        
        Get.back(); // Go back to course detail screen
        
        Get.toNamed(
          AppRoutes.payment,
          arguments: {
            'courseId': courseId,
            'courseName': course.title,
            'price': course.price,
          },
        );
        
        return;
      }

      final lesson = course.lessons.firstWhere(
        (lesson) => lesson.id == widget.lessonId,
        orElse: () => course.lessons.first,
      );

      // Initialize video only if the course is unlocked or not premium
      _videoPlayerController = VideoPlayerController.network(lesson.videoStreamUrl);
      await _videoPlayerController?.initialize();

      // Add video completion listener
      _videoPlayerController?.addListener(_onVideoProgressChanged);

      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController!,
        autoPlay: true,
        looping: false,
        aspectRatio: 16 / 9,
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Text(
              'Error: Unable to load video content',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.red,
                  ),
            ),
          );
        },
      );

      setState(() => _isLoading = false);
    } catch (e) {
      debugPrint('Error initializing video: $e');
      setState(() => _isLoading = false);
    }
  }

  void _onVideoProgressChanged() {
    if (_videoPlayerController != null && 
        _videoPlayerController!.value.position >= _videoPlayerController!.value.duration) {
      // Video has completed
      _markLessonAsCompleted();
      // Remove listener to prevent multiple calls
      _videoPlayerController?.removeListener(_onVideoProgressChanged);
    }
  }

  void _markLessonAsCompleted() async {
    final courseId = Get.parameters['courseId'];
    if (courseId != null) {
      final course = DummyDataService.getCourseById(courseId);
      final lessonIndex = course.lessons.indexWhere((l) => l.id == widget.lessonId);

      if (lessonIndex != -1) {
        // Mark current lesson as completed
        DummyDataService.updateLessonStatus(
          courseId,
          widget.lessonId,
          isCompleted: true,
        );

        // Unlock next lesson if available
        if (lessonIndex < course.lessons.length - 1) {
          DummyDataService.updateLessonStatus(
            courseId,
            course.lessons[lessonIndex + 1].id,
            isLocked: false,
          );
        }
        

        final isLastLesson = lessonIndex == course.lessons.length - 1;
        final allLessonsCompleted = DummyDataService.isCourseCompleted(courseId);

        Get.back(result: true); // Return with result to trigger rebuild

        if (isLastLesson && allLessonsCompleted) {
          if (mounted) {
            _showCertificateDialog(context, course);
          }
        } else {
          Get.snackbar(
            'Lesson Completed!',
            'You can now proceed to the next lesson',
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        }
      }
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

  @override
  void dispose() {
    _videoPlayerController?.removeListener(_onVideoProgressChanged);
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final courseId = Get.parameters['courseId'];
    final course = courseId != null ? DummyDataService.getCourseById(courseId) : null;
    final isUnlocked = courseId != null ? DummyDataService.isCourseUnlocked(courseId) : false;

    if (course == null) {
      return const Scaffold(
        body: Center(
          child: Text('Course not found'),
        ),
      );
    }

    if (course.isPremium && !isUnlocked) {
      return const Scaffold(
        body: Center(
          child: Text('Please purchase this course to access the content'),
        ),
      );
    }

    final lesson = course.lessons.firstWhere(
      (l) => l.id == widget.lessonId,
      orElse: () => course.lessons.first,
    );

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
          if (lesson != null)
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lesson.title,
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
                          '${lesson.duration} minutes',
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
                      lesson.description,
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
                    ...lesson.resources.map((resource) => _buildResourceTile(
                          context,
                          resource.title,
                          _getIconForResourceType(resource.type),
                          () {}, // TODO: Implement resource download
                        )),
                  ],
                ),
              ),
            ),
        ],
      ),
      // bottomNavigationBar: _buildNavigationBar(context, course, lesson),
    );
  }

  IconData _getIconForResourceType(String type) {
    switch (type.toLowerCase()) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'zip':
        return Icons.folder_zip;
      default:
        return Icons.insert_drive_file;
    }
  }

  Widget _buildNavigationBar(
      BuildContext context, Course? course, Lesson? lesson) {
    if (course == null || lesson == null) return const SizedBox.shrink();

    final lessonIndex = course.lessons.indexOf(lesson);
    final hasPrevious = lessonIndex > 0;
    final hasNext = lessonIndex < course.lessons.length - 1;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
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
            onPressed: hasPrevious
                ? () => Get.toNamed(
                      AppRoutes.lesson.replaceAll(
                          ':id', course.lessons[lessonIndex - 1].id),
                      parameters: {'courseId': course.id},
                    )
                : null,
            icon: const Icon(Icons.arrow_back),
            label: const Text('Previous'),
          ),
          TextButton.icon(
            onPressed: hasNext
                ? () => Get.toNamed(
                      AppRoutes.lesson.replaceAll(
                          ':id', course.lessons[lessonIndex + 1].id),
                      parameters: {'courseId': course.id},
                    )
                : null,
            icon: const Icon(Icons.arrow_forward),
            label: const Text('Next'),
          ),
        ],
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
