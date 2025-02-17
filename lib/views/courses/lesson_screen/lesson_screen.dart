import 'package:e_learning_app/controllers/video_controller.dart';
import 'package:e_learning_app/models/course.dart';
import 'package:e_learning_app/views/courses/lesson_screen/widgets/certificate_dialog.dart';
import 'package:e_learning_app/views/courses/lesson_screen/widgets/resource_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:e_learning_app/core/theme/app_colors.dart';
import 'package:chewie/chewie.dart';
import 'package:e_learning_app/services/dummy_data_service.dart';

class LessonScreen extends StatefulWidget {
  final String lessonId;
  const LessonScreen({super.key, required this.lessonId});

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  late final LessonVideoController _videoController;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _videoController = LessonVideoController(
      lessonId: widget.lessonId,
      onLoadingChanged: (loading) {
        setState(() => _isLoading = loading);
      },
      onCertificateEarned: (course) {
        if (mounted) {
          _showCertificateDialog(context, course);
        }
      },
    );
    _videoController.initializeVideo();
  }

  void _showCertificateDialog(BuildContext context, Course course) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return CertificateDialog(
          course: course,
          onDownload: () => _downloadCertificate(course),
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
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final courseId = Get.parameters['courseId'];
    final course =
        courseId != null ? DummyDataService.getCourseById(courseId) : null;
    final isUnlocked =
        courseId != null ? DummyDataService.isCourseUnlocked(courseId) : false;

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
                : _videoController.chewieController != null
                    ? Chewie(controller: _videoController.chewieController!)
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
                    ...lesson.resources.map((resource) => ResourceTile(
                          title: resource.title,
                          icon: _getIconForResourceType(resource.type),
                          onTap: () {}, // TODO: Implement resource download
                        )),
                  ],
                ),
              ),
            ),
        ],
      ),
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
}
