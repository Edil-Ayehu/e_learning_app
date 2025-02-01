import 'package:e_learning_app/blocs/course/course_bloc.dart';
import 'package:e_learning_app/blocs/profile/profile_bloc.dart';
import 'package:e_learning_app/config/firebase_config.dart';
import 'package:e_learning_app/core/theme/app_theme.dart';
import 'package:e_learning_app/data/services/storage_service.dart';
import 'package:e_learning_app/repository/course_repository.dart';
import 'package:e_learning_app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_learning_app/blocs/font/font_bloc.dart';
import 'package:e_learning_app/blocs/font/font_state.dart';
import 'package:e_learning_app/blocs/auth/auth_bloc.dart';
import 'package:e_learning_app/blocs/quiz/quiz_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseConfig.init();
  // await GetStorage.init();
  await StorageService.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(),
        ),
        BlocProvider<QuizBloc>(
          create: (context) => QuizBloc(),
        ),
        BlocProvider<FontBloc>(
          create: (context) => FontBloc(),
        ),
        BlocProvider<CourseBloc>(
          create: (context) => CourseBloc(
            courseRepository: CourseRepository(),
            authBloc: context.read<AuthBloc>(),
          ),
        ),
        BlocProvider<ProfileBloc>(
          create: (context) => ProfileBloc(
            authBloc: context.read<AuthBloc>(),
          ),
        ),
      ],
      child: BlocBuilder<FontBloc, FontState>(
        builder: (context, fontState) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'E-Learning App',
            theme: AppTheme.getLightTheme(fontState),
            themeMode: ThemeMode.light,
            initialRoute: AppRoutes.splash,
            onGenerateRoute: AppRoutes.onGenerateRoute,
          );
        },
      ),
    );
  }
}
