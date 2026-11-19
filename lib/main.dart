import 'package:flutter/material.dart';

import 'pages/task_tracker_page.dart';

void main() {
  runApp(const MainApp());
}

/// Root widget for the Mini Task Tracker application.
class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Catatan Harian',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF18181B),
          surface: Colors.white,
        ),
        scaffoldBackgroundColor: const Color(0xFFF7F7F5),
        useMaterial3: true,
        snackBarTheme: SnackBarThemeData(
          backgroundColor: const Color(0xFF18181B),
          contentTextStyle: const TextStyle(color: Colors.white),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      home: const TaskTrackerPage(),
    );
  }
}
