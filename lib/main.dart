import 'package:flutter/material.dart';
import 'horizontal_rail_layout.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Horizontal Rail Layout',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
        fontFamily: 'SF Pro Display',
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF3B82F6),
          surface: Color(0xFFFFFFFF),
          onSurface: Color(0xFF1E293B),
        ),
      ),
      home: const HorizontalRailLayout(),
    );
  }
}
