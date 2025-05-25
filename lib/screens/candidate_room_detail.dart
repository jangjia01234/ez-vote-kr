import 'package:flutter/material.dart';

class CandidateRoomDetail extends StatefulWidget {
  final Map<String, dynamic> candidate;

  const CandidateRoomDetail({super.key, required this.candidate});

  @override
  State<CandidateRoomDetail> createState() => _CandidateRoomDetailState();
}

class _CandidateRoomDetailState extends State<CandidateRoomDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8DCC0), // 밝은 베이지색 배경으로 변경
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.black,
            border: Border.all(color: widget.candidate['color'], width: 2),
          ),
          child: Text(
            '${widget.candidate['name']}의 방',
            style: TextStyle(
              color: widget.candidate['color'],
              fontWeight: FontWeight.bold,
              fontFamily: 'monospace',
              fontSize: 14,
            ),
          ),
        ),
        iconTheme: IconThemeData(
          color: widget.candidate['color'],
          size: 24,
        ),
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black,
            border: Border.all(color: widget.candidate['color'], width: 2),
          ),
          child: IconButton(
            icon: Icon(Icons.arrow_back, color: widget.candidate['color']),
            onPressed: () => Navigator.of(context).pop(),
            padding: EdgeInsets.zero,
          ),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Container(
            margin: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 3),
            ),
            child: Stack(
              children: [
                // 픽셀 아트 방 배경
                _buildPixelRoom(),
                // 후보자 캐릭터
                _buildCandidateCharacter(),
                // 인터랙티브 오브젝트들
                ..._buildRoomObjects(),
                // 대화창
                _buildDialogBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPixelRoom() {
    return Container(
      width: double.infinity,
      height: 600, // 높이를 다시 600으로 설정
      child: Stack(
        children: [
          // 배경 이미지
          Positioned.fill(
            child: Image.asset(
              'assets/images/room_background.png',
              fit: BoxFit.cover, // 이미지를 더 크게 보이도록 cover로 변경
              errorBuilder: (context, error, stackTrace) {
                // 이미지 로드 실패시 기본 배경
                return Stack(
                  children: [
                    // 방 배경 (회색 벽)
                    Container(
                      decoration: const BoxDecoration(
                        color: Color(0xFFB0B0B0),
                      ),
                    ),
                    // 바닥
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      height: 100,
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Color(0xFF8B7355), // 나무 바닥색
                        ),
                        child: CustomPaint(
                          painter: FloorPatternPainter(),
                        ),
                      ),
                    ),
                    // 벽 패턴
                    Positioned.fill(
                      child: CustomPaint(
                        painter: WallPatternPainter(),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          // 천장 조명 (배경 이미지 위에 오버레이) - 위치 조정
          _buildCeilingLight(),
          // 창문 (배경 이미지 위에 오버레이) - 위치 조정
          _buildWindow(),
        ],
      ),
    );
  }

  Widget _buildCeilingLight() {
    return Positioned(
      top: 50,
      left: 350, // 중앙으로 조정
      child: Column(
        children: [
          // 조명 고리
          Container(
            width: 60,
            height: 8,
            decoration: BoxDecoration(
              color: const Color(0xFF404040),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 4),
          // 조명
          Container(
            width: 80,
            height: 80,
            decoration: const BoxDecoration(
              color: Color(0xFFFFF8DC),
              shape: BoxShape.circle,
            ),
            child: Container(
              margin: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Color(0xFFFFFFE0),
                shape: BoxShape.circle,
              ),
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Color(0xFFFFFFF0),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWindow() {
    return Positioned(
      top: 80,
      right: 50,
      child: Container(
        width: 120,
        height: 100,
        decoration: BoxDecoration(
          color: const Color(0xFF404040),
          border: Border.all(color: Colors.black, width: 2),
        ),
        child: Container(
          margin: const EdgeInsets.all(4),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF87CEEB),
                    border: Border.all(color: const Color(0xFF404040), width: 1),
                  ),
                ),
              ),
              Container(width: 2, color: const Color(0xFF404040)),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF87CEEB),
                    border: Border.all(color: const Color(0xFF404040), width: 1),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCandidateCharacter() {
    return Positioned(
      bottom: 120, // 위치 조정
      left: 100,   // 위치 조정
      child: Column(
        children: [
          // 후보자 이름
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.black,
              border: Border.all(color: widget.candidate['color'], width: 2),
            ),
            child: Text(
              widget.candidate['name'],
              style: TextStyle(
                color: widget.candidate['color'],
                fontSize: 12,
                fontWeight: FontWeight.bold,
                fontFamily: 'monospace',
              ),
            ),
          ),
          const SizedBox(height: 8),
          // 픽셀 아트 캐릭터
          _buildPixelCharacter(),
        ],
      ),
    );
  }

  Widget _buildPixelCharacter() {
    final candidateId = widget.candidate['id'];
    
    // 각 후보별 아바타 이미지 매칭
    String avatarPath;
    switch (candidateId) {
      case 'lee_jae_myung':
        avatarPath = 'assets/images/avatar_1.png';
        break;
      case 'kim_moon_soo':
        avatarPath = 'assets/images/avatar_2.png';
        break;
      case 'lee_jun_seok':
        avatarPath = 'assets/images/avatar_4.png';
        break;
      case 'kwon_young_guk':
        avatarPath = 'assets/images/avatar_5.png';
        break;
      default:
        avatarPath = 'assets/images/avatar_1.png';
    }

    return Container(
      width: 120,
      height: 120,
      child: Image.asset(
        avatarPath,
        fit: BoxFit.contain, // 이미지 전체가 보이도록 변경
        errorBuilder: (context, error, stackTrace) {
          // 이미지 로드 실패시 기본 픽셀 캐릭터 표시
          return _buildDefaultCharacter();
        },
      ),
    );
  }

  Widget _buildDefaultCharacter() {
    return Container(
      width: 64,
      height: 96,
      decoration: BoxDecoration(
        color: Colors.grey,
        border: Border.all(color: Colors.black, width: 2),
      ),
      child: const Center(
        child: Text('?', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
      ),
    );
  }

  List<Widget> _buildRoomObjects() {
    return [
      // 책장
      _buildBookshelf(),
      // 소파
      _buildSofa(),
      // 책상
      _buildDesk(),
      // 화분
      _buildPlant(),
    ];
  }

  Widget _buildBookshelf() {
    return Positioned(
      left: 50,
      top: 150,
      child: GestureDetector(
        onTap: () => _showPolicyDialog('정책 자료실', '${widget.candidate['name']} 후보의 상세 정책을 확인해보세요!'),
        child: Container(
          width: 80,
          height: 120,
          decoration: BoxDecoration(
            color: const Color(0xFF8B4513),
            border: Border.all(color: Colors.black, width: 2),
          ),
          child: Column(
            children: [
              Container(height: 2, color: const Color(0xFF654321)),
              Expanded(
                child: Row(
                  children: [
                    Container(width: 2, color: const Color(0xFF654321)),
                    Expanded(
                      child: Container(
                        color: const Color(0xFFFFFFE0),
                        child: Column(
                          children: List.generate(6, (index) => 
                            Container(
                              height: 18,
                              margin: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: [
                                  const Color(0xFFFF6B6B),
                                  const Color(0xFF4ECDC4),
                                  const Color(0xFF45B7D1),
                                  const Color(0xFF96CEB4),
                                  const Color(0xFFFECA57),
                                  const Color(0xFFFF9FF3),
                                ][index],
                                border: Border.all(color: Colors.black, width: 1),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(width: 2, color: const Color(0xFF654321)),
                  ],
                ),
              ),
              Container(height: 2, color: const Color(0xFF654321)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSofa() {
    return Positioned(
      left: 300,
      bottom: 150,
      child: GestureDetector(
        onTap: () => _showPolicyDialog('편안한 대화', '${widget.candidate['name']} 후보와 편안하게 대화해보세요!'),
        child: Container(
          width: 120,
          height: 60,
          child: Stack(
            children: [
              // 소파 등받이
              Container(
                width: 120,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFF4A90E2),
                  border: Border.all(color: Colors.black, width: 2),
                ),
              ),
              // 소파 쿠션
              Positioned(
                bottom: 0,
                child: Container(
                  width: 120,
                  height: 30,
                  decoration: BoxDecoration(
                    color: const Color(0xFF357ABD),
                    border: Border.all(color: Colors.black, width: 2),
                  ),
                ),
              ),
              // 소파 팔걸이
              Positioned(
                left: 0,
                child: Container(
                  width: 15,
                  height: 60,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2E5984),
                    border: Border.all(color: Colors.black, width: 2),
                  ),
                ),
              ),
              Positioned(
                right: 0,
                child: Container(
                  width: 15,
                  height: 60,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2E5984),
                    border: Border.all(color: Colors.black, width: 2),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDesk() {
    return Positioned(
      right: 50,
      bottom: 200,
      child: GestureDetector(
        onTap: () => _showPolicyDialog('업무 자료', '${widget.candidate['name']} 후보의 업무 계획을 살펴보세요!'),
        child: Container(
          width: 100,
          height: 80,
          child: Stack(
            children: [
              // 책상 상판
              Container(
                width: 100,
                height: 15,
                decoration: BoxDecoration(
                  color: const Color(0xFF8B4513),
                  border: Border.all(color: Colors.black, width: 2),
                ),
              ),
              // 책상 다리
              Positioned(
                top: 15,
                child: Container(
                  width: 100,
                  height: 65,
                  decoration: BoxDecoration(
                    color: const Color(0xFF654321),
                    border: Border.all(color: Colors.black, width: 2),
                  ),
                  child: Row(
                    children: [
                      Container(width: 8, color: const Color(0xFF4A2C17)),
                      Expanded(child: Container()),
                      Container(width: 8, color: const Color(0xFF4A2C17)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlant() {
    return Positioned(
      right: 200,
      top: 200,
      child: GestureDetector(
        onTap: () => _showPolicyDialog('환경 정책', '${widget.candidate['name']} 후보의 환경 정책을 확인해보세요!'),
        child: Container(
          width: 40,
          height: 80,
          child: Column(
            children: [
              // 식물 잎
              Container(
                width: 40,
                height: 50,
                decoration: const BoxDecoration(
                  color: Color(0xFF4CAF50),
                  shape: BoxShape.circle,
                ),
                child: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Color(0xFF66BB6A),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              // 화분
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: const Color(0xFF8D6E63),
                  border: Border.all(color: Colors.black, width: 2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDialogBox() {
    return Positioned(
      bottom: 20,
      left: 20,
      right: 20,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.black,
          border: Border.all(color: widget.candidate['color'], width: 3),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '안녕하세요, ${widget.candidate['name']}입니다!',
              style: TextStyle(
                color: widget.candidate['color'],
                fontSize: 14,
                fontWeight: FontWeight.bold,
                fontFamily: 'monospace',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '방 안의 오브젝트들을 클릭해서\n제 정책과 비전을 확인해보세요!',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontFamily: 'monospace',
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPolicyDialog(String title, String description) {
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
              border: Border.all(color: widget.candidate['color'], width: 3),
            ),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF2C2C2C),
                border: Border.all(color: widget.candidate['color'], width: 1),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: widget.candidate['color'],
                      border: Border.all(color: Colors.black, width: 2),
                    ),
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontFamily: 'monospace',
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      border: Border.all(color: widget.candidate['color'], width: 1),
                    ),
                    child: Text(
                      description,
                      style: const TextStyle(
                        fontSize: 14,
                        height: 1.5,
                        color: Colors.white,
                        fontFamily: 'monospace',
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      color: widget.candidate['color'],
                      border: Border.all(color: Colors.black, width: 2),
                    ),
                    child: TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        shape: const RoundedRectangleBorder(),
                      ),
                      child: const Text(
                        '닫기',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'monospace',
                        ),
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
}

class FloorPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint1 = Paint()..color = const Color(0xFF6B4E3D);
    final paint2 = Paint()..color = const Color(0xFF8B7355);
    
    // 나무 바닥 패턴
    for (int i = 0; i < size.width; i += 20) {
      canvas.drawRect(
        Rect.fromLTWH(i.toDouble(), 0, 18, size.height),
        i % 40 == 0 ? paint1 : paint2,
      );
      // 나무 결 표현
      canvas.drawLine(
        Offset(i.toDouble() + 18, 0),
        Offset(i.toDouble() + 18, size.height),
        Paint()..color = Colors.black..strokeWidth = 1,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class WallPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = const Color(0xFF909090);
    
    // 벽 텍스처
    for (int i = 0; i < size.width; i += 4) {
      for (int j = 0; j < size.height - 100; j += 4) {
        if ((i + j) % 8 == 0) {
          canvas.drawRect(Rect.fromLTWH(i.toDouble(), j.toDouble(), 2, 2), paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
} 