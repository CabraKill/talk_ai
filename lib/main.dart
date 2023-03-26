import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:talk_ai/infra/colors/colors.dart';
import 'package:talk_ai/infra/injections/injectable.dart';
import 'package:talk_ai/presentation/pages/home_page.dart';
import 'package:talk_ai/presentation/pages/home_page_controller.dart';

void main() {
  configureDependencies();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => getIt<HomePageController>()),
      ],
      child: MaterialApp(
        theme: ThemeData(
          //material color for 747474
          primarySwatch: AppColors.grey,
        ),
        home: const HomePage(),
      ),
    ),
  );
}
