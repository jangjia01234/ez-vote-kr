import 'package:flutter/material.dart';
import 'dart:async';
import '../services/bgm_service.dart';
import '../services/analytics_service.dart';

class CandidateRoomDetail extends StatefulWidget {
  final Map<String, dynamic> candidate;

  const CandidateRoomDetail({super.key, required this.candidate});

  @override
  State<CandidateRoomDetail> createState() => _CandidateRoomDetailState();
}

class _CandidateRoomDetailState extends State<CandidateRoomDetail> {
  final DateTime electionDay = DateTime(2025, 6, 3); // 2025년 6월 3일 선거일

  @override
  void initState() {
    super.initState();
    // 후보 방 상세 화면 방문 추적
    AnalyticsService.trackPageView('candidate_room_${widget.candidate['id']}');
  }

  @override
  void dispose() {
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: LayoutBuilder(
          builder: (context, constraints) {
            // 모바일 크기로 고정 (iPhone 14 기준)
            const double mobileWidth = 390;
            const double mobileHeight = 844;
            
            return Stack(
              children: [
                // 모바일 크기로 고정된 게임 화면
                Container(
                  width: mobileWidth,
                  height: mobileHeight,
                  child: Stack(
                    children: [
                      // 픽셀 아트 방 배경
                      _buildPixelRoom(),
                      // 후보자 캐릭터
                      _buildCandidateCharacter(mobileWidth, mobileHeight),
                      // 인터랙티브 오브젝트들
                      ..._buildRoomObjects(mobileWidth, mobileHeight),
                      // 대화창
                      _buildDialogBox(),
                    ],
                  ),
                ),
                // 뒤로가기 버튼을 좌상단에 배치
                Positioned(
                  top: 20,
                  left: 20,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ),
                // BGM 플레이어를 뒤로가기 버튼 옆에 배치
                Positioned(
                  top: 20,
                  left: 70,
                  child: _buildBgmPlayer(),
                ),
                // D-Day 카운터를 우상단에 배치
                Positioned(
                  top: 20,
                  right: 20,
                  child: _buildSimpleDDayCounter(),
                ),
                // 제목을 우하단에 배치
                Positioned(
                  bottom: 20,
                  right: 20,
                  child: Container(
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
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildPixelRoom() {
    final candidateId = widget.candidate['id'];
    
    // 각 후보별 빈 배경 이미지 매칭 (오브젝트 배치용)
    String backgroundPath;
    switch (candidateId) {
      case 'lee_jae_myung':
        backgroundPath = 'assets/images/candidate_1/room_background_1_empty.png';
        break;
      case 'kim_moon_soo':
        backgroundPath = 'assets/images/candidate_2/room_background_2_empty.png';
        break;
      case 'lee_jun_seok':
        backgroundPath = 'assets/images/candidate_4/room_background_4_empty.png';
        break;
      case 'kwon_young_guk':
        backgroundPath = 'assets/images/candidate_5/room_background_5_empty.png';
        break;
      default:
        backgroundPath = 'assets/images/candidate_1/room_background_1_empty.png';
    }

    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [
          // 배경 이미지
          Positioned.fill(
            child: Image.asset(
              backgroundPath,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                print('이미지 로드 실패: $error');
                return Container(
                  color: const Color(0xFFE8DCC0),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.image_not_supported,
                          size: 64,
                          color: widget.candidate['color'],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '배경 이미지를 불러올 수 없습니다',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: widget.candidate['color'],
                            fontFamily: 'monospace',
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '($backgroundPath)',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
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
        ],
      ),
    );
  }

  Widget _buildCandidateCharacter(double screenWidth, double screenHeight) {
    return Positioned(
      bottom: 127.0,  // 390x844 기준 절대 좌표
      left: 31.0,     // 390x844 기준 절대 좌표
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
          // 아바타 이미지
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
        avatarPath = 'assets/images/candidate_1/avatar_1.png';
        break;
      case 'kim_moon_soo':
        avatarPath = 'assets/images/candidate_2/avatar_2.png';
        break;
      case 'lee_jun_seok':
        avatarPath = 'assets/images/candidate_4/avatar_4.png';
        break;
      case 'kwon_young_guk':
        avatarPath = 'assets/images/candidate_5/avatar_5.png';
        break;
      default:
        avatarPath = 'assets/images/candidate_1/avatar_1.png';
    }

    return Container(
      width: 120,
      height: 120,
      child: Image.asset(
        avatarPath,
        fit: BoxFit.contain,
        width: 120,
        height: 120,
        errorBuilder: (context, error, stackTrace) {
          print('이미지 로드 실패: $error');
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

  List<Widget> _buildRoomObjects(double screenWidth, double screenHeight) {
    // 이재명 후보의 경우 실제 이미지 오브젝트 사용 (390x844 기준 절대 좌표)
    if (widget.candidate['id'] == 'lee_jae_myung') {
      return [
        // 화분 (기후·녹색산업)
        _buildImageObject(
          'assets/images/candidate_1/room_flowerPot.png',
          left: 0,
          top: 100.0,
          width: 126.0,
          height: 126.0,
          title: '🌱 기후위기? 우리도 준비해야죠',
          description: '⚡ 석탄 발전소는 줄이고, 태양광·풍력 같은 재생에너지를 더 많이 쓸 거예요.\n\n'
              '💼 친환경 기술을 키워서 일자리도 만들고, 탄소도 줄이고!\n\n'
              '🌍 기후위기 대응은 우리만 할 수 없으니, 국제 협력도 열심히 할게요.',
        ),
        // 컴퓨터 (디지털 전환) - 크기 1.5배, 중앙 배치
        _buildImageObject(
          'assets/images/candidate_1/room_computer.png',
          left: 50.0,
          top: 260.0,
          width: 234.0,
          height: 195.0,
          title: '🤖 AI 시대, 놓치지 않을 거예요',
          description: '💻 AI 쓸 수 있는 환경을 더 쉽게 만들고, 고성능 장비도 많이 확보할 계획이에요.\n\n'
              '🆓 누구나 AI를 무료로 활용할 수 있는 \'모두의 AI\' 프로젝트도 준비 중!\n\n'
              '🎬 콘텐츠랑 방산 산업도 밀어줘서, 새로운 먹거리를 만들게요.',
        ),
        // 아파트 (기본주택)
        _buildImageObject(
          'assets/images/candidate_1/room_apartment.png',
          right: 5.0,
          bottom: 211.0,
          width: 129.0,
          height: 109.0,
          title: '🏠 집 걱정, 덜어드릴게요',
          description: '🗺️ 전국을 5대 권역으로 나눠 균형 발전을 추진하고, 세종에는 대통령 집무실도 만들 예정이에요.\n\n'
              '👫 청년·신혼부부를 위한 집을 많이 지어서 내 집 마련 꿈에 가까이!\n\n'
              '💰 지역화폐 확대도 약속할게요. 동네 가게가 다시 살아날지도?',
        ),
        // 서류봉투 (개헌 추진)
        _buildImageObject(
          'assets/images/candidate_1/room_suitcase.png',
          left: 120.0,
          bottom: 152.0,
          width: 98.0,
          height: 74.0,
          title: '📜 권력, 혼자 쓰지 마세요',
          description: '🚫 대통령이 너무 많은 권한을 갖는 건 NO. 국회와 나누자는 거예요.\n\n'
              '⚖️ 검찰은 정치 개입 못 하게 제도 손질하고, 판사·검사도 다양하게 뽑을 계획!\n\n'
              '👥 국민 참여 재판도 더 확대해서 사법 신뢰도 올릴게요.',
        ),
      ];
    }
    
    // 김문수 후보의 경우 실제 이미지 오브젝트 사용 (390x844 기준 절대 좌표)
    if (widget.candidate['id'] == 'kim_moon_soo') {
      return [
        // 기차 (교통·인프라) - 침대 아래쪽에 배치
        _buildImageObject(
          'assets/images/candidate_2/room_train.png',
          left: 254.0,
          bottom: 130.0,
          width: 137.0,
          height: 98.0,
          title: '🚄 어디든 2시간이면 도착!',
          description: '🗺️ 수도권부터 지방까지 빠르게 연결하는 교통망을 만들 계획이에요.\n\n'
              '🚗 자율주행차 달리는 스마트한 도로도 구상 중!\n\n'
              '🚁 드론으로 택배 받는 시대, 멀지 않았어요.',
        ),
        // 돈통 (경제·세제) - 책장 바로 옆에 배치
        _buildImageObject(
          'assets/images/candidate_2/room_moneybox.png',
          right: 90.0,
          top: 280.0,
          width: 125.0,
          height: 133.0,
          title: '💰 기업이 잘 돼야 우리도 잘 살죠',
          description: '💸 법인세랑 상속세는 낮추고, 주 52시간 제도는 유연하게 바꿀 거예요.\n\n'
              '🚫 신산업에 발목 잡는 규제는 과감히 없애고요.\n\n'
              '📈 기업이 자유롭게 투자할 수 있도록 환경을 개선할게요.',
        ),
        // 군모 (안보·국방) - 책장 위에 배치
        _buildImageObject(
          'assets/images/candidate_2/room_militarycap.png',
          left: 10.0,
          top: 350.0,
          width: 98.0,
          height: 86.0,
          title: '🛡️ 힘이 있어야 지킬 수 있어요',
          description: '🚀 북핵 대응을 위해 전술핵 재배치 같은 방안도 검토 중이에요.\n\n'
              '🤝 미국이랑 군사 협력을 더 단단히 하고, 사이버 공격도 막을 수 있게 대비할게요.\n\n'
              '⭐ 군인 복무 환경도 업그레이드!',
        ),
        // 법전 (법무·정의) - 침대 위에 배치
        _buildImageObject(
          'assets/images/candidate_2/room_lawbook.png',
          right: 5.0,
          top: 278.0,
          width: 66.0,
          height: 89.0,
          title: '⚖️ 법은 누구에게나 공평해야 하니까',
          description: '🚨 불법 시위나 폭력엔 단호하게 대응하겠어요.\n\n'
              '🔍 검찰 수사력은 더 강하게 해서 범죄에 빠르게 대응하고,\n\n'
              '💻 요즘 늘어난 디지털 범죄도 놓치지 않겠어요.',
        ),
      ];
    }
    
    // 이준석 후보의 경우 실제 이미지 오브젝트 사용 (390x844 기준 절대 좌표)
    if (widget.candidate['id'] == 'lee_jun_seok') {
      return [
        // 테이블 (정치개혁)
        _buildImageObject(
          'assets/images/candidate_4/room_table.png',
          left: 60.0,
          top: 260.0,
          width: 137.0,
          height: 118.0,
          title: '🔥 낡은 정치, 리셋할 시간',
          description: '🗳️ 대통령 4년 중임제 도입하고, 결선투표제도 만들게요.\n\n'
              '📢 국회 의원이 책임감 있게 일하도록 국민소환제도 추진하고요.\n\n'
              '🏛️ 수도기능을 지방으로 분산해서 지역도 같이 크도록!',
        ),
        // 플라스크 (과학기술)
        _buildImageObject(
          'assets/images/candidate_4/room_plask.png',
          right: 5.0,
          top: 270.0,
          width: 78.0,
          height: 89.0,
          title: '🚀 과학기술로 한 단계 더',
          description: '👨‍🔬 과학기술인 대우를 높이고, 연구자들이 일하기 좋은 환경 만들기!\n\n'
              '💊 K-바이오 산업 키워서 세계 무대에서도 경쟁력 있게\n\n'
              '🤖 위험한 일은 로봇이 대신하도록 산업에 로봇 기술도 더 활용할게요.',
        ),
        // 서류 (교육개혁)
        _buildImageObject(
          'assets/images/candidate_4/room_document.png',
          left: 150.0,
          bottom: 200.0,
          width: 109.0,
          height: 86.0,
          title: '📚 선생님이 지켜져야 학교도 지켜지죠',
          description: '👩‍🏫 교사가 부당하게 소송에 시달리지 않도록 \'국가책임제\' 도입!\n\n'
              '🚫 허위 신고 막는 장치도 넣고, 문제 학생은 전문 상담사가 도와요.\n\n'
              '💪 교권 회복에 꽤 진심이에요.',
        ),
        // 책 (청년정책)
        _buildImageObject(
          'assets/images/candidate_4/room_book.png',
          right: 20.0,
          bottom: 211.0,
          width: 96.0,
          height: 108.0,
          title: '💪 청년, 든든하게 시작하자',
          description: '💰 최대 5천만 원까지 청년 자립 자금 지원!\n\n'
              '🚀 창업하고 싶은 사람에겐 투자와 멘토링도 제공해요.\n\n'
              '🏠 일자리, 주거 등 청년 지원을 전방위로 할게요.',
        ),
      ];
    }
    
    // 권영국 후보의 경우 실제 이미지 오브젝트 사용 (390x844 기준 절대 좌표)
    if (widget.candidate['id'] == 'kwon_young_guk') {
      return [
        // 저울 (사회정의)
        _buildImageObject(
          'assets/images/candidate_5/room_scale.png',
          left: 5.0,
          top: 100.0,
          width: 109.0,
          height: 98.0,
          title: '⚖️ 더 평등한 사회로',
          description: '💰 부자한텐 더 많이, 어려운 사람에겐 더 따뜻하게.\n\n'
              '👷 모든 노동자에게 권리를 보장하고, 사회안전망도 넓힐 계획이에요.\n\n'
              '👀 정치인이나 대기업도 잘못하면 시민이 감시할 수 있도록!',
        ),
        // 식물 (환경정책)
        _buildImageObject(
          'assets/images/candidate_5/room_plant.png',
          right: 31.0,
          top: 152.0,
          width: 98.0,
          height: 117.0,
          title: '🌍 기후위기, 우리도 할 수 있어요',
          description: '💸 탄소세 도입해서 친환경 산업으로 전환하고,\n\n'
              '⚡ 재생에너지를 더 많이 써서 탈탄소 사회로 나아갈게요.\n\n'
              '🌱 깨끗한 지구, 다음 세대에게 물려주자는 거죠!',
        ),
        // 헬멧 (노동정책)
        _buildImageObject(
          'assets/images/candidate_5/room_helmet.png',
          left: 30.0,
          bottom: 290.0,
          width: 86.0,
          height: 78.0,
          title: '💪 일하는 사람이 주인공',
          description: '📅 주 4일제, 최저임금 인상, 안전한 일터 만들기까지!\n\n'
              '🛡️ 과로사나 산재 걱정 없이 일할 수 있는 환경을 약속할게요.\n\n'
              '⚖️ 워라밸 있는 삶, 가능할지도?',
        ),
        // 담요 (복지정책)
        _buildImageObject(
          'assets/images/candidate_5/room_blanket.png',
          right: 0,
          bottom: 350.0,
          width: 128.0,
          height: 108.0,
          title: '🤗 돌봄이 필요한 모두에게',
          description: '🏥 감기부터 큰 병까지, 치료비 걱정 없이!\n\n'
              '👶 아이 낳고 키우는 데 필요한 보육·육아비 지원도 늘릴 계획이에요.\n\n'
              '👴 어르신들에겐 연금을 확 올려서, 걱정 없이 지낼 수 있도록 할게요.',
        ),
      ];
    }
    
    // 다른 후보들은 기존 픽셀 오브젝트 사용 (화면 크기에 맞게 조정)
    return [
      // 책장
      _buildBookshelf(screenWidth, screenHeight),
      // 소파
      _buildSofa(screenWidth, screenHeight),
      // 책상
      _buildDesk(screenWidth, screenHeight),
      // 화분
      _buildPlant(screenWidth, screenHeight),
    ];
  }

  Widget _buildBookshelf(double screenWidth, double screenHeight) {
    return Positioned(
      left: 55.0,
      top: 211.0,
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

  Widget _buildSofa(double screenWidth, double screenHeight) {
    return Positioned(
      right: 55.0,
      bottom: 211.0,
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

  Widget _buildDesk(double screenWidth, double screenHeight) {
    return Positioned(
      right: 55.0,
      bottom: 278.0,
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

  Widget _buildPlant(double screenWidth, double screenHeight) {
    return Positioned(
      left: 176.0,
      top: 278.0,
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

  Widget _buildImageObject(
    String imagePath, {
    double? left,
    double? right,
    double? top,
    double? bottom,
    required double width,
    required double height,
    required String title,
    required String description,
  }) {
    return Positioned(
      left: left,
      right: right,
      top: top,
      bottom: bottom,
      child: GestureDetector(
        onTap: () => _showPolicyDialog(title, description),
        child: Container(
          width: width,
          height: height,
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              child: Image.asset(
                imagePath,
                fit: BoxFit.contain,
                width: width,
                height: height,
                errorBuilder: (context, error, stackTrace) {
                  print('이미지 로드 실패: $error');
                  return Container(
                    decoration: BoxDecoration(
                      color: widget.candidate['color'].withOpacity(0.3),
                      border: Border.all(color: Colors.black, width: 2),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.image_not_supported,
                            color: widget.candidate['color'],
                            size: 24,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '이미지 로드 실패',
                            style: TextStyle(
                              fontSize: 8,
                              color: widget.candidate['color'],
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
          ),
        ),
      ),
    );
  }

  Widget _buildDialogBox() {
    return Positioned(
      bottom: 10,
      left: 10,
      right: 10,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.black,
          border: Border.all(color: widget.candidate['color'], width: 3),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '어서오세요, 제 방에 오신 것을 환영합니다!',
              style: TextStyle(
                color: widget.candidate['color'],
                fontSize: 14,
                fontWeight: FontWeight.bold,
                fontFamily: 'monospace',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '방 안의 물건들을 터치해서\n제 정책과 앞으로의 비전을 확인해보세요!',
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

  void _showPolicyDialog(String title, String description) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 500, maxHeight: 600),
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
                  // 제목 헤더
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: widget.candidate['color'],
                      border: Border.all(color: Colors.black, width: 2),
                    ),
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontFamily: 'monospace',
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // 내용 스크롤 가능한 영역
                  Flexible(
                    child: SingleChildScrollView(
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          border: Border.all(color: widget.candidate['color'], width: 1),
                        ),
                        child: Text(
                          description,
                          style: const TextStyle(
                            fontSize: 13,
                            height: 1.6,
                            color: Colors.white,
                            fontFamily: 'monospace',
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // 후보자 정보
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: widget.candidate['color'].withOpacity(0.2),
                      border: Border.all(color: widget.candidate['color'], width: 1),
                    ),
                    child: Text(
                      '${widget.candidate['name']} (${widget.candidate['party']})',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: widget.candidate['color'],
                        fontFamily: 'monospace',
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // 닫기 버튼
                  Container(
                    decoration: BoxDecoration(
                      color: widget.candidate['color'],
                      border: Border.all(color: Colors.black, width: 2),
                    ),
                    child: TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                        shape: const RoundedRectangleBorder(),
                      ),
                      child: const Text(
                        '닫기',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'monospace',
                          fontSize: 14,
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