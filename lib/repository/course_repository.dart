import 'package:e_learning_app/models/course.dart';
import 'package:e_learning_app/services/dummy_data_service.dart';

class CourseRepository {
  Future<List<Course>> getCourses({String? categoryId}) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    
    if (categoryId != null) {
      return DummyDataService.getCoursesByCategory(categoryId);
    }
    return DummyDataService.courses;
  }

  Future<Course> getCourseDetail(String courseId) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));
    return DummyDataService.getCourseById(courseId);
  }

  Future<void> enrollCourse(String userId, String courseId) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    // In dummy implementation, we'll just return successfully
    return;
  }

  Future<List<Course>> getEnrolledCourses(String userId) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    // For dummy data, return first 2 courses as enrolled
    return DummyDataService.courses.take(2).toList();
  }
}
