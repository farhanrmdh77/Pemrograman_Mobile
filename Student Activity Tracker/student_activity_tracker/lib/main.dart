import 'package:flutter/material.dart';
import 'home_page.dart';

void main() {
  runApp(const StudentActivityTrackerApp());
}

class StudentActivityTrackerApp extends StatefulWidget {
  const StudentActivityTrackerApp({super.key});

  @override
  State<StudentActivityTrackerApp> createState() => _StudentActivityTrackerAppState();
}

class _StudentActivityTrackerAppState extends State<StudentActivityTrackerApp> {
  // Theme mode and seed color (blue / purple)
  ThemeMode _mode = ThemeMode.system;
  ColorScheme? _lightSeed = ColorScheme.fromSeed(seedColor: Colors.blue);

  void toggleDarkMode(bool on) {
    setState(() {
      _mode = on ? ThemeMode.dark : ThemeMode.light;
    });
  }

  void setSeedToPurple() {
    setState(() {
      _lightSeed = ColorScheme.fromSeed(seedColor: Colors.deepPurple);
    });
  }

  void setSeedToBlue() {
    setState(() {
      _lightSeed = ColorScheme.fromSeed(seedColor: Colors.blue);
    });
  }

  @override
  Widget build(BuildContext context) {
    final light = ThemeData(
      useMaterial3: true,
      colorScheme: _lightSeed,
      brightness: Brightness.light,
    );

    final dark = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue, brightness: Brightness.dark),
      brightness: Brightness.dark,
    );

    return MaterialApp(
      title: 'Student Activity Tracker',
      theme: light,
      darkTheme: dark,
      themeMode: _mode,
      home: HomePage(
        onToggleDarkMode: toggleDarkMode,
        onSetPurple: setSeedToPurple,
        onSetBlue: setSeedToBlue,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
