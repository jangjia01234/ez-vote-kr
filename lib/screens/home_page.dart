import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../widgets/glass_card.dart';
import '../widgets/text_styles.dart';
import 'package:flutter/foundation.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DateTime electionDay = DateTime(2025, 6, 3);
  Set<int> _expandedPanelIndices = {};

  // 후보자별 공약 데이터
  final Map<String, Map<String, List<Map<String, String>>>> candidatesPolicies = {
    '이재명': {
      '💰 경제정책': [
        {
          'title': 'AI 산업에 100조원 투자, 모두의 AI 프로젝트 추진',
          'description': 'AI 회사들한테 100조원 투자해서 일자리 만들기'
        },
        {
          'title': 'K-콘텐츠 국가 지원 확대',
          'description': 'K-POP, 드라마 같은 한류 콘텐츠 더 많이 지원하기'
        },
        {
          'title': 'K-방위산업 육성을 통한 성장 동력 확보',
          'description': '무기 만드는 회사들 키워서 수출하기'
        }
      ],
      '⏰ 노동정책': [
        {
          'title': '주 4.5일제 도입, 장기적으로 주 4일제 추진',
          'description': '주 4.5일만 일하기 (금요일 반차!), 나중에는 주 4일만'
        },
        {
          'title': '노란봉투법 제정',
          'description': '노동자들이 파업해도 손해배상 안 물어도 되게 하기'
        },
        {
          'title': '포괄임금제 금지',
          'description': '야근 강요하면 처벌받게 하기'
        }
      ],
      '🏥 복지정책': [
        {
          'title': '공공의대 설립 및 공공병원 확충',
          'description': '의대 더 만들어서 의사 늘리기'
        },
        {
          'title': '간병비 건강보험 적용',
          'description': '간병비도 건강보험으로 지원하기'
        },
        {
          'title': '지역사회 통합 돌봄체계 구축',
          'description': '동네에서 돌봄 서비스 받을 수 있게 하기'
        }
      ]
    },
    '김문수': {
      '💰 경제정책': [
        {
          'title': '법인세·상속세 최고세율 인하',
          'description': '회사들 세금 깎아줘서 투자 더 하게 만들기'
        },
        {
          'title': '기업 규제 완화 및 투자 기업 세제혜택 확대',
          'description': '기업 규제 줄여서 사업하기 쉽게 만들기'
        },
        {
          'title': 'AI 청년 인재 20만명 양성',
          'description': 'AI 전문가 20만명 키우기'
        }
      ],
      '⏰ 노동정책': [
        {
          'title': '주 52시간 근무제 유연화',
          'description': '주 52시간 근무를 좀 더 유연하게 조정하기'
        },
        {
          'title': '기업 자율 주 4.5일제 도입',
          'description': '회사가 알아서 주 4.5일제 할 수 있게 하기'
        },
        {
          'title': '5인 미만 사업장 근로기준법 단계적 적용',
          'description': '직원 5명 미만 작은 회사는 근로기준법 천천히 적용하기'
        }
      ],
      '🏠 주거·복지정책': [
        {
          'title': '3·3·3 청년주택 매년 10만호 공급',
          'description': '청년들한테 3억원짜리 집을 3천만원 계약금으로 살 수 있게 하기'
        },
        {
          'title': '치매 국가책임제 도입',
          'description': '치매 치료비 국가에서 다 내주기'
        },
        {
          'title': '장애 가족 돌봄 지원 확대',
          'description': '장애인 가족 돌봄 지원 늘리기'
        }
      ]
    },
    '이준석': {
      '💻 디지털정책': [
        {
          'title': 'AI 글로벌 3대 강국 육성',
          'description': 'AI 분야에서 세계 3등 안에 들기'
        },
        {
          'title': '디지털 경제 전환 가속화',
          'description': '모든 걸 디지털로 바꿔서 편하게 만들기'
        },
        {
          'title': '벤처기업 육성',
          'description': '스타트업 회사들 더 많이 지원하기'
        }
      ],
      '📚 교육정책': [
        {
          'title': '코딩 교육 의무화',
          'description': '학교에서 코딩 필수로 가르치기'
        },
        {
          'title': '온라인 교육 플랫폼 구축',
          'description': '온라인으로 공부할 수 있는 시스템 만들기'
        },
        {
          'title': '산학협력 강화',
          'description': '대학교랑 회사가 함께 교육하기'
        }
      ],
      '💸 청년정책': [
        {
          'title': '청년 기본소득 도입',
          'description': '청년들한테 매달 용돈 주기 (기본소득)'
        },
        {
          'title': '신혼부부 주거지원 확대',
          'description': '신혼부부 집 구하는 거 도와주기'
        },
        {
          'title': '디지털 복지 서비스 확대',
          'description': '복지 신청을 앱으로 쉽게 할 수 있게 하기'
        }
      ]
    },
    '권영국': {
      '💰 기본소득정책': [
        {
          'title': '전 국민 기본소득 도입',
          'description': '모든 국민한테 매달 생활비 지원하기'
        },
        {
          'title': '대기업 지배구조 개선',
          'description': '대기업들이 너무 독점하지 못하게 규제하기'
        },
        {
          'title': '공공부문 일자리 확대',
          'description': '공무원 일자리 더 많이 만들기'
        }
      ],
      '⏰ 노동정책': [
        {
          'title': '주 32시간 근무제 법제화',
          'description': '주 32시간만 일하기 (하루 6시간 정도)'
        },
        {
          'title': '노동자 권익 보호 강화',
          'description': '노동자들 권리 더 강하게 보호하기'
        },
        {
          'title': '특수고용직 노동자 보호',
          'description': '배달기사, 대리기사도 정식 직원처럼 대우하기'
        }
      ],
      '🆓 무상복지정책': [
        {
          'title': '무상의료 실현',
          'description': '병원비 완전 무료로 만들기'
        },
        {
          'title': '국공립 어린이집 확충',
          'description': '국공립 어린이집 더 많이 만들기'
        },
        {
          'title': '교육 공공성 강화',
          'description': '사교육비 안 내도 되게 공교육 강화하기'
        }
      ]
    }
  };

  Color getPartyColor(String name) {
    switch(name) {
      case '이재명':
        return const Color(0xFF0050A0);
      case '김문수':
        return const Color(0xFFE61E2B);
      case '이준석':
        return const Color(0xFFFF6B00);
      case '권영국':
        return const Color(0xFFFFB612);
      default:
        return Colors.grey;
    }
  }

  Color getPartyLightColor(String name) {
    switch(name) {
      case '이재명':
        return const Color(0xFFE3F2FD);
      case '김문수':
        return const Color(0xFFFFEBEE);
      case '이준석':
        return const Color(0xFFFFF3E0);
      case '권영국':
        return const Color(0xFFFFF8E1);
      default:
        return Colors.grey.shade50;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.grey.shade50,
              Colors.grey.shade100,
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 800),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      _buildHeader(),
                      const SizedBox(height: 20),
                      _buildDDayCounter(),
                      const SizedBox(height: 20),
                      _buildSupportRateChart(),
                      const SizedBox(height: 20),
                      _buildCandidateComparison(),
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
    return GlassCard(
      child: Column(
        children: [
          Text(
            '2025 대선',
            style: AppTextStyles.title(context),
          ),
          const SizedBox(height: 8),
          Text(
            '밈으로 보는 대선 특집',
            style: AppTextStyles.subtitle(context),
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

        return GlassCard(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '2025년 대선까지',
                style: AppTextStyles.title(context),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildTimeBox(days, '일'),
                  const SizedBox(width: 10),
                  _buildTimeBox(hours, '시간'),
                  const SizedBox(width: 10),
                  _buildTimeBox(minutes, '분'),
                  const SizedBox(width: 10),
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade50.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Text(
            value.toString().padLeft(2, '0'),
            style: AppTextStyles.title(context),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTextStyles.subtitle(context),
          ),
        ],
      ),
    );
  }

  Widget _buildSupportRateChart() {
    return GlassCard(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '실시간 지지율',
            style: AppTextStyles.title(context),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 250,
            child: Padding(
              padding: const EdgeInsets.only(right: 40, bottom: 20),
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 100,
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchTooltipData: BarTouchTooltipData(
                      tooltipBgColor: Colors.grey.shade50.withOpacity(0.9),
                      tooltipRoundedRadius: 8,
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        return BarTooltipItem(
                          '${rod.toY.toInt()}%',
                          AppTextStyles.title(context),
                        );
                      },
                    ),
                  ),
                  barGroups: [
                    _makeBarGroup(0, 45, '이재명'),
                    _makeBarGroup(1, 36, '김문수'),
                    _makeBarGroup(2, 10, '이준석'),
                    _makeBarGroup(3, 5, '권영국'),
                  ],
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          const names = ['이재명', '김문수', '이준석', '권영국'];
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              names[value.toInt()],
                              style: AppTextStyles.subtitle(context),
                              textAlign: TextAlign.center,
                            ),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 90,
                        interval: 20,
                        getTitlesWidget: (value, meta) {
                          return SideTitleWidget(
                            axisSide: meta.axisSide,
                            space: 12,
                            child: Text(
                              '${value.toInt()}%',
                              style: AppTextStyles.subtitle(context),
                            ),
                          );
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawHorizontalLine: true,
                    horizontalInterval: 20,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: Colors.grey.shade300,
                        strokeWidth: 1,
                      );
                    },
                  ),
                  borderData: FlBorderData(show: false),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '출처: 한국갤럽 (2025.5.20~22)',
            style: AppTextStyles.subtitle(context),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  BarChartGroupData _makeBarGroup(int x, double y, String name) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: getPartyColor(name),
          width: 15,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(5)),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 100,
            color: Colors.grey.shade200,
          ),
        ),
      ],
    );
  }

  Widget _buildCandidateComparison() {
    return GlassCard(
      child: Column(
        children: [
          Text(
            '후보자 공약 비교',
            style: AppTextStyles.title(context),
          ),
          const SizedBox(height: 20),
          LayoutBuilder(
            builder: (context, constraints) {
              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 4,
                separatorBuilder: (context, index) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final candidates = ['이재명', '김문수', '이준석', '권영국'];
                  return _buildCandidateCard(candidates[index], '', index);
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCandidateCard(String name, String party, int index) {
    String getImageName() {
      switch(name) {
        case '이재명':
          return 'candidate-1';
        case '김문수':
          return 'candidate-2';
        case '이준석':
          return 'candidate-4';
        case '권영국':
          return 'candidate-5';
        default:
          return '';
      }
    }

    String getParty(String name) {
      switch(name) {
        case '이재명':
          return '더불어민주당';
        case '김문수':
          return '국민의힘';
        case '이준석':
          return '개혁신당';
        case '권영국':
          return '민주노동당';
        default:
          return '';
      }
    }

    String getSlogan() {
      switch(name) {
        case '이재명':
          return '"AI 시대 준비하고, 주 4일만 일하고, 병원비 걱정 없는 나라 만들기!"';
        case '김문수':
          return '"회사 키우고, 청년들 집 사고, 치매 걱정 없는 든든한 나라!"';
        case '이준석':
          return '"코딩 배우고, 용돈 받고, 앱으로 뚝딱 해결하는 디지털 세상!"';
        case '권영국':
          return '"모든 국민 용돈 받고, 하루 6시간만 일하고, 병원비 무료!"';
        default:
          return '';
      }
    }

    return GlassCard(
      opacity: 0.5,
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
        ),
        child: ExpansionTile(
          tilePadding: EdgeInsets.zero,
          initiallyExpanded: _expandedPanelIndices.contains(index),
          trailing: Icon(
            _expandedPanelIndices.contains(index) 
              ? Icons.keyboard_arrow_up 
              : Icons.keyboard_arrow_down,
            color: getPartyColor(name),
          ),
          onExpansionChanged: (isExpanded) {
            setState(() {
              if (isExpanded) {
                _expandedPanelIndices.add(index);
              } else {
                _expandedPanelIndices.remove(index);
              }
            });
          },
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 120,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: getPartyColor(name).withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: kIsWeb 
                      ? Image.network(
                          '/assets/images/${getImageName()}.png',
                          fit: BoxFit.contain,
                          width: double.infinity,
                          height: double.infinity,
                          errorBuilder: (context, error, stackTrace) {
                            print('웹 이미지 로딩 에러: /assets/images/${getImageName()}.png - $error');
                            return Image.asset(
                              'assets/images/${getImageName()}.png',
                              fit: BoxFit.contain,
                              width: double.infinity,
                              height: double.infinity,
                              errorBuilder: (context, error2, stackTrace2) {
                                print('Asset 이미지 로딩 에러: assets/images/${getImageName()}.png - $error2');
                                return Container(
                                  color: Colors.black.withOpacity(0.05),
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.person,
                                          size: 50,
                                          color: getPartyColor(name).withOpacity(0.3),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          '이미지 로딩 실패',
                                          style: TextStyle(
                                            color: getPartyColor(name).withOpacity(0.5),
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        )
                      : Image.asset(
                          'assets/images/${getImageName()}.png',
                          fit: BoxFit.contain,
                          width: double.infinity,
                          height: double.infinity,
                          errorBuilder: (context, error, stackTrace) {
                            print('이미지 로딩 에러: assets/images/${getImageName()}.png - $error');
                            return Container(
                              color: Colors.black.withOpacity(0.05),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.person,
                                      size: 50,
                                      color: getPartyColor(name).withOpacity(0.3),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      '이미지 로딩 중...',
                                      style: TextStyle(
                                        color: getPartyColor(name).withOpacity(0.5),
                                        fontSize: 12,
                                      ),
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
              const SizedBox(height: 10),
              Text(
                name,
                style: AppTextStyles.title(context).copyWith(
                  fontSize: 18,
                ),
              ),
              Text(
                getParty(name),
                style: AppTextStyles.subtitle(context).copyWith(
                  color: getPartyColor(name),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: getPartyColor(name).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  getSlogan(),
                  style: AppTextStyles.subtitle(context).copyWith(
                    fontStyle: FontStyle.italic,
                    color: getPartyColor(name),
                  ),
                ),
              ),
            ],
          ),
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 16.0,
                bottom: 8.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '이런 정책을 약속드립니다!',
                    style: AppTextStyles.title(context),
                  ),
                  const SizedBox(height: 10),
                  ...candidatesPolicies[name]!.entries.map((entry) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: getPartyColor(name).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              entry.key,
                              style: AppTextStyles.subtitle(context).copyWith(
                                color: getPartyColor(name),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          ...entry.value.map((policy) => Padding(
                            padding: const EdgeInsets.only(
                              left: 16.0,
                              bottom: 12.0,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '✓ ',
                                      style: AppTextStyles.subtitle(context).copyWith(
                                        color: getPartyColor(name),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        policy['title']!,
                                        style: AppTextStyles.subtitle(context).copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 16.0, top: 4.0),
                                  child: Text(
                                    '→ ${policy['description']!}',
                                    style: AppTextStyles.subtitle(context).copyWith(
                                      color: Colors.grey[600],
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )).toList(),
                        ],
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
} 