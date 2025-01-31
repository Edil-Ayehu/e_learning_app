import 'package:e_learning_app/config/firebase_config.dart';
import 'package:e_learning_app/controllers/auth_controller.dart';
import 'package:e_learning_app/core/theme/app_theme.dart';
import 'package:e_learning_app/data/services/storage_service.dart';
import 'package:e_learning_app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_learning_app/blocs/font/font_bloc.dart';
import 'package:e_learning_app/blocs/font/font_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseConfig.init();

  Get.put(AuthController());

  await GetStorage.init();
  await StorageService.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FontBloc(),
      child: BlocBuilder<FontBloc, FontState>(
        builder: (context, fontState) {
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'E-Learning App',
            theme: AppTheme.getLightTheme(fontState),
            themeMode: ThemeMode.light,
            initialRoute: AppRoutes.splash,
            getPages: AppRoutes.pages,
          );
        },
      ),
    );
  }
}
