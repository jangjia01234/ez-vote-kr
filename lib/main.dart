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

// 이미지 미리 로드 함수
Future<void> precacheImages(BuildContext context) async {
  final List<String> imagePaths = [
    'assets/images/livingroom_background.png',
    'assets/images/angelcat_background.png',
    'assets/images/candidate_1/room_background_1_empty.png',
    'assets/images/candidate_1/avatar_1.png',
    'assets/images/candidate_1/room_computer.png',
    'assets/images/candidate_1/room_flowerPot.png',
    'assets/images/candidate_1/room_apartment.png',
    'assets/images/candidate_1/room_suitcase.png',
    'assets/images/candidate_2/room_background_2_empty.png',
    'assets/images/candidate_2/avatar_2.png',
    'assets/images/candidate_2/room_train.png',
    'assets/images/candidate_2/room_moneybox.png',
    'assets/images/candidate_2/room_militarycap.png',
    'assets/images/candidate_2/room_lawbook.png',
    'assets/images/candidate_4/room_background_4_empty.png',
    'assets/images/candidate_4/avatar_4.png',
    'assets/images/candidate_5/room_background_5_empty.png',
    'assets/images/candidate_5/avatar_5.png',
  ];

  for (String imagePath in imagePaths) {
    try {
      await precacheImage(AssetImage(imagePath), context);
    } catch (e) {
      print('이미지 미리 로드 실패: $imagePath - $e');
    }
  }
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
