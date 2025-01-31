import 'package:e_learning_app/models/course.dart';
import 'package:e_learning_app/models/offline_course.dart';

abstract class CourseState {}

class CourseInitial extends CourseState {}

class CourseLoading extends CourseState {}

class CoursesLoaded extends CourseState {
  final List<Course> courses;
  CoursesLoaded(this.courses);
}

class CourseDetailLoaded extends CourseState {
  final Course course;
  CourseDetailLoaded(this.course);
}

class EnrolledCoursesLoaded extends CourseState {
  final List<Course> enrolledCourses;
  EnrolledCoursesLoaded(this.enrolledCourses);
}

class OfflineCoursesLoaded extends CourseState {
  final List<OfflineCourse> offlineCourses;
  OfflineCoursesLoaded(this.offlineCourses);
}

class CourseError extends CourseState {
  final String message;
  CourseError(this.message);
}
