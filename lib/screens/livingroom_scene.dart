import 'package:flutter/material.dart';
import 'dream_world_scene.dart';
import '../services/bgm_service.dart';

class LivingroomScene extends StatefulWidget {
  const LivingroomScene({super.key});

  @override
  State<LivingroomScene> createState() => _LivingroomSceneState();
}

class _LivingroomSceneState extends State<LivingroomScene> {
  int currentDialogue = 0;
  bool isTransitioning = false;

  final List<String> dialogues = [
    "TV에서 2025년 대선 뉴스가 나오고 있다...",
    "(또 선거철이구나... 누구를 뽑아야 할까?)",
    "(정치는 항상 어렵단 말이지.. 아직도 결정을 못했어)",
    "(흠냐..잠깐만 눈 좀 붙여볼까...💤)",
    "당신은 깜빡 잠에 들었다..."
  ];

  void nextDialogue() {
    if (isTransitioning) return;
    
    if (currentDialogue < dialogues.length - 1) {
      setState(() {
        currentDialogue++;
      });
    } else {
      // 마지막 대사 후 페이드 아웃 효과 (시간 단축)
      setState(() {
        isTransitioning = true;
      });
      
      Future.delayed(const Duration(milliseconds: 800), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const DreamWorldScene(),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: GestureDetector(
          onTap: nextDialogue,
          child: Container(
            width: 390,
            height: 844,
            child: Stack(
              children: [
                // 배경 이미지
                Positioned.fill(
                  child: Image.asset(
                    'assets/images/livingroom_background.png',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      print('이미지 로드 실패: $error');
                      return Container(
                        color: const Color(0xFF2C1810),
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
                                '거실 배경을 불러올 수 없습니다',
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
                
                // BGM 플레이어 (좌상단)
                Positioned(
                  top: 50,
                  left: 20,
                  child: StreamBuilder<bool>(
                    stream: BGMService.isPlayingStream,
                    builder: (context, snapshot) {
                      final isPlaying = snapshot.data ?? false;
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.7),
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: IconButton(
                          onPressed: BGMService.toggleBGM,
                          icon: Icon(
                            isPlaying ? Icons.volume_up : Icons.volume_off,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                
                // D-Day 카운터 (우상단) - 실제 선거일로 수정
                Positioned(
                  top: 50,
                  right: 20,
                  child: StreamBuilder(
                    stream: Stream.periodic(const Duration(seconds: 1)),
                    builder: (context, snapshot) {
                                          // 한국 시간 기준으로 계산 (UTC+9)
                    final now = DateTime.now().toUtc().add(const Duration(hours: 9));
                    final kstElectionDay = DateTime(2025, 6, 3).toUtc().add(const Duration(hours: 9));
                    final difference = kstElectionDay.difference(now);
                      // 더 정확한 D-Day 계산 (시간 단위까지 고려)
                      final days = (difference.inHours / 24).ceil();
                      
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.9),
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              '선거일까지',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            Text(
                              'D-$days',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                
                // 대화창 (하단)
                Positioned(
                  bottom: 50,
                  left: 20,
                  right: 20,
                  child: AnimatedOpacity(
                    opacity: isTransitioning ? 0.0 : 1.0,
                    duration: const Duration(milliseconds: 800),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.8),
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            dialogues[currentDialogue],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              height: 1.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 15),
                          const Text(
                            '터치하여 계속',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                
                // 페이드 아웃 오버레이
                if (isTransitioning)
                  AnimatedOpacity(
                    opacity: isTransitioning ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 800),
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      color: Colors.black,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 