import 'package:flutter/material.dart';
import 'livingroom_scene.dart';

class TitleScreen extends StatelessWidget {
  const TitleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 390,
          height: 844,
          child: Stack(
            children: [
              // 배경 이미지
              Positioned.fill(
                child: Image.network(
                  '/intro_background.png',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    print('이미지 로드 실패: $error');
                    // assets 경로로 다시 시도
                    return Image.asset(
                      'assets/images/intro_background.png',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error2, stackTrace2) {
                        print('assets 이미지도 로드 실패: $error2');
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
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LivingroomScene(),
                            ),
                          );
                        },
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
                        child: const Text(
                          '시작하기',
                          style: TextStyle(
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