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
    "😇 \"이제 각 후보들에 대해 더 잘 알게 되셨을 거예요.\"",
    "😇 \"선택에 도움이 되었길..\"",
    "😇 \"아참, 6월 3일에 꼭 투표하라냥!\""
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

  void shareGame() {
    final url = html.window.location.href;
    final text = '2025 대선 시뮬레이터를 플레이해보세요! 후보들의 정책을 재미있게 알아볼 수 있어요 🗳️';
    
    // Web Share API 지원 확인
    if (html.window.navigator.share != null) {
      html.window.navigator.share({
        'title': '2025 대선 시뮬레이터',
        'text': text,
        'url': url,
      });
    } else {
      // 클립보드에 복사
      html.window.navigator.clipboard?.writeText('$text\n$url');
      _showShareDialog();
    }
  }

  void _showShareDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.black,
              border: Border.all(color: Colors.white, width: 3),
            ),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF2C2C2C),
                border: Border.all(color: Colors.white, width: 1),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    '📋 링크가 복사되었습니다!',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    '친구들과 공유해보세요!',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      shape: const RoundedRectangleBorder(),
                    ),
                    child: const Text('확인'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void showDeveloperInfo() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 500),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.black,
              border: Border.all(color: Colors.white, width: 3),
            ),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF2C2C2C),
                border: Border.all(color: Colors.white, width: 1),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 제목
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF3B82F6),
                      border: Border.all(color: Colors.black, width: 2),
                    ),
                    child: const Text(
                      '👨‍💻 만든 사람',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // 개발자 정보
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      border: Border.all(color: Colors.white, width: 1),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '🤔 누가 만들었을까?',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF3B82F6),
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '• 정치가 어려웠던 20대 앱 개발자가 만들었어요.\n'
                          '• 저와 같은 청년들이 재밌게 공약을 이해하도록 돕고 싶었습니다!\n'
                          '• 서비스에 개선이 필요한 사항이 있다면 언제든 편하게 의견주세요. 모든 의견을 환영합니다 :)',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.white,
                            height: 1.5,
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          '📧 문의사항',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF3B82F6),
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '버그 신고, 개선 제안, 기타 문의사항이 있으시면\n'
                          '아래 이메일로 연락해주세요!',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.white,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // 이메일 버튼
                  ElevatedButton(
                    onPressed: () {
                      html.window.open('mailto:jangjia01234@gmail.com?subject=2025 대선 시뮬레이터 문의&body=안녕하세요! 게임에 대한 문의사항이 있습니다.', '_blank');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF10B981),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: const RoundedRectangleBorder(),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.email, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'jangjia01234@gmail.com',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // 닫기 버튼
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                      shape: const RoundedRectangleBorder(),
                    ),
                    child: const Text(
                      '닫기',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
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
            child: Stack(
              children: [
                // 배경 이미지
                Positioned.fill(
                  child: Image.asset(
                    'assets/images/angelcat_ending_background.png',
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                    errorBuilder: (context, error, stackTrace) {
                      print('엔딩 배경 이미지 로드 실패: $error');
                      // 기존 배경 이미지로 폴백
                      return Image.asset(
                        'assets/images/angelcat_background.png',
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                        errorBuilder: (context, error2, stackTrace2) {
                          print('기본 배경 이미지도 로드 실패: $error2');
                          return Container(
                            color: const Color(0xFF2C2C2C),
                            child: const Center(
                              child: Text(
                                '배경 이미지를 불러올 수 없습니다',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          );
                        },
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
                    final electionDay = DateTime(2025, 6, 3);
                    final now = DateTime.now();
                    final difference = electionDay.difference(now);
                    final days = difference.inDays;
                    
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
                            SizedBox(height: 2),
                            Text(
                              '잊지 말고 투표하세요!',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 50),
                      
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
                          '다시하기',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // 공유하기 버튼
                      ElevatedButton(
                        onPressed: shareGame,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF10B981),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                          side: const BorderSide(color: Colors.black, width: 3),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.share, size: 20),
                            SizedBox(width: 8),
                            Text(
                              '공유하기',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      // 개발자 정보 버튼
                      ElevatedButton(
                        onPressed: showDeveloperInfo,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF8B5CF6),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                          side: const BorderSide(color: Colors.black, width: 3),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.info_outline, size: 20),
                            SizedBox(width: 8),
                            Text(
                              '만든 사람',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
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