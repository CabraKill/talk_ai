import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:talk_ai/infra/colors/colors.dart';
import 'package:talk_ai/infra/injections/injectable.dart';
import 'package:talk_ai/infra/services/theme_service.dart';
import 'package:talk_ai/presentation/pages/home_page.dart';
import 'package:talk_ai/presentation/pages/home_page_controller.dart';

void main() {
  configureDependencies();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => getIt<HomePageController>(),
        ),
        ChangeNotifierProvider(
          create: (_) => getIt<ThemeService>(),
        ),
      ],
      child: Consumer<ThemeService>(
        builder: (context, themeController, child) {
          return MaterialApp(
            themeMode: themeController.isDarkTheme? ThemeMode.dark : ThemeMode.light,
            theme: ThemeData.light(
              useMaterial3: themeController.isDarkTheme,
            ).copyWith(
              primaryColor: AppColors.grey,
            ),
            darkTheme: ThemeData.dark(
              useMaterial3: true,
            ).copyWith(
              primaryColor: AppColors.cyan,
            ),
            home: const HomePage(),
          );
        },
      ),
    ),
  );
}
