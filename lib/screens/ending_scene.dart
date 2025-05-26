import 'package:flutter/material.dart';
import 'dart:html' as html;
import 'title_screen.dart';
import '../services/bgm_service.dart';

class EndingScene extends StatefulWidget {
  const EndingScene({super.key});

  @override
  State<EndingScene> createState() => _EndingSceneState();
}

class _EndingSceneState extends State<EndingScene> {
  int currentDialogue = 0;
  bool showButtons = false;

  final List<String> endingDialogues = [
    "😇 \"모든 후보들의 방을 다 둘러보셨군요!\"",
    "✨ \"이제 각 후보들에 대해 더 잘 알게 되셨을 거예요.\"",
    "🗳️ \"현실에서도 신중하게 선택하시길 바라요. 게임을 완료하신 것을 축하드립니다!\""
  ];

  void nextDialogue() {
    if (currentDialogue < endingDialogues.length - 1) {
      setState(() {
        currentDialogue++;
      });
    } else {
      setState(() {
        showButtons = true;
      });
    }
  }

  void openElectionWebsite() {
    html.window.open('https://www.nec.go.kr', '_blank');
  }

  void restartGame() {
    Navigator.pushAndRemoveUntil(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const TitleScreen(),
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: GestureDetector(
          onTap: showButtons ? null : nextDialogue,
          child: Container(
            width: 390,
            height: 844,
            decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/angelcat_background.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: [
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
                    final electionDay = DateTime(2025, 6, 3);
                    final now = DateTime.now();
                    final difference = electionDay.difference(now);
                    final days = difference.inDays;
                    
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                                              decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.9),
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                      child: Text(
                        'D-$days',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  },
                ),
              ),
              
              // 버튼들 (중앙)
              if (showButtons)
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 100),
                      // 축하 메시지
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 30),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          border: Border.all(color: Colors.black, width: 3),
                        ),
                        child: const Column(
                          children: [
                            Text(
                              '🎉',
                              style: TextStyle(fontSize: 50),
                            ),
                            SizedBox(height: 10),
                            Text(
                              '게임 완료!',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E3A8A),
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              '모든 후보를 만나보셨습니다',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 50),
                      // 중앙선거관리위원회 버튼
                      ElevatedButton(
                        onPressed: openElectionWebsite,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3B82F6),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                          side: const BorderSide(color: Colors.black, width: 3),
                        ),
                        child: const Text(
                          '중앙선거관리위원회 사이트',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // 처음부터 다시 버튼
                      ElevatedButton(
                        onPressed: restartGame,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFEF4444),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                          side: const BorderSide(color: Colors.black, width: 3),
                        ),
                        child: const Text(
                          '처음부터 다시',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              
              // 대화창 (하단)
              if (!showButtons)
                Positioned(
                  bottom: 50,
                  left: 20,
                  right: 20,
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
                          endingDialogues[currentDialogue],
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
            ],
          ),
        ),
        ),
      ),
    );
  }
} 