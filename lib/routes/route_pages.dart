import 'package:e_learning_app/models/quiz.dart';
import 'package:e_learning_app/models/quiz_attempt.dart';
import 'package:e_learning_app/routes/app_routes.dart';
import 'package:e_learning_app/views/auth/forgot_password_screen.dart';
import 'package:e_learning_app/views/auth/login_screen.dart';
import 'package:e_learning_app/views/auth/register_screen.dart';
import 'package:e_learning_app/views/chat/chat_list_screen.dart';
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
import 'package:e_learning_app/views/quiz/quiz_result_screen.dart';
import 'package:e_learning_app/views/settings/privacy_policy_screen.dart';
import 'package:e_learning_app/views/settings/settings_screen.dart';
import 'package:e_learning_app/views/settings/terms_conditions_screen.dart';
import 'package:e_learning_app/views/splash/splash_screen.dart';
import 'package:e_learning_app/views/teacher/create_course_screen.dart';
import 'package:e_learning_app/views/teacher/my_courses_screen.dart';
import 'package:e_learning_app/views/teacher/student_progress_screen.dart';
import 'package:e_learning_app/views/teacher/teacher_analytics_screen.dart';
import 'package:e_learning_app/views/teacher/teacher_home_screen.dart';
import 'package:get/get.dart';

class AppPages {
  static final List<GetPage> pages = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashScreen(),
    ),
    GetPage(
      name: AppRoutes.onboarding,
      page: () => const OnboardingScreen(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginScreen(),
    ),
    GetPage(
      name: AppRoutes.payment,
      page: () => PaymentScreen(
        courseId: Get.arguments['courseId'] as String,
        courseName: Get.arguments['courseName'] as String,
        price: Get.arguments['price'] as double,
      ),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => HomeScreen(
        initialIndex: Get.arguments?['initialIndex'] as int?,
      ),
    ),
    GetPage(
      name: AppRoutes.register,
      page: () => const RegisterScreen(),
    ),
    GetPage(
      name: AppRoutes.forgotPassword,
      page: () => const ForgotPasswordScreen(),
    ),
    GetPage(
      name: AppRoutes.analytics,
      page: () => AnalyticsDashboardScreen(),
    ),
    GetPage(
      name: AppRoutes.profile,
      page: () => const ProfileScreen(),
    ),
    GetPage(
      name: AppRoutes.editProfile,
      page: () => const EditProfileScreen(),
    ),
    GetPage(
      name: AppRoutes.notifications,
      page: () => const NotificationsScreen(),
    ),
    GetPage(
      name: AppRoutes.settings,
      page: () => const SettingsScreen(),
    ),
    GetPage(
      name: AppRoutes.helpSupport,
      page: () => const HelpSupportScreen(),
    ),
    GetPage(
      name: AppRoutes.privacyPolicy,
      page: () => const PrivacyPolicyScreen(),
    ),
    GetPage(
      name: AppRoutes.termsConditions,
      page: () => const TermsConditionsScreen(),
    ),
    GetPage(
      name: AppRoutes.quizList,
      page: () => const QuizListScreen(),
    ),
    GetPage(
      name: '/quiz/:id',
      page: () => QuizAttemptScreen(
        quizId: Get.parameters['id'] ?? '',
      ),
    ),
    GetPage(
      name: AppRoutes.quizResult,
      page: () => QuizResultScreen(
        attempt: Get.arguments['attempt'] as QuizAttempt,
        quiz: Get.arguments['quiz'] as Quiz,
      ),
    ),
    GetPage(
      name: '/course/:id',
      page: () => CourseDetailScreen(
        courseId: Get.parameters['id'] ?? '',
      ),
    ),
    GetPage(
      name: AppRoutes.courseList,
      page: () => CourseListScreen(
        categoryId: Get.arguments?['category'] as String?,
        categoryName: Get.arguments?['categoryName'] as String?,
      ),
    ),
    GetPage(
      name: AppRoutes.lesson,
      page: () => LessonScreen(
        lessonId: Get.parameters['id'] ?? '',
      ),
    ),
    GetPage(
      name: AppRoutes.teacherHome,
      page: () => const TeacherHomeScreen(),
    ),
    GetPage(
      name: AppRoutes.myCourses,
      page: () => const MyCoursesScreen(),
    ),
    GetPage(
      name: AppRoutes.createCourse,
      page: () => const CreateCourseScreen(),
    ),
    GetPage(
      name: AppRoutes.teacherAnalytics,
      page: () => const TeacherAnalyticsScreen(),
    ),
    GetPage(
      name: AppRoutes.studentProgress,
      page: () => const StudentProgressScreen(),
    ),
    GetPage(
      name: AppRoutes.teacherChats,
      page: () => const ChatListScreen(),
    ),
  ];
}
