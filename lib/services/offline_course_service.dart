import 'dart:io';
import 'package:e_learning_app/models/offline_course.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class OfflineCourseService {
  static const String _offlineCoursesKey = 'offline_courses';

  Future<String> _downloadFile(String url, String filename) async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/$filename';
    final response = await http.get(Uri.parse(url));
    final file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }

  Future<void> downloadCourse(String courseId, String title, String description,
      String imageUrl, List<Map<String, dynamic>> lessons) async {
    try {
      // Download course image
      final imagePath = await _downloadFile(
          imageUrl, 'course_${courseId}_image${imageUrl.split('.').last}');

      final offlineLessons = <OfflineLesson>[];

      // Download lessons and resources
      for (var lesson in lessons) {
        final videoPath = await _downloadFile(lesson['videoUrl'],
            'course_${courseId}_lesson_${lesson['id']}.mp4');

        final resourcePaths = <String>[];
        for (var i = 0; i < lesson['resourceUrls'].length; i++) {
          final resourcePath = await _downloadFile(lesson['resourceUrls'][i],
              'course_${courseId}_lesson_${lesson['id']}_resource_$i.${lesson['resourceUrls'][i].split('.').last}');
          resourcePaths.add(resourcePath);
        }

        offlineLessons.add(OfflineLesson(
          id: lesson['id'],
          title: lesson['title'],
          videoUrl: lesson['videoUrl'],
          localVideoPath: videoPath,
          resourceUrls: List<String>.from(lesson['resourceUrls']),
          localResourcePaths: resourcePaths,
        ));
      }

      final offlineCourse = OfflineCourse(
        id: courseId,
        title: title,
        description: description,
        imageUrl: imageUrl,
        localImagePath: imagePath,
        lessons: offlineLessons,
        downloadedAt: DateTime.now(),
      );

      await _saveOfflineCourse(offlineCourse);
    } catch (e) {
      throw Exception('Failed to download course: $e');
    }
  }

  Future<void> _saveOfflineCourse(OfflineCourse course) async {
    final prefs = await SharedPreferences.getInstance();
    final courses = await getOfflineCourses();
    courses.add(course);
    await prefs.setString(_offlineCoursesKey,
        jsonEncode(courses.map((c) => c.toJson()).toList()));
  }

  Future<List<OfflineCourse>> getOfflineCourses() async {
    final prefs = await SharedPreferences.getInstance();
    final coursesJson = prefs.getString(_offlineCoursesKey);
    if (coursesJson == null) return [];
    return (jsonDecode(coursesJson) as List)
        .map((course) => OfflineCourse.fromJson(course))
        .toList();
  }

  Future<void> deleteCourse(String courseId) async {
    final courses = await getOfflineCourses();
    final courseToDelete =
        courses.firstWhere((course) => course.id == courseId);

    // Delete all downloaded files
    await File(courseToDelete.localImagePath).delete();
    for (var lesson in courseToDelete.lessons) {
      await File(lesson.localVideoPath).delete();
      for (var resourcePath in lesson.localResourcePaths) {
        await File(resourcePath).delete();
      }
    }

    // Remove from stored courses
    courses.removeWhere((course) => course.id == courseId);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_offlineCoursesKey,
        jsonEncode(courses.map((c) => c?.toJson()).toList()));
  }
}
