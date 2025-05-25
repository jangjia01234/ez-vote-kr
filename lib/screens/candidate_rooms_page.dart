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
      'roomImage': '🏠',
      'supportRate': 45,
    },
    {
      'id': 'kim_moon_soo',
      'name': '김문수',
      'party': '국민의힘',
      'color': Color(0xFFE53935),
      'roomImage': '🏡',
      'supportRate': 36,
    },
    {
      'id': 'lee_jun_seok',
      'name': '이준석',
      'party': '개혁신당',
      'color': Color(0xFFFF6600),
      'roomImage': '🏘️',
      'supportRate': 10,
    },
    {
      'id': 'kwon_young_guk',
      'name': '권영국',
      'party': '진보당',
      'color': Color(0xFFFFD700),
      'roomImage': '🏰',
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
      backgroundColor: const Color(0xFF008080),
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
                constraints: const BoxConstraints(maxWidth: 600),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      _buildHeader(),
                      const SizedBox(height: 20),
                      _buildDDayCounter(),
                      const SizedBox(height: 20),
                      _buildCandidateRooms(context),
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
        color: const Color(0xFFC0C0C0),
        border: Border.all(color: const Color(0xFF808080), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 0,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF000080),
              border: Border.all(color: Colors.black, width: 1),
            ),
            child: const Text(
              '🗳️ 2025 대선 후보 방 구경하기',
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
            '각 후보의 방을 클릭해서 정책을 알아보세요!',
            style: TextStyle(
              fontSize: 14,
              color: Colors.black,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDDayCounter() {
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
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFFC0C0C0),
            border: Border.all(color: const Color(0xFF808080), width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 0,
                offset: const Offset(2, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF800000),
                  border: Border.all(color: Colors.black, width: 1),
                ),
                child: const Text(
                  '⏰ 2025년 대선까지',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'monospace',
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildTimeBox(days, '일'),
                  const SizedBox(width: 8),
                  _buildTimeBox(hours, '시간'),
                  const SizedBox(width: 8),
                  _buildTimeBox(minutes, '분'),
                  const SizedBox(width: 8),
                  _buildTimeBox(seconds, '초'),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTimeBox(int value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border.all(color: const Color(0xFF808080), width: 1),
      ),
      child: Column(
        children: [
          Text(
            value.toString().padLeft(2, '0'),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF00FF00),
              fontFamily: 'monospace',
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              color: Color(0xFF00FF00),
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCandidateRooms(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFC0C0C0),
        border: Border.all(color: const Color(0xFF808080), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 0,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF000080),
              border: Border.all(color: Colors.black, width: 1),
            ),
            child: const Text(
              '🏠 후보별 방 구경하기',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'monospace',
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 180,
            child: Row(
              children: candidates.asMap().entries.map((entry) {
                final candidate = entry.value;
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: entry.key < candidates.length - 1 ? 8 : 0,
                    ),
                    child: _buildCandidateRoom(context, candidate),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCandidateRoom(BuildContext context, Map<String, dynamic> candidate) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CandidateRoomDetail(candidate: candidate),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: candidate['color'],
          border: Border.all(color: Colors.black, width: 3),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 0,
              offset: const Offset(3, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            // 문 상단 - 후보명 명패
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.8),
                border: const Border(
                  bottom: BorderSide(color: Colors.black, width: 2),
                ),
              ),
              child: Text(
                candidate['name'],
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'monospace',
                ),
                textAlign: TextAlign.center,
              ),
            ),
            // 문 본체
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFC0C0C0),
                  border: const Border(
                    top: BorderSide(color: Colors.black, width: 1),
                  ),
                ),
                child: Stack(
                  children: [
                    // 왼쪽 방 아이콘
                    Positioned(
                      left: 8,
                      top: 20,
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.black, width: 1),
                        ),
                        child: Center(
                          child: Text(
                            candidate['roomImage'],
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                    // 가운데 정당명
                    Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.black, width: 1),
                        ),
                        child: Text(
                          candidate['party'],
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontFamily: 'monospace',
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    // 오른쪽 문손잡이
                    Positioned(
                      right: 8,
                      top: 30,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFD700),
                          border: Border.all(color: Colors.black, width: 1),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 0,
                              offset: const Offset(1, 1),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}