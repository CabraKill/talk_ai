import 'package:flutter/material.dart';
import 'package:talk_ai/presentation/pages/home_page.dart';

void main() {
  runApp(
    MaterialApp(
      theme: ThemeData(
        //material color for 747474
        primarySwatch: const MaterialColor(0xFF747474, {
          50: Color(0xFF747474),
          100: Color(0xFF747474),
          200: Color(0xFF747474),
          300: Color(0xFF747474),
          400: Color(0xFF747474),
          500: Color(0xFF747474),
          600: Color(0xFF747474),
          700: Color(0xFF747474),
          800: Color(0xFF747474),
          900: Color(0xFF747474)
        }),
      ),
      home: HomePage(),
    ),
  );
}
