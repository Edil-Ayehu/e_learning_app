import 'package:get/get.dart';

class AppRoutes {
  // Auth Routes
  static const String splash = '/splash';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  
  // Course Routes
  static const String home = '/home';
  static const String courseList = '/courses';
  static const String courseDetail = '/course/:id';
  static const String lesson = '/lesson/:id';
  
  // Quiz Routes
  static const String quizList = '/quizzes';
  static const String quizAttempt = '/quiz/:id';
  
  // Profile Routes
  static const String profile = '/profile';
  static const String editProfile = '/profile/edit';

  // Route list for GetX navigation
  static final List<GetPage> pages = [
    // GetPage(
    //   name: splash,
    //   page: () => const SplashScreen(),
    // ),
    // GetPage(
    //   name: login,
    //   page: () => const LoginScreen(),
    // ),
    // GetPage(
    //   name: register,
    //   page: () => const RegisterScreen(),
    // ),
    // GetPage(
    //   name: forgotPassword,
    //   page: () => const ForgotPasswordScreen(),
    // ),
    // GetPage(
    //   name: home,
    //   page: () => const HomeScreen(),
    // ),
    // GetPage(
    //   name: courseList,
    //   page: () => const CourseListScreen(),
    // ),
    // GetPage(
    //   name: courseDetail,
    //   page: () => const CourseDetailScreen(),
    // ),
    // GetPage(
    //   name: lesson,
    //   page: () => const LessonScreen(),
    // ),
    // GetPage(
    //   name: quizList,
    //   page: () => const QuizListScreen(),
    // ),
    // GetPage(
    //   name: quizAttempt,
    //   page: () => const QuizAttemptScreen(),
    // ),
    // GetPage(
    //   name: profile,
    //   page: () => const ProfileScreen(),
    // ),
    // GetPage(
    //   name: editProfile,
    //   page: () => const EditProfileScreen(),
    // ),
  ];
}