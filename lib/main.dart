import 'package:flutter/material.dart';
import 'screens/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '2025 대선',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.grey,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        iconTheme: const IconThemeData(
          size: 24,
        ),
        expansionTileTheme: const ExpansionTileThemeData(
          iconColor: Colors.grey,
          collapsedIconColor: Colors.grey,
        ),
      ),
      home: const HomePage(),
    );
  }
}
