import 'package:e_learning_app/config/firebase_config.dart';
import 'package:e_learning_app/core/theme/app_theme.dart';
import 'package:e_learning_app/data/services/storage_service.dart';
import 'package:e_learning_app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseConfig.init();
  await StorageService.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'E-Learning App',
      theme: AppTheme.lightTheme,
      themeMode: ThemeMode.light,
      initialRoute: AppRoutes.splash,
      getPages: AppRoutes.pages,
    );
  }
}
