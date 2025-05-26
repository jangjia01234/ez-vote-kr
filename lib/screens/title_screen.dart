import 'package:flutter/material.dart';
import 'livingroom_scene.dart';
import '../services/analytics_service.dart';

class TitleScreen extends StatefulWidget {
  const TitleScreen({super.key});

  @override
  State<TitleScreen> createState() => _TitleScreenState();
}

class _TitleScreenState extends State<TitleScreen> {
  bool _imagesLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadImages();
    // 타이틀 화면 방문 추적
    AnalyticsService.trackPageView('title_screen');
  }

  Future<void> _loadImages() async {
    // 이미지 프리로딩 제거하고 바로 로드 완료로 설정
    if (mounted) {
      setState(() {
        _imagesLoaded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Container(
          width: 390,
          height: 844,
          child: Stack(
            children: [
              // 배경 이미지
              Positioned.fill(
                child: Image.asset(
                  'assets/images/intro_background.png',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    print('이미지 로드 실패: $error');
                    return Container(
                      color: const Color(0xFF1E3A8A),
                      child: const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.image_not_supported,
                              size: 64,
                              color: Colors.white,
                            ),
                            SizedBox(height: 16),
                            Text(
                              '배경 이미지를 불러올 수 없습니다',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              // 시작하기 버튼
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(),
                    Container(
                      margin: const EdgeInsets.only(bottom: 100),
                      child: ElevatedButton(
                        onPressed: _imagesLoaded ? () {
                          // 게임 시작 이벤트 추적
                          AnalyticsService.trackEvent('game_start');
                          Navigator.pushReplacement(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (context, animation, secondaryAnimation) => const LivingroomScene(),
                              transitionDuration: Duration.zero,
                              reverseTransitionDuration: Duration.zero,
                            ),
                          );
                        } : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFEF4444),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                          elevation: 0,
                          side: const BorderSide(color: Colors.black, width: 3),
                        ),
                        child: Text(
                          _imagesLoaded ? '시작하기' : '로딩 중...',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 