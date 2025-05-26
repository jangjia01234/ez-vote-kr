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
          title: '🌱 기후·녹색산업',
          description: '기후위기 대응을 위한 종합 계획!\n\n'
              '🔋 재생에너지 확대\n'
              '• 2030년까지 재생에너지 40% 달성\n'
              '• 태양광·풍력 발전 대폭 확대\n'
              '• 에너지 자립도 높여 전기료 부담 줄이기\n\n'
              '💚 녹색 일자리 창출\n'
              '• 친환경 산업 육성으로 100만 개 일자리\n'
              '• 청년들을 위한 그린뉴딜 취업 지원\n'
              '• 탄소중립 기술 개발 투자 확대\n\n'
              '🌍 지속가능한 미래\n'
              '• 탄소세 도입으로 기업 책임 강화\n'
              '• 친환경 교통수단 보급 확대\n'
              '• 환경교육 의무화로 인식 개선',
        ),
        // 컴퓨터 (디지털 전환) - 크기 1.5배, 중앙 배치
        _buildImageObject(
          'assets/images/candidate_1/room_computer.png',
          left: 50.0,
          top: 260.0,
          width: 234.0,
          height: 195.0,
          title: '🖥️ 디지털 전환',
          description: 'AI·데이터 강국으로 도약!\n\n'
              '🤖 AI 산업 육성\n'
              '• 국가 AI 전략 수립 및 투자 확대\n'
              '• AI 전문인력 10만명 양성\n'
              '• AI 윤리 가이드라인 마련\n\n'
              '📊 데이터 경제 활성화\n'
              '• 공공데이터 전면 개방\n'
              '• 데이터 거래소 설립 운영\n'
              '• 개인정보보호 강화와 활용 균형\n\n'
              '🏛️ 디지털 정부 구현\n'
              '• 모든 행정서비스 온라인화\n'
              '• 블록체인 기반 투명한 행정\n'
              '• 디지털 격차 해소 지원\n\n'
              '💼 디지털 일자리 창출\n'
              '• IT 스타트업 창업 지원 확대\n'
              '• 디지털 리터러시 교육 강화',
        ),
        // 아파트 (기본주택)
        _buildImageObject(
          'assets/images/candidate_1/room_apartment.png',
          right: 5.0,
          bottom: 211.0,
          width: 129.0,
          height: 109.0,
          title: '🏘️ 기본주택',
          description: '모든 국민의 주거권 보장!\n\n'
              '🏠 기본주택 공급\n'
              '• 연 50만호 기본주택 건설\n'
              '• 시세의 50-80% 수준 임대료\n'
              '• 청년·신혼부부 우선 공급\n\n'
              '💰 주거비 부담 완화\n'
              '• 월세 상한제 도입 (연 5% 이내)\n'
              '• 전세사기 피해 국가 책임제\n'
              '• 주택담보대출 금리 지원\n\n'
              '🏗️ 주택 공급 확대\n'
              '• 3기 신도시 조기 공급\n'
              '• 역세권 고밀도 개발\n'
              '• 빈집 활용 임대주택 전환\n\n'
              '⚖️ 부동산 투기 근절\n'
              '• 다주택자 중과세 강화\n'
              '• 부동산 실명제 완전 시행',
        ),
        // 서류봉투 (개헌 추진)
        _buildImageObject(
          'assets/images/candidate_1/room_suitcase.png',
          left: 120.0,
          bottom: 152.0,
          width: 98.0,
          height: 74.0,
          title: '💼 개헌 추진',
          description: '국회 중심 책임정부 실현!\n\n'
              '🏛️ 권력구조 개편\n'
              '• 대통령 4년 중임제 도입\n'
              '• 국무총리 국회 추천제\n'
              '• 대통령 권한 분산 및 견제 강화\n\n'
              '⚖️ 사법부 독립 강화\n'
              '• 대법원장 국회 추천\n'
              '• 검찰 수사권 완전 분리\n'
              '• 사법행정권 독립 보장\n\n'
              '🗳️ 선거제도 개혁\n'
              '• 연동형 비례대표제 확대\n'
              '• 지방선거 정당공천 폐지\n'
              '• 선거연령 만 18세로 하향\n\n'
              '📜 기본권 확대\n'
              '• 노동3권 헌법 명시\n'
              '• 환경권·알권리 신설\n'
              '• 지방자치 분권 강화',
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
          title: '🚄 교통·인프라',
          description: '전국을 하나로 연결하는 교통망!\n\n'
              '🚅 고속철도 확충\n'
              '• KTX 노선 전국 확대\n'
              '• 수도권-지방 2시간대 연결\n'
              '• 고속철도 건설비 국가 지원\n\n'
              '🛣️ 도로망 현대화\n'
              '• 스마트 고속도로 구축\n'
              '• 자율주행 인프라 확대\n'
              '• 교통체증 해소 프로젝트\n\n'
              '✈️ 항공·해운 발전\n'
              '• 지방공항 활성화 지원\n'
              '• 부산항 동북아 허브화\n'
              '• 드론 택배 상용화 추진\n\n'
              '🌉 SOC 투자 확대\n'
              '• 노후 인프라 전면 개선\n'
              '• 지역균형발전 교통망\n'
              '• 친환경 교통수단 보급',
        ),
        // 돈통 (경제·세제) - 책장 바로 옆에 배치
        _buildImageObject(
          'assets/images/candidate_2/room_moneybox.png',
          right: 90.0,
          top: 280.0,
          width: 125.0,
          height: 133.0,
          title: '💰 경제·세제',
          description: '서민을 위한 경제정책!\n\n'
              '💸 세금 부담 완화\n'
              '• 소득세 구간 조정\n'
              '• 중산층 세부담 경감\n'
              '• 자영업자 세제 혜택 확대\n\n'
              '🏪 소상공인 지원\n'
              '• 임대료 안정화 정책\n'
              '• 카드수수료 인하\n'
              '• 소상공인 대출 금리 지원\n\n'
              '💼 일자리 창출\n'
              '• 청년 취업 지원 확대\n'
              '• 중소기업 고용 장려금\n'
              '• 신산업 분야 인력 양성\n\n'
              '📈 경제 활성화\n'
              '• 규제 완화로 투자 유치\n'
              '• 벤처기업 육성 지원\n'
              '• 수출 중소기업 지원 강화',
        ),
        // 군모 (안보·국방) - 책장 위에 배치
        _buildImageObject(
          'assets/images/candidate_2/room_militarycap.png',
          left: 10.0,
          top: 350.0,
          width: 98.0,
          height: 86.0,
          title: '🪖 안보·국방',
          description: '튼튼한 안보로 평화 수호!\n\n'
              '🛡️ 국방력 강화\n'
              '• 첨단 무기체계 도입\n'
              '• 한미동맹 더욱 공고화\n'
              '• 국방 R&D 투자 확대\n\n'
              '👨‍💼 병역제도 개선\n'
              '• 복무환경 현대화\n'
              '• 장병 처우 개선\n'
              '• 전문기술 병과 확대\n\n'
              '🌏 평화외교 추진\n'
              '• 한반도 평화 정착\n'
              '• 국제 평화유지 기여\n'
              '• 다자안보 협력 강화\n\n'
              '🚨 국가위기 대응\n'
              '• 재난대응 체계 강화\n'
              '• 사이버 보안 역량 확충\n'
              '• 국가정보 보호 강화',
        ),
        // 법전 (법무·정의) - 침대 위에 배치
        _buildImageObject(
          'assets/images/candidate_2/room_lawbook.png',
          right: 5.0,
          top: 278.0,
          width: 66.0,
          height: 89.0,
          title: '⚖️ 법무·정의',
          description: '공정하고 투명한 사회 구현!\n\n'
              '🏛️ 사법개혁 추진\n'
              '• 검찰 권한 분산\n'
              '• 사법부 독립성 강화\n'
              '• 국민참여재판 확대\n\n'
              '🔍 부패척결 강화\n'
              '• 고위공직자범죄수사처 정상화\n'
              '• 공직자 재산공개 확대\n'
              '• 정치자금 투명성 제고\n\n'
              '👥 사회적 약자 보호\n'
              '• 법률서비스 접근성 개선\n'
              '• 공익변호사 확대\n'
              '• 피해자 권리 보장 강화\n\n'
              '📋 법제도 현대화\n'
              '• 디지털 시대 법체계 정비\n'
              '• 규제 합리화 추진\n'
              '• 국민 편의 법무서비스',
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
          title: '🏛️ 정치개혁',
          description: '정치의 새로운 패러다임을 제시!\n\n'
              '🗳️ 선거제도 혁신\n'
              '• 온라인 투표 시스템 도입\n'
              '• 청년 정치 참여 확대\n'
              '• 정당 공천제 개혁\n\n'
              '💰 정치자금 투명화\n'
              '• 실시간 정치자금 공개\n'
              '• 후원금 한도 상향 조정\n'
              '• 크라우드펀딩 활성화\n\n'
              '📱 디지털 민주주의\n'
              '• 시민 참여 플랫폼 구축\n'
              '• AI 기반 정책 분석\n'
              '• 블록체인 투표 시스템\n\n'
              '⚖️ 국정감사 개혁\n'
              '• 상시 감시 체계 구축\n'
              '• 시민 감시단 운영\n'
              '• 투명한 정부 운영',
        ),
        // 플라스크 (과학기술)
        _buildImageObject(
          'assets/images/candidate_4/room_plask.png',
          right: 5.0,
          top: 270.0,
          width: 78.0,
          height: 89.0,
          title: '🧪 과학기술',
          description: '과학기술로 미래를 선도!\n\n'
              '🚀 우주항공 산업\n'
              '• 한국형 발사체 개발\n'
              '• 달 탐사 프로젝트\n'
              '• 우주산업 클러스터 조성\n\n'
              '🔬 R&D 투자 확대\n'
              '• GDP 대비 5% R&D 투자\n'
              '• 기초과학 연구 지원\n'
              '• 산학연 협력 강화\n\n'
              '💊 바이오헬스 육성\n'
              '• K-바이오 글로벌화\n'
              '• 정밀의료 기술 개발\n'
              '• 신약 개발 지원\n\n'
              '🤖 4차 산업혁명\n'
              '• 로봇산업 육성\n'
              '• 스마트팩토리 확산\n'
              '• 양자컴퓨팅 연구',
        ),
        // 서류 (교육개혁)
        _buildImageObject(
          'assets/images/candidate_4/room_document.png',
          left: 150.0,
          bottom: 200.0,
          width: 109.0,
          height: 86.0,
          title: '📚 교육개혁',
          description: '미래형 교육 시스템 구축!\n\n'
              '🎓 대학 입시 개혁\n'
              '• 학종 비중 확대\n'
              '• 수능 절대평가 전환\n'
              '• 고교학점제 정착\n\n'
              '💻 디지털 교육\n'
              '• 에듀테크 활용 확대\n'
              '• AI 맞춤형 학습\n'
              '• 온라인 교육 인프라\n\n'
              '🌍 글로벌 인재 양성\n'
              '• 해외 교환학생 확대\n'
              '• 다국어 교육 강화\n'
              '• 국제학교 설립\n\n'
              '🎨 창의교육 강화\n'
              '• 예술교육 의무화\n'
              '• 창업교육 확대\n'
              '• 융합교육 활성화',
        ),
        // 책 (청년정책)
        _buildImageObject(
          'assets/images/candidate_4/room_book.png',
          right: 20.0,
          bottom: 211.0,
          width: 96.0,
          height: 108.0,
          title: '👨‍💼 청년정책',
          description: '청년이 희망을 가질 수 있는 사회!\n\n'
              '🏠 청년 주거 지원\n'
              '• 청년 전용 임대주택\n'
              '• 주거비 지원 확대\n'
              '• 셰어하우스 활성화\n\n'
              '💼 일자리 창출\n'
              '• 청년 창업 지원\n'
              '• 디지털 일자리 확대\n'
              '• 해외 취업 지원\n\n'
              '💰 경제적 지원\n'
              '• 청년 기본소득 도입\n'
              '• 학자금 대출 이자 면제\n'
              '• 청년 적금 지원\n\n'
              '🎯 역량 개발\n'
              '• 직업훈련 프로그램\n'
              '• 멘토링 시스템\n'
              '• 해외 연수 기회',
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
          title: '⚖️ 사회정의',
          description: '공정하고 평등한 사회 실현!\n\n'
              '🏛️ 사법 정의\n'
              '• 사법부 완전 독립\n'
              '• 시민배심제 확대\n'
              '• 공익변호사 확충\n\n'
              '💰 경제 정의\n'
              '• 재벌 개혁 단행\n'
              '• 최고임금제 도입\n'
              '• 상속세 강화\n\n'
              '👥 사회적 약자 보호\n'
              '• 차별금지법 제정\n'
              '• 장애인 권익 보장\n'
              '• 이주민 인권 보호\n\n'
              '🔍 권력 견제\n'
              '• 언론 독립성 보장\n'
              '• 시민사회 활성화\n'
              '• 부패척결 강화',
        ),
        // 식물 (환경정책)
        _buildImageObject(
          'assets/images/candidate_5/room_plant.png',
          right: 31.0,
          top: 152.0,
          width: 98.0,
          height: 117.0,
          title: '🌱 환경정책',
          description: '지속가능한 녹색 사회 건설!\n\n'
              '🌍 탄소중립 실현\n'
              '• 2040년 탄소중립 달성\n'
              '• 재생에너지 80% 전환\n'
              '• 탄소세 전면 도입\n\n'
              '🚗 친환경 교통\n'
              '• 전기차 의무화\n'
              '• 대중교통 무료화\n'
              '• 자전거 도로 확충\n\n'
              '🏭 산업 전환\n'
              '• 그린뉴딜 확대\n'
              '• 화석연료 퇴출\n'
              '• 순환경제 구축\n\n'
              '🌳 생태계 보전\n'
              '• 국립공원 확대\n'
              '• 생물다양성 보호\n'
              '• 도시 숲 조성',
        ),
        // 헬멧 (노동정책)
        _buildImageObject(
          'assets/images/candidate_5/room_helmet.png',
          left: 30.0,
          bottom: 290.0,
          width: 86.0,
          height: 78.0,
          title: '👷 노동정책',
          description: '노동자의 권익을 최우선으로!\n\n'
              '⏰ 노동시간 단축\n'
              '• 주 4일제 도입\n'
              '• 초과근무 엄격 제한\n'
              '• 휴식권 보장\n\n'
              '💰 임금 인상\n'
              '• 최저임금 대폭 인상\n'
              '• 생활임금제 도입\n'
              '• 임금격차 해소\n\n'
              '🛡️ 노동안전 강화\n'
              '• 중대재해처벌법 강화\n'
              '• 안전관리자 의무 배치\n'
              '• 위험작업 금지\n\n'
              '🤝 노동조합 권리\n'
              '• 단결권 완전 보장\n'
              '• 단체교섭권 확대\n'
              '• 파업권 인정',
        ),
        // 담요 (복지정책)
        _buildImageObject(
          'assets/images/candidate_5/room_blanket.png',
          right: 0,
          bottom: 350.0,
          width: 128.0,
          height: 108.0,
          title: '🏥 복지정책',
          description: '모든 국민의 기본권 보장!\n\n'
              '🏥 의료 공공성\n'
              '• 의료 완전 무료화\n'
              '• 공공병원 확충\n'
              '• 의료진 처우 개선\n\n'
              '👶 보육 지원\n'
              '• 무상보육 확대\n'
              '• 국공립 어린이집 확충\n'
              '• 육아휴직 확대\n\n'
              '👴 노인 복지\n'
              '• 기초연금 대폭 인상\n'
              '• 요양서비스 확대\n'
              '• 노인 일자리 창출\n\n'
              '🏠 주거 복지\n'
              '• 공공임대주택 확대\n'
              '• 주거급여 현실화\n'
              '• 전월세 상한제',
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