import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'screens/title_screen.dart';
import 'services/bgm_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // BGM 서비스 초기화
  if (kIsWeb) {
    await BGMService().initialize();
  }
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '2025 대선 후보 방 구경',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.brown,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        fontFamily: 'Pretendard',
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
        ),
        scrollbarTheme: const ScrollbarThemeData(
          thumbVisibility: MaterialStatePropertyAll(false),
          trackVisibility: MaterialStatePropertyAll(false),
        ),
      ),
      home: const TitleScreen(),
    );
  }
}
