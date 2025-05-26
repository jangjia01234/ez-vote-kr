import 'package:flutter/material.dart';
import 'candidate_room_detail.dart';
import 'ending_scene.dart';
import '../services/bgm_service.dart';
import '../services/analytics_service.dart';

class DreamWorldScene extends StatefulWidget {
  const DreamWorldScene({super.key});

  @override
  State<DreamWorldScene> createState() => _DreamWorldSceneState();
}

class _DreamWorldSceneState extends State<DreamWorldScene> with TickerProviderStateMixin {
  int currentDialogue = 0;
  bool showCandidateButtons = false;
  Set<String> visitedCandidates = {};
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  final List<String> angelCatDialogues = [
    "(어..? 여긴 어디지?)",
    "(꿈속인가? 뭔가 이상한 느낌이...)",
    "😇 \"안녕하세요! 저는 당신을 돕기 위해 온 천사다냥~\"",
    "음.. 뭔가 허접한데... 진짜 천사 맞아?!",
    "😇 \"크흠.. 아, 암튼!! 천사랍니다! 당신이 고민에 빠졌다는 소리를 듣고 왔어요!\"",
    "😇 \"당신을 위해 후보 4명의 방으로 가는 열쇠를 줄게요\"",
    "😇 \"참고로 방 안에는 숨겨진 물건들이 있어요! 잘 찾아보세요~\"",
    "😇 \"모든 방을 다 보시면 현실로 돌아갈 수 있어요! 그럼 안녕~\""
  ];

  final List<Map<String, dynamic>> candidates = [
    {
      'id': 'lee_jae_myung',
      'name': '이재명',
      'party': '더불어민주당',
      'color': const Color(0xFF3B82F6),
    },
    {
      'id': 'kim_moon_soo',
      'name': '김문수',
      'party': '국민의힘',
      'color': const Color(0xFFEF4444),
    },
    {
      'id': 'lee_jun_seok',
      'name': '이준석',
      'party': '개혁신당',
      'color': const Color(0xFFF97316),
    },
    {
      'id': 'kwon_young_guk',
      'name': '권영국',
      'party': '민주노동당',
      'color': const Color(0xFFEAB308),
    },
  ];

  @override
  void initState() {
    super.initState();
    // 꿈속 세계 씬 방문 추적
    AnalyticsService.trackPageView('dream_world_scene');
    
    _fadeController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    ));
    
    // 페이드인 애니메이션 시작
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  void nextDialogue() {
    if (currentDialogue < angelCatDialogues.length - 1) {
      setState(() {
        currentDialogue++;
      });
    } else {
      setState(() {
        showCandidateButtons = true;
      });
    }
  }

  void visitCandidate(Map<String, dynamic> candidate) {
    setState(() {
      visitedCandidates.add(candidate['id']);
    });
    
    // 후보 방 방문 이벤트 추적
    AnalyticsService.trackEvent('candidate_visit', properties: {
      'candidate_id': candidate['id'],
      'candidate_name': candidate['name'],
      'candidate_party': candidate['party'],
    });
    
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => CandidateRoomDetail(candidate: candidate),
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
  }

  void goToEnding() {
    // 모든 후보 방문 완료 이벤트 추적
    AnalyticsService.trackEvent('all_candidates_visited');
    
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const EndingScene(),
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: GestureDetector(
          onTap: showCandidateButtons ? null : nextDialogue,
          child: Container(
            width: 390,
            height: 844,
            child: AnimatedBuilder(
              animation: _fadeAnimation,
              builder: (context, child) {
                return Stack(
                  children: [
                    // 배경 이미지 (페이드인)
                    Opacity(
                      opacity: _fadeAnimation.value,
                      child: Image.asset(
                        'assets/images/angelcat_background.png',
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
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
                                    '꿈속 세계 배경을 불러올 수 없습니다',
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
                    // UI 요소들
                    Opacity(
                      opacity: _fadeAnimation.value,
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
              
              // 후보 선택 버튼들 (하단으로 이동)
              if (showCandidateButtons)
                Positioned(
                  bottom: 100,
                  left: 0,
                  right: 0,
                  child: Column(
                    children: [
                      // 멘트 추가
                      Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.8),
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Text(
                          '누구의 방을 볼까?',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      // 첫 번째 줄
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildCandidateButton(candidates[0]),
                          _buildCandidateButton(candidates[1]),
                        ],
                      ),
                      const SizedBox(height: 15),
                      // 두 번째 줄
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildCandidateButton(candidates[2]),
                          _buildCandidateButton(candidates[3]),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // 모든 방을 다 봤다 버튼
                      if (visitedCandidates.length == candidates.length)
                        ElevatedButton(
                          onPressed: goToEnding,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFF97316),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                            ),
                            side: const BorderSide(color: Colors.black, width: 3),
                          ),
                          child: const Text(
                            '모든 방을 다 봤다!',
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
              if (!showCandidateButtons)
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
                          angelCatDialogues[currentDialogue],
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
                ],
              );
            },
          ),
        ),
        ),
      ),
    );
  }

  Widget _buildCandidateButton(Map<String, dynamic> candidate) {
    final isVisited = visitedCandidates.contains(candidate['id']);
    
    return Container(
      width: 140,
      height: 90, // 높이를 늘려서 체크 표시 공간 확보
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            candidate['color'],
            candidate['color'].withOpacity(0.7),
          ],
        ),
        borderRadius: BorderRadius.zero,
        border: Border.all(
          color: isVisited ? Colors.green : Colors.white,
          width: isVisited ? 3 : 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.zero,
          onTap: () => visitCandidate(candidate),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isVisited)
                  const Icon(
                    Icons.check_circle,
                    color: Colors.white,
                    size: 20,
                  ),
                Text(
                  candidate['name'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  candidate['party'],
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
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