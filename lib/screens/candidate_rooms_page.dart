import 'package:flutter/material.dart';
import 'dart:async';
import 'candidate_room_detail.dart';
import '../services/bgm_service.dart';

class CandidateRoomsPage extends StatefulWidget {
  const CandidateRoomsPage({super.key});

  @override
  State<CandidateRoomsPage> createState() => _CandidateRoomsPageState();
}

class _CandidateRoomsPageState extends State<CandidateRoomsPage> {
  final DateTime electionDay = DateTime(2025, 6, 3); // 2025년 6월 3일 선거일
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
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8DCC0), // 베이지색 배경
      body: Center(
        child: Stack(
          children: [
            // 모바일 크기로 고정된 게임 화면
            _buildPixelVillage(context),
            // 상단 중앙에 헤더 (BGM, D-Day 버튼과 겹치지 않게)
            Positioned(
              top: 80, // BGM과 D-Day 버튼 아래로 이동
              left: 60,
              right: 60,
              child: _buildHeader(),
            ),
          ],
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
    );
  }

  Widget _buildBgmPlayer() {
    return StreamBuilder<bool>(
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
    );
  }

  Widget _buildPixelVillage(BuildContext context) {
    // 모바일 크기로 고정 (iPhone 14 기준)
    const double mobileWidth = 390;
    const double mobileHeight = 844;
    
    return Container(
      width: mobileWidth, // 모바일 너비로 고정
      height: mobileHeight, // 모바일 높이로 고정
      child: Stack(
        children: [
          // 배경 이미지
          Positioned.fill(
            child: Image.asset(
              'assets/images/main_background.png',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                print('이미지 로드 실패: $error');
                return Container(
                  color: const Color(0xFFE8DCC0),
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.image_not_supported,
                          size: 48,
                          color: Color(0xFF8B4513),
                        ),
                        SizedBox(height: 12),
                        Text(
                          '메인 배경 이미지를 불러올 수 없습니다',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF8B4513),
                            fontFamily: 'monospace',
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          // 4개 집들 (모바일 크기 기준으로 고정 위치)
          _buildHouse(context, candidates[0], mobileWidth * 0.15, mobileHeight * 0.35),    // 이재명 집 (좌상)
          _buildHouse(context, candidates[1], mobileWidth * 0.55, mobileHeight * 0.35),   // 김문수 집 (우상)
          _buildHouse(context, candidates[2], mobileWidth * 0.15, mobileHeight * 0.65),    // 이준석 집 (좌하)
          _buildHouse(context, candidates[3], mobileWidth * 0.55, mobileHeight * 0.65),   // 권영국 집 (우하)
          // BGM 플레이어를 좌상단에 배치
          Positioned(
            top: 20,
            left: 20,
            child: _buildBgmPlayer(),
          ),
          // D-Day 카운터를 우상단에 배치
          Positioned(
            top: 20,
            right: 20,
            child: _buildSimpleDDayCounter(),
          ),
        ],
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