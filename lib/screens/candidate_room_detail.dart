import 'package:flutter/material.dart';

class CandidateRoomDetail extends StatefulWidget {
  final Map<String, dynamic> candidate;

  const CandidateRoomDetail({super.key, required this.candidate});

  @override
  State<CandidateRoomDetail> createState() => _CandidateRoomDetailState();
}

class _CandidateRoomDetailState extends State<CandidateRoomDetail> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF008080),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: widget.candidate['color'],
            border: Border.all(color: Colors.black, width: 2),
          ),
          child: Text(
            '${widget.candidate['name']}의 방',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: 'monospace',
              fontSize: 16,
            ),
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
          size: 24,
        ),
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFC0C0C0),
            border: Border.all(color: Colors.black, width: 2),
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
            padding: EdgeInsets.zero,
          ),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFC0C0C0),
                    border: Border.all(color: Colors.black, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 0,
                        offset: const Offset(4, 4),
                      ),
                    ],
                  ),
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xFFE0E0E0),
                          Color(0xFFA0A0A0),
                        ],
                        stops: [0.6, 0.6],
                      ),
                    ),
                  ),
                ),
                Scrollbar(
                  thumbVisibility: false,
                  trackVisibility: false,
                  controller: _scrollController,
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    scrollDirection: Axis.vertical,
                    physics: const BouncingScrollPhysics(),
                    child: Container(
                      height: MediaQuery.of(context).size.height - 100,
                      child: Stack(
                        children: [
                          Center(
                            child: _buildInteractiveObject(
                              context,
                              '👤',
                              '후보 소개',
                              '${widget.candidate['name']} 후보에 대해 알아보세요!',
                              widget.candidate['color'],
                            ),
                          ),
                          ..._buildPolicyObjects(context),
                        ],
                      ),
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

  List<Widget> _buildPolicyObjects(BuildContext context) {
    final candidateId = widget.candidate['id'];
    List<Map<String, dynamic>> objects = [];

    switch (candidateId) {
      case 'lee_jae_myung':
        objects = [
          {
            'emoji': '💰',
            'title': '기본소득 도입',
            'description': '모든 국민에게 월 50만원씩! 💸\n일하든 안 하든 기본적인 생활비는 국가가 보장해드려요. 알바 뛰느라 고생하는 청년들, 육아로 힘든 부모님들 모두 숨통이 트일 거예요!',
            'position': const Offset(30, 80),
          },
          {
            'emoji': '🏘️',
            'title': '공공주택 대량공급',
            'description': '집값 때문에 고민? 이제 그만! 🏠\n공공주택 500만호를 지어서 집값을 확 낮춰드릴게요. 신혼부부는 반값에, 청년은 월세 걱정 없이 살 수 있어요!',
            'position': const Offset(280, 100),
          },
          {
            'emoji': '🎓',
            'title': '대학등록금 반값',
            'description': '대학 등록금이 너무 비싸죠? 😭\n국공립대는 무료, 사립대는 반값으로! 학자금 대출 때문에 20대부터 빚쟁이 되는 일은 이제 없어요. 공부에만 집중하세요!',
            'position': const Offset(50, 300),
          },
          {
            'emoji': '🌐',
            'title': 'AI 국가전략',
            'description': 'AI 시대, 한국이 선두에! 🤖\nChatGPT 같은 한국형 AI를 만들고, 모든 국민이 AI를 활용할 수 있도록 교육해드려요. 미래 일자리도 미리 준비!',
            'position': const Offset(300, 280),
          },
          {
            'emoji': '🌱',
            'title': '탄소중립 2050',
            'description': '지구를 구해요! 🌍\n재생에너지 100% 전환하고, 전기차 보급 확대! 환경 지키면서 새로운 일자리도 만들어요. 우리 아이들에게 깨끗한 지구를 물려줘야죠!',
            'position': const Offset(20, 200),
          },
          {
            'emoji': '👥',
            'title': '노동시간 단축',
            'description': '주 4일 근무제 도입! ⏰\n일과 삶의 균형을 맞춰드려요. 더 적게 일하고 더 행복하게! 야근 문화는 이제 옛날 얘기가 될 거예요.',
            'position': const Offset(320, 200),
          },
        ];
        break;

      case 'kim_moon_soo':
        objects = [
          {
            'emoji': '🏭',
            'title': '제조업 르네상스',
            'description': '대한민국 제조업 부활! 🔥\n반도체, 자동차, 조선업을 다시 세계 1위로! 좋은 일자리 많이 만들어서 청년들이 해외로 나가지 않아도 되게 할게요!',
            'position': const Offset(30, 80),
          },
          {
            'emoji': '🏠',
            'title': '내 집 마련 지원',
            'description': '집은 투기 대상이 아니라 보금자리! 🏡\n무주택자 대출 한도 늘리고, 신혼부부 특별공급 확대! 열심히 일하면 내 집 마련할 수 있는 세상을 만들어요!',
            'position': const Offset(280, 100),
          },
          {
            'emoji': '🎯',
            'title': '교육 정상화',
            'description': '공부 잘하는 아이가 대접받는 세상! 📚\n영재교육 확대하고, 실력 있는 선생님들 우대해요. 경쟁도 필요해요. 실력으로 승부하는 공정한 사회!',
            'position': const Offset(50, 300),
          },
          {
            'emoji': '🚀',
            'title': '우주항공 강국',
            'description': '한국도 우주로! 🌌\n누리호 성공은 시작일 뿐! 우주산업 육성해서 새로운 먹거리 만들고, 우주 강국 코리아의 꿈을 현실로 만들어요!',
            'position': const Offset(300, 280),
          },
          {
            'emoji': '⚡',
            'title': '원전 확대',
            'description': '안전한 원전으로 에너지 독립! ⚛️\n원전 기술은 우리가 세계 최고예요. 탄소 없는 깨끗한 에너지로 전기료도 낮추고 환경도 지켜요!',
            'position': const Offset(20, 200),
          },
          {
            'emoji': '🛡️',
            'title': '강한 국방',
            'description': '평화는 힘으로 지켜요! 💪\n첨단 무기 개발하고 국방력 강화! 북한 도발에 확실히 대응하면서 평화로운 한반도를 만들어요!',
            'position': const Offset(320, 200),
          },
        ];
        break;

      case 'lee_jun_seok':
        objects = [
          {
            'emoji': '💻',
            'title': '디지털 정부 혁신',
            'description': '정부 업무 100% 디지털화! 📱\n민원 처리 5분 컷, 각종 서류 스마트폰으로 끝! 공무원들도 AI 도우미와 함께 일해요. 번거로운 행정은 안녕~',
            'position': const Offset(30, 80),
          },
          {
            'emoji': '🏢',
            'title': '스타트업 천국',
            'description': '청년 창업가들 모여라! 🚀\n창업 자금 지원 확대하고, 실패해도 재도전할 수 있는 환경 조성! 한국을 아시아의 실리콘밸리로 만들어요!',
            'position': const Offset(280, 100),
          },
          {
            'emoji': '🎮',
            'title': '게임산업 육성',
            'description': '게임도 문화예요! 🎯\ne스포츠 국가대표 지원하고, 게임 개발자 양성! 셧다운제 폐지해서 게임산업이 마음껏 성장할 수 있게 해요!',
            'position': const Offset(50, 300),
          },
          {
            'emoji': '🌐',
            'title': '메타버스 플랫폼',
            'description': '가상세계에서 만나요! 🥽\n한국형 메타버스 플랫폼 구축해서 새로운 경제 생태계 만들어요. 가상현실에서도 돈 벌 수 있는 시대!',
            'position': const Offset(300, 280),
          },
          {
            'emoji': '♻️',
            'title': '순환경제 구축',
            'description': '버리는 것도 자원이에요! 🔄\n플라스틱 재활용 100%, 음식물 쓰레기 제로! 환경도 지키고 새로운 비즈니스 모델도 만들어요!',
            'position': const Offset(20, 200),
          },
          {
            'emoji': '⚖️',
            'title': '공정한 기회',
            'description': '실력으로 평가받는 세상! 🎯\n학벌, 지역, 성별 차별 없이 능력으로만 승부! 공정한 경쟁 환경에서 누구나 성공할 수 있어요!',
            'position': const Offset(320, 200),
          },
        ];
        break;

      case 'kwon_young_guk':
        objects = [
          {
            'emoji': '🏥',
            'title': '무상의료 실현',
            'description': '병원비 걱정 없는 세상! 💊\n모든 의료비 국가가 부담해요. 감기부터 암 치료까지 무료! 돈 때문에 치료 포기하는 일은 절대 없어요!',
            'position': const Offset(30, 80),
          },
          {
            'emoji': '🏠',
            'title': '주택 공공화',
            'description': '집은 상품이 아니라 권리! 🏡\n모든 주택을 공공이 관리해서 집값 폭등 원천 차단! 누구나 적정한 가격에 살 수 있는 집을 보장해요!',
            'position': const Offset(280, 100),
          },
          {
            'emoji': '🎓',
            'title': '교육 완전무상',
            'description': '유치원부터 대학까지 무료! 📚\n교육비 때문에 꿈을 포기하는 일은 없어요. 모든 아이들이 평등하게 교육받을 권리를 보장해드려요!',
            'position': const Offset(50, 300),
          },
          {
            'emoji': '🌍',
            'title': '기후정의 실현',
            'description': '기후변화는 계급 문제! 🌡️\n부자들이 만든 환경 문제를 서민이 떠안으면 안 돼요. 대기업 규제 강화하고 친환경 전환 비용은 기업이 부담!',
            'position': const Offset(300, 280),
          },
          {
            'emoji': '⚡',
            'title': '에너지 공공화',
            'description': '전기, 가스도 공공재! 💡\n에너지 기업 국유화해서 요금 인하! 재생에너지 100% 전환으로 깨끗하고 저렴한 에너지를 모든 국민에게!',
            'position': const Offset(20, 200),
          },
          {
            'emoji': '👷',
            'title': '노동자 권익 보장',
            'description': '노동자가 주인인 세상! ✊\n최저임금 대폭 인상하고, 노조 활동 보장! 비정규직 차별 금지하고 모든 노동자가 인간답게 살 수 있어요!',
            'position': const Offset(320, 200),
          },
        ];
        break;

      default:
        objects = [];
    }

    return objects.map((obj) {
      final position = obj['position'] as Offset;
      return Positioned(
        left: position.dx,
        top: position.dy,
        child: _buildInteractiveObject(
          context,
          obj['emoji'] as String,
          obj['title'] as String,
          obj['description'] as String,
          widget.candidate['color'],
        ),
      );
    }).toList();
  }

  Widget _buildInteractiveObject(
    BuildContext context,
    String emoji,
    String title,
    String description,
    Color color,
  ) {
    return GestureDetector(
      onTap: () {
        _showPolicyModal(context, title, description, color);
      },
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: const Color(0xFFC0C0C0),
          border: Border.all(color: Colors.black, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 0,
              offset: const Offset(2, 2),
            ),
          ],
        ),
        child: Container(
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: const Color(0xFF808080), width: 1),
          ),
          child: Center(
            child: Text(
              emoji,
              style: const TextStyle(fontSize: 20),
            ),
          ),
        ),
      ),
    );
  }

  void _showPolicyModal(BuildContext context, String title, String description, Color color) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 400,
              maxHeight: 300,
            ),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: const Color(0xFFC0C0C0),
                border: Border.all(color: Colors.black, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 0,
                    offset: const Offset(4, 4),
                  ),
                ],
              ),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: const Color(0xFF808080), width: 1),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: color,
                        border: Border.all(color: Colors.black, width: 2),
                      ),
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'monospace',
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0F0F0),
                          border: Border.all(color: const Color(0xFF808080), width: 1),
                        ),
                        child: Text(
                          description,
                          style: const TextStyle(
                            fontSize: 14,
                            height: 1.5,
                            color: Colors.black,
                            fontFamily: 'monospace',
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFC0C0C0),
                        border: Border.all(color: Colors.black, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 0,
                            offset: const Offset(2, 2),
                          ),
                        ],
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
          ),
        );
      },
    );
  }
}