import 'package:flutter/material.dart';
import 'candidate_room_detail.dart';

class CandidateRoomsPage extends StatefulWidget {
  const CandidateRoomsPage({super.key});

  @override
  State<CandidateRoomsPage> createState() => _CandidateRoomsPageState();
}

class _CandidateRoomsPageState extends State<CandidateRoomsPage> {
  final DateTime electionDay = DateTime(2025, 6, 3);
  final ScrollController _scrollController = ScrollController();

  final List<Map<String, dynamic>> candidates = const [
    {
      'id': 'lee_jae_myung',
      'name': '이재명',
      'party': '더불어민주당',
      'color': Color(0xFF1E88E5),
      'houseColor': Color(0xFF1E88E5),
      'supportRate': 45,
    },
    {
      'id': 'kim_moon_soo',
      'name': '김문수',
      'party': '국민의힘',
      'color': Color(0xFFE53935),
      'houseColor': Color(0xFFE53935),
      'supportRate': 36,
    },
    {
      'id': 'lee_jun_seok',
      'name': '이준석',
      'party': '개혁신당',
      'color': Color(0xFFFF6600),
      'houseColor': Color(0xFFFF6600),
      'supportRate': 10,
    },
    {
      'id': 'kwon_young_guk',
      'name': '권영국',
      'party': '진보당',
      'color': Color(0xFFFFD700),
      'houseColor': Color(0xFFFFD700),
      'supportRate': 5,
    },
  ];

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8DCC0), // 베이지색 배경
      body: SafeArea(
        child: Scrollbar(
          thumbVisibility: false,
          trackVisibility: false,
          controller: _scrollController,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            physics: const BouncingScrollPhysics(),
            controller: _scrollController,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      _buildHeader(),
                      const SizedBox(height: 30),
                      _buildPixelVillage(context),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.transparent, // 배경색 제거
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF8B4513),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Text(
              '🏘️ 2025 대선 후보 마을',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'monospace',
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            '각 후보의 집을 클릭해서 방문해보세요!',
            style: TextStyle(
              fontSize: 14,
              color: Colors.black,
              fontFamily: 'monospace',
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSimpleDDayCounter() {
    return StreamBuilder(
      stream: Stream.periodic(const Duration(seconds: 1)),
      builder: (context, snapshot) {
        final now = DateTime.now();
        final difference = electionDay.difference(now);
        
        final days = difference.inDays;
        final hours = difference.inHours % 24;
        final minutes = difference.inMinutes % 60;
        final seconds = difference.inSeconds % 60;

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFF8B4513).withOpacity(0.9),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    '⏰ D-',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'monospace',
                    ),
                  ),
                  Text(
                    '$days',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.yellow,
                      fontFamily: 'monospace',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'monospace',
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPixelVillage(BuildContext context) {
    return Center(
      child: Container(
        width: 800, // 이미지 크기에 맞춰 고정 너비 설정
        height: 600, // 이미지 크기에 맞춰 고정 높이 설정
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFF8B4513), width: 3),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Stack(
            children: [
              // 배경 이미지
              Positioned.fill(
                child: Image.asset(
                  'assets/images/main_background.png',
                  fit: BoxFit.cover, // 이미지가 컨테이너를 완전히 채우도록
                  errorBuilder: (context, error, stackTrace) {
                    // 이미지 로드 실패시 간단한 에러 메시지
                    return Container(
                      color: const Color(0xFFE8DCC0),
                      child: const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.image_not_supported,
                              size: 64,
                              color: Color(0xFF8B4513),
                            ),
                            SizedBox(height: 16),
                            Text(
                              '메인 배경 이미지를 불러올 수 없습니다',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF8B4513),
                                fontFamily: 'monospace',
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              // 4개 집들 (이미지 크기에 맞게 위치 조정)
              _buildHouse(context, candidates[0], 150, 150),   // 이재명 집
              _buildHouse(context, candidates[1], 550, 150),   // 김문수 집
              _buildHouse(context, candidates[2], 150, 350),   // 이준석 집
              _buildHouse(context, candidates[3], 550, 350),   // 권영국 집
              // D-Day 카운터를 우상단에 배치
              Positioned(
                top: 20,
                right: 20,
                child: _buildSimpleDDayCounter(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailedGroundPattern() {
    return Positioned.fill(
      child: CustomPaint(
        painter: DetailedGroundPatternPainter(),
      ),
    );
  }

  Widget _buildDetailedRoad() {
    return Positioned(
      left: 0,
      right: 0,
      top: 280,
      height: 40,
      child: Stack(
        children: [
          // 베이지색 길 배경
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFD4C4A8),
              border: Border.symmetric(
                horizontal: BorderSide(color: const Color(0xFFB8A082), width: 2),
              ),
            ),
          ),
          // 길 패턴
          Positioned.fill(
            child: CustomPaint(
              painter: DetailedRoadPatternPainter(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailedTrees() {
    return Stack(
      children: [
        _buildDetailedTree(80, 60),
        _buildDetailedTree(950, 70),
        _buildDetailedTree(100, 480),
        _buildDetailedTree(920, 460),
        _buildDetailedTree(450, 40),
        _buildDetailedTree(350, 500),
        _buildDetailedTree(750, 500),
      ],
    );
  }

  Widget _buildDetailedTree(double left, double top) {
    return Positioned(
      left: left,
      top: top,
      child: Column(
        children: [
          // 나무 잎 (훨씬 디테일하게)
          Column(
            children: [
              // 최상단
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildSmallPixel(Colors.transparent),
                  _buildSmallPixel(Colors.transparent),
                  _buildSmallPixel(Colors.transparent),
                  _buildSmallPixel(const Color(0xFF1B5E20)),
                  _buildSmallPixel(const Color(0xFF1B5E20)),
                  _buildSmallPixel(Colors.transparent),
                  _buildSmallPixel(Colors.transparent),
                  _buildSmallPixel(Colors.transparent),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildSmallPixel(Colors.transparent),
                  _buildSmallPixel(Colors.transparent),
                  _buildSmallPixel(const Color(0xFF1B5E20)),
                  _buildSmallPixel(const Color(0xFF2E7D32)),
                  _buildSmallPixel(const Color(0xFF2E7D32)),
                  _buildSmallPixel(const Color(0xFF1B5E20)),
                  _buildSmallPixel(Colors.transparent),
                  _buildSmallPixel(Colors.transparent),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildSmallPixel(Colors.transparent),
                  _buildSmallPixel(const Color(0xFF1B5E20)),
                  _buildSmallPixel(const Color(0xFF2E7D32)),
                  _buildSmallPixel(const Color(0xFF4CAF50)),
                  _buildSmallPixel(const Color(0xFF4CAF50)),
                  _buildSmallPixel(const Color(0xFF2E7D32)),
                  _buildSmallPixel(const Color(0xFF1B5E20)),
                  _buildSmallPixel(Colors.transparent),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildSmallPixel(const Color(0xFF1B5E20)),
                  _buildSmallPixel(const Color(0xFF2E7D32)),
                  _buildSmallPixel(const Color(0xFF4CAF50)),
                  _buildSmallPixel(const Color(0xFF66BB6A)),
                  _buildSmallPixel(const Color(0xFF66BB6A)),
                  _buildSmallPixel(const Color(0xFF4CAF50)),
                  _buildSmallPixel(const Color(0xFF2E7D32)),
                  _buildSmallPixel(const Color(0xFF1B5E20)),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildSmallPixel(const Color(0xFF1B5E20)),
                  _buildSmallPixel(const Color(0xFF2E7D32)),
                  _buildSmallPixel(const Color(0xFF4CAF50)),
                  _buildSmallPixel(const Color(0xFF66BB6A)),
                  _buildSmallPixel(const Color(0xFF81C784)),
                  _buildSmallPixel(const Color(0xFF66BB6A)),
                  _buildSmallPixel(const Color(0xFF4CAF50)),
                  _buildSmallPixel(const Color(0xFF2E7D32)),
              ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildSmallPixel(const Color(0xFF1B5E20)),
                  _buildSmallPixel(const Color(0xFF2E7D32)),
                  _buildSmallPixel(const Color(0xFF4CAF50)),
                  _buildSmallPixel(const Color(0xFF66BB6A)),
                  _buildSmallPixel(const Color(0xFF66BB6A)),
                  _buildSmallPixel(const Color(0xFF4CAF50)),
                  _buildSmallPixel(const Color(0xFF2E7D32)),
                  _buildSmallPixel(const Color(0xFF1B5E20)),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildSmallPixel(Colors.transparent),
                  _buildSmallPixel(const Color(0xFF1B5E20)),
                  _buildSmallPixel(const Color(0xFF2E7D32)),
                  _buildSmallPixel(const Color(0xFF4CAF50)),
                  _buildSmallPixel(const Color(0xFF4CAF50)),
                  _buildSmallPixel(const Color(0xFF2E7D32)),
                  _buildSmallPixel(const Color(0xFF1B5E20)),
                  _buildSmallPixel(Colors.transparent),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildSmallPixel(Colors.transparent),
                  _buildSmallPixel(Colors.transparent),
                  _buildSmallPixel(const Color(0xFF1B5E20)),
                  _buildSmallPixel(const Color(0xFF2E7D32)),
                  _buildSmallPixel(const Color(0xFF2E7D32)),
                  _buildSmallPixel(const Color(0xFF1B5E20)),
                  _buildSmallPixel(Colors.transparent),
                  _buildSmallPixel(Colors.transparent),
                ],
              ),
            ],
          ),
          // 나무 줄기 (더 디테일하게)
          Column(
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildSmallPixel(Colors.transparent),
                  _buildSmallPixel(Colors.transparent),
                  _buildSmallPixel(Colors.transparent),
                  _buildSmallPixel(const Color(0xFF3E2723)),
                  _buildSmallPixel(const Color(0xFF5D4037)),
                  _buildSmallPixel(Colors.transparent),
                  _buildSmallPixel(Colors.transparent),
                  _buildSmallPixel(Colors.transparent),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildSmallPixel(Colors.transparent),
                  _buildSmallPixel(Colors.transparent),
                  _buildSmallPixel(Colors.transparent),
                  _buildSmallPixel(const Color(0xFF3E2723)),
                  _buildSmallPixel(const Color(0xFF5D4037)),
                  _buildSmallPixel(Colors.transparent),
                  _buildSmallPixel(Colors.transparent),
                  _buildSmallPixel(Colors.transparent),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildSmallPixel(Colors.transparent),
                  _buildSmallPixel(Colors.transparent),
                  _buildSmallPixel(Colors.transparent),
                  _buildSmallPixel(const Color(0xFF3E2723)),
                  _buildSmallPixel(const Color(0xFF5D4037)),
                  _buildSmallPixel(Colors.transparent),
                  _buildSmallPixel(Colors.transparent),
                  _buildSmallPixel(Colors.transparent),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildSmallPixel(Colors.transparent),
                  _buildSmallPixel(Colors.transparent),
                  _buildSmallPixel(Colors.transparent),
                  _buildSmallPixel(const Color(0xFF3E2723)),
                  _buildSmallPixel(const Color(0xFF5D4037)),
                  _buildSmallPixel(Colors.transparent),
                  _buildSmallPixel(Colors.transparent),
                  _buildSmallPixel(Colors.transparent),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHouse(BuildContext context, Map<String, dynamic> candidate, double left, double top) {
    return Positioned(
      left: left,
      top: top,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CandidateRoomDetail(candidate: candidate),
            ),
          );
        },
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: Column(
            children: [
              // 후보명 표시
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.black,
                  border: Border.all(color: candidate['houseColor'], width: 2),
                ),
                child: Text(
                  candidate['name'],
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: candidate['houseColor'],
                    fontFamily: 'monospace',
                  ),
                ),
              ),
              const SizedBox(height: 4),
              // 픽셀 집
              _buildPixelHouse(candidate),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPixelHouse(Map<String, dynamic> candidate) {
    final houseColor = candidate['houseColor'] as Color;
    final darkHouseColor = Color.fromRGBO(
      (houseColor.red * 0.6).round(),
      (houseColor.green * 0.6).round(),
      (houseColor.blue * 0.6).round(),
      1.0,
    );
    final lightHouseColor = Color.fromRGBO(
      ((houseColor.red + 255) / 2).round(),
      ((houseColor.green + 255) / 2).round(),
      ((houseColor.blue + 255) / 2).round(),
      1.0,
    );
    
    return Column(
      children: [
        // 지붕 (훨씬 디테일하게 - 레퍼런스 스타일)
        // 지붕 최상단
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildSmallPixel(Colors.transparent),
            _buildSmallPixel(Colors.transparent),
            _buildSmallPixel(Colors.transparent),
            _buildSmallPixel(Colors.transparent),
            _buildSmallPixel(Colors.transparent),
            _buildSmallPixel(const Color(0xFF2E2E2E)),
            _buildSmallPixel(const Color(0xFF2E2E2E)),
            _buildSmallPixel(Colors.transparent),
            _buildSmallPixel(Colors.transparent),
            _buildSmallPixel(Colors.transparent),
            _buildSmallPixel(Colors.transparent),
            _buildSmallPixel(Colors.transparent),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildSmallPixel(Colors.transparent),
            _buildSmallPixel(Colors.transparent),
            _buildSmallPixel(Colors.transparent),
            _buildSmallPixel(Colors.transparent),
            _buildSmallPixel(const Color(0xFF2E2E2E)),
            _buildSmallPixel(const Color(0xFF424242)),
            _buildSmallPixel(const Color(0xFF424242)),
            _buildSmallPixel(const Color(0xFF2E2E2E)),
            _buildSmallPixel(Colors.transparent),
            _buildSmallPixel(Colors.transparent),
            _buildSmallPixel(Colors.transparent),
            _buildSmallPixel(Colors.transparent),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildSmallPixel(Colors.transparent),
            _buildSmallPixel(Colors.transparent),
            _buildSmallPixel(Colors.transparent),
            _buildSmallPixel(const Color(0xFF2E2E2E)),
            _buildSmallPixel(const Color(0xFF424242)),
            _buildSmallPixel(const Color(0xFF616161)),
            _buildSmallPixel(const Color(0xFF616161)),
            _buildSmallPixel(const Color(0xFF424242)),
            _buildSmallPixel(const Color(0xFF2E2E2E)),
            _buildSmallPixel(Colors.transparent),
            _buildSmallPixel(Colors.transparent),
            _buildSmallPixel(Colors.transparent),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildSmallPixel(Colors.transparent),
            _buildSmallPixel(Colors.transparent),
            _buildSmallPixel(const Color(0xFF2E2E2E)),
            _buildSmallPixel(const Color(0xFF424242)),
            _buildSmallPixel(const Color(0xFF616161)),
            _buildSmallPixel(const Color(0xFF757575)),
            _buildSmallPixel(const Color(0xFF757575)),
            _buildSmallPixel(const Color(0xFF616161)),
            _buildSmallPixel(const Color(0xFF424242)),
            _buildSmallPixel(const Color(0xFF2E2E2E)),
            _buildSmallPixel(Colors.transparent),
            _buildSmallPixel(Colors.transparent),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildSmallPixel(Colors.transparent),
            _buildSmallPixel(const Color(0xFF2E2E2E)),
            _buildSmallPixel(const Color(0xFF424242)),
            _buildSmallPixel(const Color(0xFF616161)),
            _buildSmallPixel(const Color(0xFF757575)),
            _buildSmallPixel(const Color(0xFF9E9E9E)),
            _buildSmallPixel(const Color(0xFF9E9E9E)),
            _buildSmallPixel(const Color(0xFF757575)),
            _buildSmallPixel(const Color(0xFF616161)),
            _buildSmallPixel(const Color(0xFF424242)),
            _buildSmallPixel(const Color(0xFF2E2E2E)),
            _buildSmallPixel(Colors.transparent),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildSmallPixel(const Color(0xFF2E2E2E)),
            _buildSmallPixel(const Color(0xFF424242)),
            _buildSmallPixel(const Color(0xFF616161)),
            _buildSmallPixel(const Color(0xFF757575)),
            _buildSmallPixel(const Color(0xFF9E9E9E)),
            _buildSmallPixel(const Color(0xFFBDBDBD)),
            _buildSmallPixel(const Color(0xFFBDBDBD)),
            _buildSmallPixel(const Color(0xFF9E9E9E)),
            _buildSmallPixel(const Color(0xFF757575)),
            _buildSmallPixel(const Color(0xFF616161)),
            _buildSmallPixel(const Color(0xFF424242)),
            _buildSmallPixel(const Color(0xFF2E2E2E)),
          ],
        ),
        
        // 벽 (훨씬 디테일하게)
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildSmallPixel(darkHouseColor),
            _buildSmallPixel(houseColor),
            _buildSmallPixel(lightHouseColor),
            _buildSmallPixel(houseColor),
            _buildSmallPixel(const Color(0xFFE3F2FD)), // 창문 프레임
            _buildSmallPixel(const Color(0xFF87CEEB)), // 창문
            _buildSmallPixel(const Color(0xFF87CEEB)), // 창문
            _buildSmallPixel(const Color(0xFFE3F2FD)), // 창문 프레임
            _buildSmallPixel(houseColor),
            _buildSmallPixel(lightHouseColor),
            _buildSmallPixel(houseColor),
            _buildSmallPixel(darkHouseColor),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildSmallPixel(darkHouseColor),
            _buildSmallPixel(houseColor),
            _buildSmallPixel(lightHouseColor),
            _buildSmallPixel(houseColor),
            _buildSmallPixel(const Color(0xFFE3F2FD)), // 창문 프레임
            _buildSmallPixel(const Color(0xFFB3E5FC)), // 창문 밝은 부분
            _buildSmallPixel(const Color(0xFFB3E5FC)), // 창문 밝은 부분
            _buildSmallPixel(const Color(0xFFE3F2FD)), // 창문 프레임
            _buildSmallPixel(houseColor),
            _buildSmallPixel(lightHouseColor),
            _buildSmallPixel(houseColor),
            _buildSmallPixel(darkHouseColor),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildSmallPixel(darkHouseColor),
            _buildSmallPixel(houseColor),
            _buildSmallPixel(lightHouseColor),
            _buildSmallPixel(houseColor),
            _buildSmallPixel(const Color(0xFFE3F2FD)), // 창문 프레임
            _buildSmallPixel(const Color(0xFF87CEEB)), // 창문
            _buildSmallPixel(const Color(0xFF87CEEB)), // 창문
            _buildSmallPixel(const Color(0xFFE3F2FD)), // 창문 프레임
            _buildSmallPixel(houseColor),
            _buildSmallPixel(lightHouseColor),
            _buildSmallPixel(houseColor),
            _buildSmallPixel(darkHouseColor),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildSmallPixel(darkHouseColor),
            _buildSmallPixel(houseColor),
            _buildSmallPixel(lightHouseColor),
            _buildSmallPixel(houseColor),
            _buildSmallPixel(houseColor),
            _buildSmallPixel(houseColor),
            _buildSmallPixel(houseColor),
            _buildSmallPixel(houseColor),
            _buildSmallPixel(houseColor),
            _buildSmallPixel(lightHouseColor),
            _buildSmallPixel(houseColor),
            _buildSmallPixel(darkHouseColor),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildSmallPixel(darkHouseColor),
            _buildSmallPixel(houseColor),
            _buildSmallPixel(lightHouseColor),
            _buildSmallPixel(houseColor),
            _buildSmallPixel(const Color(0xFF3E2723)), // 문 프레임
            _buildSmallPixel(const Color(0xFF3E2723)), // 문 프레임
            _buildSmallPixel(const Color(0xFF3E2723)), // 문 프레임
            _buildSmallPixel(const Color(0xFF3E2723)), // 문 프레임
            _buildSmallPixel(houseColor),
            _buildSmallPixel(lightHouseColor),
            _buildSmallPixel(houseColor),
            _buildSmallPixel(darkHouseColor),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildSmallPixel(darkHouseColor),
            _buildSmallPixel(houseColor),
            _buildSmallPixel(lightHouseColor),
            _buildSmallPixel(houseColor),
            _buildSmallPixel(const Color(0xFF5D4037)), // 문
            _buildSmallPixel(const Color(0xFF8D6E63)), // 문 밝은 부분
            _buildSmallPixel(const Color(0xFF8D6E63)), // 문 밝은 부분
            _buildSmallPixel(const Color(0xFF5D4037)), // 문
            _buildSmallPixel(houseColor),
            _buildSmallPixel(lightHouseColor),
            _buildSmallPixel(houseColor),
            _buildSmallPixel(darkHouseColor),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildSmallPixel(darkHouseColor),
            _buildSmallPixel(houseColor),
            _buildSmallPixel(lightHouseColor),
            _buildSmallPixel(houseColor),
            _buildSmallPixel(const Color(0xFF5D4037)), // 문
            _buildSmallPixel(const Color(0xFF8D6E63)), // 문 밝은 부분
            _buildSmallPixel(const Color(0xFFFFD700)), // 문손잡이
            _buildSmallPixel(const Color(0xFF5D4037)), // 문
            _buildSmallPixel(houseColor),
            _buildSmallPixel(lightHouseColor),
            _buildSmallPixel(houseColor),
            _buildSmallPixel(darkHouseColor),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildSmallPixel(darkHouseColor),
            _buildSmallPixel(houseColor),
            _buildSmallPixel(lightHouseColor),
            _buildSmallPixel(houseColor),
            _buildSmallPixel(const Color(0xFF5D4037)), // 문
            _buildSmallPixel(const Color(0xFF8D6E63)), // 문 밝은 부분
            _buildSmallPixel(const Color(0xFF8D6E63)), // 문 밝은 부분
            _buildSmallPixel(const Color(0xFF5D4037)), // 문
            _buildSmallPixel(houseColor),
            _buildSmallPixel(lightHouseColor),
            _buildSmallPixel(houseColor),
            _buildSmallPixel(darkHouseColor),
          ],
        ),
      ],
    );
  }

  Widget _buildPixel(Color color) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        color: color,
      ),
    );
  }

  Widget _buildSmallPixel(Color color) {
    return Container(
      width: 6, // 훨씬 작은 픽셀
      height: 6, // 훨씬 작은 픽셀
      decoration: BoxDecoration(
        color: color,
      ),
    );
  }
}

class DetailedGroundPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // 베이지색 기본 배경
    final basePaint = Paint()..color = const Color(0xFFE8DCC0);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), basePaint);
    
    // 연한 녹색 잔디 패치들
    final grassPaint1 = Paint()..color = const Color(0xFFB8D4A0);
    final grassPaint2 = Paint()..color = const Color(0xFFA8C490);
    final grassPaint3 = Paint()..color = const Color(0xFF98B480);
    
    // 잔디 패치들을 랜덤하게 배치
    for (int i = 0; i < size.width; i += 8) {
      for (int j = 0; j < size.height; j += 8) {
        if ((i + j) % 24 == 0) {
          canvas.drawRect(Rect.fromLTWH(i.toDouble(), j.toDouble(), 6, 6), grassPaint1);
        } else if ((i + j) % 32 == 0) {
          canvas.drawRect(Rect.fromLTWH(i.toDouble() + 2, j.toDouble() + 2, 4, 4), grassPaint2);
        } else if ((i + j) % 40 == 0) {
          canvas.drawRect(Rect.fromLTWH(i.toDouble() + 1, j.toDouble() + 1, 3, 3), grassPaint3);
        }
      }
    }
    
    // 작은 돌들
    final stonePaint = Paint()..color = const Color(0xFFBCAAA4);
    for (int i = 20; i < size.width; i += 60) {
      for (int j = 30; j < size.height; j += 80) {
        canvas.drawRect(Rect.fromLTWH(i.toDouble(), j.toDouble(), 2, 2), stonePaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class DetailedRoadPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // 길 텍스처
    final roadPaint1 = Paint()..color = const Color(0xFFC4B49C);
    final roadPaint2 = Paint()..color = const Color(0xFFB4A48C);
    
    // 길 패턴
    for (int i = 0; i < size.width; i += 4) {
      for (int j = 0; j < size.height; j += 4) {
        if ((i + j) % 8 == 0) {
          canvas.drawRect(Rect.fromLTWH(i.toDouble(), j.toDouble(), 2, 2), roadPaint1);
        } else if ((i + j) % 12 == 0) {
          canvas.drawRect(Rect.fromLTWH(i.toDouble() + 1, j.toDouble() + 1, 2, 2), roadPaint2);
        }
      }
    }
    
    // 길 가장자리 어두운 선
    final edgePaint = Paint()..color = const Color(0xFFB8A082);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, 2), edgePaint);
    canvas.drawRect(Rect.fromLTWH(0, size.height - 2, size.width, 2), edgePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}