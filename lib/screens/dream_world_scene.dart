import 'package:flutter/material.dart';
import 'candidate_room_detail.dart';
import 'ending_scene.dart';
import '../services/bgm_service.dart';

class DreamWorldScene extends StatefulWidget {
  const DreamWorldScene({super.key});

  @override
  State<DreamWorldScene> createState() => _DreamWorldSceneState();
}

class _DreamWorldSceneState extends State<DreamWorldScene> {
  int currentDialogue = 0;
  bool showCandidateButtons = false;
  Set<String> visitedCandidates = {};

  final List<String> angelCatDialogues = [
    "😇 \"안녕하세요! 저는 천사 고양이예요~\"",
    "✨ \"여기는 꿈속 세계입니다. 각 후보들의 방을 구경해보세요!\"",
    "🏠 \"후보들의 방을 둘러보고 그들을 알아가보세요.\"",
    "🗳️ \"모든 방을 다 보시면 현실로 돌아갈 수 있어요!\""
  ];

  final List<Map<String, dynamic>> candidates = [
    {
      'id': 'lee_jae_myung',
      'name': '이재명',
      'party': '민주당',
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
      'id': 'kwon_young_gook',
      'name': '권영국',
      'party': '진보당',
      'color': const Color(0xFFEAB308),
    },
  ];

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
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CandidateRoomDetail(candidate: candidate),
      ),
    );
  }

  void goToEnding() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const EndingScene(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GestureDetector(
          onTap: showCandidateButtons ? null : nextDialogue,
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
                        borderRadius: BorderRadius.circular(25),
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
              
              // 후보 선택 버튼들 (하단으로 이동)
              if (showCandidateButtons)
                Positioned(
                  bottom: 120,
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
                          '누구의 방을 볼래?',
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