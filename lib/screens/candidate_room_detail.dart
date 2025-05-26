import 'package:flutter/material.dart';
import 'dart:async';
import '../services/bgm_service.dart';

class CandidateRoomDetail extends StatefulWidget {
  final Map<String, dynamic> candidate;

  const CandidateRoomDetail({super.key, required this.candidate});

  @override
  State<CandidateRoomDetail> createState() => _CandidateRoomDetailState();
}

class _CandidateRoomDetailState extends State<CandidateRoomDetail> {
  final DateTime electionDay = DateTime(2025, 6, 3);

  @override
  void initState() {
    super.initState();
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
          title: '🌱 지구를 살리는 녹색 경제',
          description: '지구가 아파하고 있어요 😢 이제 우리가 나서야 할 때!\n\n'
              '☀️ 태양과 바람으로 전기 만들기\n'
              '석탄 대신 태양광·풍력으로 전기를 만들어서\n'
              '전기료도 줄이고 공기도 깨끗하게! 일석이조 💪\n\n'
              '💼 환경 지키면서 돈도 벌기\n'
              '친환경 기업들이 늘어나면 새로운 일자리가\n'
              '100만 개나 생겨요! 청년들한테 좋은 소식 🎉\n\n'
              '🚗 깨끗한 교통수단으로 바꾸기\n'
              '전기차, 수소차 타고 다니면서\n'
              '미세먼지 없는 하늘을 만들어봐요!',
        ),
        // 컴퓨터 (디지털 전환) - 크기 1.5배, 중앙 배치
        _buildImageObject(
          'assets/images/candidate_1/room_computer.png',
          left: 50.0,
          top: 260.0,
          width: 234.0,
          height: 195.0,
          title: '🤖 AI 시대, 우리도 준비하자!',
          description: '스마트폰처럼 AI도 이제 일상이 될 거예요! 🚀\n\n'
              '🧠 AI 전문가 10만 명 키우기\n'
              '코딩 몰라도 괜찮아요! AI 쓰는 법부터\n'
              '만드는 법까지 차근차근 가르쳐드려요 📚\n\n'
              '📱 모든 민원을 집에서 해결\n'
              '구청 가서 줄 설 필요 없이 핸드폰으로\n'
              '뚝딱! 주민등록등본부터 각종 신청까지 ✨\n\n'
              '💰 데이터로 돈 벌기\n'
              '우리가 만든 데이터를 안전하게 활용해서\n'
              '새로운 사업과 일자리를 만들어요!',
        ),
        // 아파트 (기본주택)
        _buildImageObject(
          'assets/images/candidate_1/room_apartment.png',
          right: 5.0,
          bottom: 211.0,
          width: 129.0,
          height: 109.0,
          title: '🏠 내 집 마련의 꿈을 현실로!',
          description: '집값 때문에 고민이세요? 이제 걱정 끝! 🎯\n\n'
              '🏘️ 매년 50만 채 새집 짓기\n'
              '시세보다 훨씬 저렴한 가격으로\n'
              '청년, 신혼부부가 먼저 들어갈 수 있어요! 🥰\n\n'
              '💸 월세 폭등 이제 그만!\n'
              '1년에 5%씩만 오를 수 있도록 제한하고\n'
              '전세사기 당해도 국가가 책임져요 🛡️\n\n'
              '🚇 지하철역 근처에 집 많이 짓기\n'
              '출퇴근 편한 곳에 아파트를 더 많이 지어서\n'
              '집값도 안정시키고 교통비도 절약!',
        ),
        // 서류봉투 (개헌 추진)
        _buildImageObject(
          'assets/images/candidate_1/room_suitcase.png',
          left: 120.0,
          bottom: 152.0,
          width: 98.0,
          height: 74.0,
          title: '📜 정치 시스템을 바꿔보자!',
          description: '대통령이 너무 강하다고 생각하지 않나요? 🤔\n\n'
              '👑 대통령 권력 나누기\n'
              '한 사람이 모든 걸 결정하는 게 아니라\n'
              '국회와 함께 나눠서 결정하도록! 균형이 중요해요 ⚖️\n\n'
              '🗳️ 더 공정한 선거 만들기\n'
              '작은 정당도 국회에 들어갈 수 있게 하고\n'
              '18세부터 투표할 수 있도록! 젊은 목소리도 중요하죠 📢\n\n'
              '🏛️ 검찰과 법원 독립시키기\n'
              '정치 눈치 보지 말고 오직 법과 정의만\n'
              '따라서 판단할 수 있도록!',
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
          title: '🚄 전국이 2시간 생활권!',
          description: '서울-부산도 2시간이면 OK! 어디든 쌩쌩~ 🚀\n\n'
              '🚅 KTX로 전국 연결하기\n'
              '지방에 살아도 서울 출근이 가능하도록!\n'
              '집값 비싼 서울 말고 고향에서 살아요 🏡\n\n'
              '🛣️ 스마트한 도로 만들기\n'
              '자율주행차가 달릴 수 있는 똑똑한 도로!\n'
              '교통체증? 이제 옛날 얘기가 될 거예요 😎\n\n'
              '✈️ 드론으로 택배 받기\n'
              '하늘을 나는 택배! SF 영화 같지만\n'
              '곧 현실이 될 거예요. 빠르고 편리하게! 📦',
        ),
        // 돈통 (경제·세제) - 책장 바로 옆에 배치
        _buildImageObject(
          'assets/images/candidate_2/room_moneybox.png',
          right: 90.0,
          top: 280.0,
          width: 125.0,
          height: 133.0,
          title: '💰 기업이 잘되면 우리도 잘돼요!',
          description: '경제 파이를 키워서 모두가 잘살아봐요! 📈\n\n'
              '🏢 기업하기 좋은 나라 만들기\n'
              '복잡한 규제는 줄이고 투자는 늘려서\n'
              '좋은 일자리가 많이 생기도록! 💼\n\n'
              '🏪 자영업자 부담 덜어주기\n'
              '카드 수수료 낮추고 세금도 깎아드려요\n'
              '치킨집, 카페 사장님들 힘내세요! 💪\n\n'
              '💸 세금 부담 줄이기\n'
              '열심히 일한 만큼 더 많이 가져가세요\n'
              '중산층 세금 부담을 확 줄여드릴게요!',
        ),
        // 군모 (안보·국방) - 책장 위에 배치
        _buildImageObject(
          'assets/images/candidate_2/room_militarycap.png',
          left: 10.0,
          top: 350.0,
          width: 98.0,
          height: 86.0,
          title: '🛡️ 강한 나라가 평화로운 나라!',
          description: '힘이 있어야 평화도 지킬 수 있어요! 💪\n\n'
              '🚀 최첨단 무기로 무장하기\n'
              '미국과 함께 더 강한 동맹을 만들어서\n'
              '누구도 함부로 못하게! 든든한 방패 🛡️\n\n'
              '👨‍✈️ 군인들 대우 개선하기\n'
              '나라 지키는 분들이 자랑스럽게\n'
              '복무할 수 있도록 처우를 확 개선! 🎖️\n\n'
              '🌐 사이버 공격 막기\n'
              '해킹, 가짜뉴스 같은 보이지 않는 전쟁도\n'
              '철벽 방어로 우리를 지켜요!',
        ),
        // 법전 (법무·정의) - 침대 위에 배치
        _buildImageObject(
          'assets/images/candidate_2/room_lawbook.png',
          right: 5.0,
          top: 278.0,
          width: 66.0,
          height: 89.0,
          title: '⚖️ 법과 질서가 바로 선 나라!',
          description: '범죄는 엄벌! 선량한 시민은 보호! 🚨\n\n'
              '👮‍♂️ 검찰 수사권 강화하기\n'
              '범죄자들이 법망을 피하지 못하도록\n'
              '검찰이 제대로 수사할 수 있게! 🔍\n\n'
              '🏛️ 법질서 확립하기\n'
              '불법시위, 폭력범죄는 무관용 원칙!\n'
              '법 지키는 사람이 손해 보지 않는 사회 ✊\n\n'
              '📱 디지털 시대 법 정비\n'
              '온라인 사기, 개인정보 유출 등\n'
              '새로운 범죄에도 빠르게 대응!',
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
          title: '🔥 정치판을 완전히 바꿔보자!',
          description: '기성 정치에 지쳤다면? 이제 젊은 정치의 시대! 🚀\n\n'
              '📱 스마트폰으로 투표하기\n'
              '투표소 가기 귀찮죠? 집에서 핸드폰으로\n'
              '간편하게 투표할 수 있게 만들어요! 📲\n\n'
              '💸 정치자금 실시간 공개\n'
              '누가 얼마 후원했는지 실시간으로 공개!\n'
              '뒷거래는 이제 불가능해요 🔍\n\n'
              '🗣️ 청년 목소리 정책에 반영\n'
              '온라인으로 의견 모아서 바로바로\n'
              '정책에 반영! 여러분이 정치의 주인 👑',
        ),
        // 플라스크 (과학기술)
        _buildImageObject(
          'assets/images/candidate_4/room_plask.png',
          right: 5.0,
          top: 270.0,
          width: 78.0,
          height: 89.0,
          title: '🚀 우주까지 가는 대한민국!',
          description: '과학기술로 세계 1등 국가 만들기! 🌟\n\n'
              '🌙 달에 태극기 꽂기\n'
              '우리나라 로켓으로 달까지 가서\n'
              '태극기 꽂는 그날까지! 우주강국 코리아 🇰🇷\n\n'
              '💊 K-바이오로 세계 정복\n'
              'K-팝, K-드라마 다음은 K-바이오!\n'
              '우리 기술로 만든 신약으로 전 세계를 치료 💉\n\n'
              '🤖 로봇이 일하는 세상\n'
              '위험한 일은 로봇이 대신하고\n'
              '사람은 더 창의적인 일에 집중!',
        ),
        // 서류 (교육개혁)
        _buildImageObject(
          'assets/images/candidate_4/room_document.png',
          left: 150.0,
          bottom: 200.0,
          width: 109.0,
          height: 86.0,
          title: '📚 공부가 재밌어지는 학교!',
          description: '암기 위주 교육은 이제 그만! 창의력이 폭발하는 교육 🎨\n\n'
              '🎮 게임처럼 재밌는 수업\n'
              'AI가 나만의 맞춤 문제를 내주고\n'
              '친구들과 협력해서 문제를 해결해요! 📱\n\n'
              '🌍 세계로 나가는 교육\n'
              '교환학생 기회를 늘리고 영어, 중국어\n'
              '자유자재로! 글로벌 인재로 성장 ✈️\n\n'
              '🎭 예술도 필수과목으로\n'
              '그림, 음악, 연기까지! 창의력을 키우는\n'
              '다양한 예술 교육으로 재능 발견!',
        ),
        // 책 (청년정책)
        _buildImageObject(
          'assets/images/candidate_4/room_book.png',
          right: 20.0,
          bottom: 211.0,
          width: 96.0,
          height: 108.0,
          title: '💪 청년아, 꿈을 펼쳐라!',
          description: '헬조선은 이제 그만! 청년이 주인공인 나라 🌟\n\n'
              '🏠 내 방 갖기 프로젝트\n'
              '부모님 눈치 안 보고 독립할 수 있게\n'
              '청년 전용 집을 저렴하게! 🗝️\n\n'
              '💰 청년 기본소득 지급\n'
              '알바 뛰느라 공부 못하는 일 없도록\n'
              '매달 일정 금액을 지원해드려요! 💸\n\n'
              '🚀 창업하고 싶다면?\n'
              '아이디어만 있으면 OK! 정부가 투자하고\n'
              '멘토까지 연결해드려요. 젊은 CEO 탄생!',
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
          title: '⚖️ 공정한 세상 만들기!',
          description: '부자든 가난하든 모두가 공평한 대한민국! 💪\n\n'
              '🏢 재벌 특혜 이제 그만!\n'
              '대기업이 세금 안 내고 특혜받는 건\n'
              '이제 끝! 공정한 경쟁으로 바꿔요 🚫\n\n'
              '👥 차별 없는 사회 만들기\n'
              '성별, 나이, 출신 상관없이\n'
              '능력으로만 평가받는 세상! 🌈\n\n'
              '🔍 권력자 감시하기\n'
              '정치인, 재벌이 잘못하면 바로 처벌!\n'
              '시민이 직접 감시하는 투명한 사회',
        ),
        // 식물 (환경정책)
        _buildImageObject(
          'assets/images/candidate_5/room_plant.png',
          right: 31.0,
          top: 152.0,
          width: 98.0,
          height: 117.0,
          title: '🌍 지구를 구하자!',
          description: '미세먼지 없는 파란 하늘을 되찾아요! 🌤️\n\n'
              '🚌 버스·지하철 무료로!\n'
              '자가용 대신 대중교통 타면\n'
              '공기도 깨끗해지고 교통비도 절약! 💰\n\n'
              '🌳 도시 곳곳에 숲 만들기\n'
              '콘크리트 정글 말고 초록 도시로!\n'
              '산책하기 좋은 공원이 집 앞에 🌲\n\n'
              '♻️ 쓰레기 제로 도전\n'
              '일회용품 사용 줄이고 재활용 늘려서\n'
              '깨끗한 지구를 다음 세대에게!',
        ),
        // 헬멧 (노동정책)
        _buildImageObject(
          'assets/images/candidate_5/room_helmet.png',
          left: 30.0,
          bottom: 290.0,
          width: 86.0,
          height: 78.0,
          title: '💪 일하는 사람이 주인!',
          description: '야근 지옥에서 벗어나 인간다운 삶을! 🌅\n\n'
              '🗓️ 주 4일만 일하기\n'
              '월화수목만 일하고 금토일은 쉬어요!\n'
              '일과 삶의 균형, 워라밸이 진짜 현실로 ⚖️\n\n'
              '💰 최저임금 대폭 인상\n'
              '아르바이트해도 생활할 수 있을 만큼\n'
              '최저임금을 확 올려드려요! 💸\n\n'
              '🛡️ 위험한 일은 NO!\n'
              '산업재해로 다치는 일 없도록\n'
              '안전장비 완벽하게 갖춰드려요',
        ),
        // 담요 (복지정책)
        _buildImageObject(
          'assets/images/candidate_5/room_blanket.png',
          right: 0,
          bottom: 350.0,
          width: 128.0,
          height: 108.0,
          title: '🤗 모두가 따뜻한 나라!',
          description: '아프거나 힘들 때 국가가 든든한 버팀목! 🏥\n\n'
              '💊 병원비 걱정 끝!\n'
              '감기부터 수술까지 모든 치료비 무료!\n'
              '돈 때문에 치료 포기하는 일은 없어요 🩺\n\n'
              '👶 아이 키우기 좋은 나라\n'
              '어린이집비, 분유값까지 국가가 지원!\n'
              '아이 낳고 키우는 게 행복해져요 🍼\n\n'
              '👴 어르신들 편안한 노후\n'
              '기초연금 대폭 인상으로\n'
              '자식 눈치 안 보고 편안한 노년!',
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