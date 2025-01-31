import 'package:e_learning_app/views/auth/forgot_password_screen.dart';
import 'package:e_learning_app/views/auth/login_screen.dart';
import 'package:e_learning_app/views/auth/register_screen.dart';
import 'package:e_learning_app/views/courses/analytics_dashboard_screen.dart';
import 'package:e_learning_app/views/courses/course_detail_screen.dart';
import 'package:e_learning_app/views/courses/course_list_screen.dart';
import 'package:e_learning_app/views/courses/lesson_screen.dart';
import 'package:e_learning_app/views/courses/payment_screen.dart';
import 'package:e_learning_app/views/help%20&%20support/help_support_screen.dart';
import 'package:e_learning_app/views/home/home_screen.dart';
import 'package:e_learning_app/views/notifications/notifications_screen.dart';
import 'package:e_learning_app/views/onboarding/onboarding_screen.dart';
import 'package:e_learning_app/views/profile/edit_profile_screen.dart';
import 'package:e_learning_app/views/profile/profile_screen.dart';
import 'package:e_learning_app/views/quiz/quiz_attempt_screen.dart';
import 'package:e_learning_app/views/quiz/quiz_list_screen.dart';
import 'package:e_learning_app/views/settings/settings_screen.dart';
import 'package:e_learning_app/views/splash/splash_screen.dart';
import 'package:get/get.dart';

class AppRoutes {
  // Auth Routes
  static const String splash = '/splash';
  static const String onboarding = '/onboarding';
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

  static const String notifications = '/notifications';
  static const String settings = '/settings';
  static const String helpSupport = '/help-support';
  static const String payment = '/payment';
  static const String analytics = '/analytics';

  // Route list for GetX navigation
  static final List<GetPage> pages = [
    GetPage(
      name: splash,
      page: () => const SplashScreen(),
    ),
    GetPage(
      name: onboarding,
      page: () => const OnboardingScreen(),
    ),
    GetPage(
      name: login,
      page: () => const LoginScreen(),
    ),
    GetPage(
      name: register,
      page: () => const RegisterScreen(),
    ),
    GetPage(
      name: forgotPassword,
      page: () => const ForgotPasswordScreen(),
    ),
    GetPage(
      name: home,
      page: () => HomeScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: courseList,
      page: () => const CourseListScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: quizList,
      page: () => const QuizListScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: profile,
      page: () => const ProfileScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: quizAttempt,
      page: () => const QuizAttemptScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: courseDetail,
      page: () => const CourseDetailScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: lesson,
      page: () => const LessonScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: editProfile,
      page: () => const EditProfileScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: notifications,
      page: () => const NotificationsScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: settings,
      page: () => const SettingsScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: helpSupport,
      page: () => const HelpSupportScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: payment,
      page: () => PaymentScreen(
        courseId: Get.parameters['id'] ?? '',
        courseName: Get.parameters['name'] ?? '',
        price: double.parse(Get.parameters['price'] ?? '0'),
      ),
    ),
    GetPage(
      name: analytics,
      page: () => AnalyticsDashboardScreen(),
      transition: Transition.rightToLeft,
    ),
  ];
}
