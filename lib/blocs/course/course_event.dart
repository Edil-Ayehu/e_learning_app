abstract class CourseEvent {}

class LoadCourses extends CourseEvent {
  final String? categoryId;
  LoadCourses({this.categoryId});
}

class LoadCourseDetail extends CourseEvent {
  final String courseId;
  LoadCourseDetail(this.courseId);
}

class EnrollCourse extends CourseEvent {
  final String courseId;
  EnrollCourse(this.courseId);
}

class LoadEnrolledCourses extends CourseEvent {}

class DownloadCourse extends CourseEvent {
  final String courseId;
  DownloadCourse(this.courseId);
}

class LoadOfflineCourses extends CourseEvent {}
