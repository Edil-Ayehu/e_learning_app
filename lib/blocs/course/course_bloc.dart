import 'package:e_learning_app/blocs/course/course_event.dart';
import 'package:e_learning_app/blocs/course/course_state.dart';
import 'package:e_learning_app/controllers/auth_controller.dart';
import 'package:e_learning_app/repository/course_repository.dart';
import 'package:e_learning_app/services/offline_course_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CourseBloc extends Bloc<CourseEvent, CourseState> {
  final CourseRepository _courseRepository;
  final AuthController _authController;

  CourseBloc({
    required CourseRepository courseRepository,
    required AuthController authController,
  })  : _courseRepository = courseRepository,
        _authController = authController,
        super(CourseInitial()) {
    on<LoadCourses>(_onLoadCourses);
    on<LoadCourseDetail>(_onLoadCourseDetail);
    on<EnrollCourse>(_onEnrollCourse);
    on<LoadEnrolledCourses>(_onLoadEnrolledCourses);
    on<LoadOfflineCourses>(_onLoadOfflineCourses);
  }

  Future<void> _onLoadCourses(
    LoadCourses event,
    Emitter<CourseState> emit,
  ) async {
    emit(CourseLoading());
    try {
      final courses = await _courseRepository.getCourses(
        categoryId: event.categoryId,
      );
      emit(CoursesLoaded(courses));
    } catch (e) {
      emit(CourseError(e.toString()));
    }
  }

  Future<void> _onLoadCourseDetail(
    LoadCourseDetail event,
    Emitter<CourseState> emit,
  ) async {
    emit(CourseLoading());
    try {
      final course = await _courseRepository.getCourseDetail(event.courseId);
      emit(CourseDetailLoaded(course));
    } catch (e) {
      emit(CourseError(e.toString()));
    }
  }

  Future<void> _onEnrollCourse(
    EnrollCourse event,
    Emitter<CourseState> emit,
  ) async {
    try {
      final userId = _authController.firebaseUser?.uid;
      if (userId == null) {
        emit(CourseError('User not authenticated'));
        return;
      }
      await _courseRepository.enrollCourse(userId, event.courseId);
      add(LoadEnrolledCourses());
    } catch (e) {
      emit(CourseError(e.toString()));
    }
  }

  Future<void> _onLoadEnrolledCourses(
    LoadEnrolledCourses event,
    Emitter<CourseState> emit,
  ) async {
    emit(CourseLoading());
    try {
      final userId = _authController.firebaseUser?.uid;
      if (userId == null) {
        emit(CourseError('User not authenticated'));
        return;
      }
      final courses = await _courseRepository.getEnrolledCourses(userId);
      emit(EnrolledCoursesLoaded(courses));
    } catch (e) {
      emit(CourseError(e.toString()));
    }
  }

  Future<void> _onLoadOfflineCourses(
    LoadOfflineCourses event,
    Emitter<CourseState> emit,
  ) async {
    emit(CourseLoading());
    try {
      final offlineCourseService = OfflineCourseService();
      final courses = await offlineCourseService.getOfflineCourses();
      emit(OfflineCoursesLoaded(courses));
    } catch (e) {
      emit(CourseError(e.toString()));
    }
  }
}
