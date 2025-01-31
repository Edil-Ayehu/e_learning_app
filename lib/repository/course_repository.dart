import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_learning_app/models/course.dart';

class CourseRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Course>> getCourses({String? categoryId}) async {
    try {
      Query query = _firestore.collection('courses');
      
      if (categoryId != null) {
        query = query.where('categoryId', isEqualTo: categoryId);
      }
      
      final snapshot = await query.get();
      return snapshot.docs
          .map((doc) => Course.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to load courses: $e');
    }
  }

  Future<Course> getCourseDetail(String courseId) async {
    try {
      final doc = await _firestore.collection('courses').doc(courseId).get();
      if (!doc.exists) {
        throw Exception('Course not found');
      }
      return Course.fromJson(doc.data() as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to load course detail: $e');
    }
  }

  Future<void> enrollCourse(String userId, String courseId) async {
    try {
      await _firestore.collection('enrollments').add({
        'userId': userId,
        'courseId': courseId,
        'enrolledAt': DateTime.now().toIso8601String(),
        'progress': 0,
        'lastAccessedAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Failed to enroll in course: $e');
    }
  }

  Future<List<Course>> getEnrolledCourses(String userId) async {
    try {
      final enrollments = await _firestore
          .collection('enrollments')
          .where('userId', isEqualTo: userId)
          .get();

      final courseIds = enrollments.docs.map((doc) => doc.get('courseId')).toList();
      
      final courses = await Future.wait(
        courseIds.map((id) => getCourseDetail(id as String))
      );
      
      return courses;
    } catch (e) {
      throw Exception('Failed to load enrolled courses: $e');
    }
  }
}
