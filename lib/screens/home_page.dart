import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../widgets/glass_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DateTime electionDay = DateTime(2025, 6, 3);
  Set<int> _expandedPanelIndices = {};

  // 후보자별 공약 데이터
  final Map<String, Map<String, List<String>>> candidatesPolicies = {
    '이재명': {
      '경제': [
        'AI 산업에 100조원 투자, 모두의 AI 프로젝트 추진',
        'K-콘텐츠 국가 지원 확대',
        'K-방위산업 육성을 통한 성장 동력 확보'
      ],
      '노동': [
        '주 4.5일제 도입, 장기적으로 주 4일제 추진',
        '노란봉투법 제정',
        '포괄임금제 금지'
      ],
      '복지': [
        '공공의대 설립 및 공공병원 확충',
        '간병비 건강보험 적용',
        '지역사회 통합 돌봄체계 구축'
      ]
    },
    '김문수': {
      '경제': [
        '법인세·상속세 최고세율 인하',
        '기업 규제 완화 및 투자 기업 세제혜택 확대',
        'AI 청년 인재 20만명 양성'
      ],
      '노동': [
        '주 52시간 근무제 유연화',
        '기업 자율 주 4.5일제 도입',
        '5인 미만 사업장 근로기준법 단계적 적용'
      ],
      '복지': [
        '3·3·3 청년주택 매년 10만호 공급',
        '치매 국가책임제 도입',
        '장애 가족 돌봄 지원 확대'
      ]
    },
    '이준석': {
      '경제': [
        'AI 글로벌 3대 강국 육성',
        '디지털 경제 전환 가속화',
        '벤처기업 육성'
      ],
      '교육': [
        '코딩 교육 의무화',
        '온라인 교육 플랫폼 구축',
        '산학협력 강화'
      ],
      '복지': [
        '청년 기본소득 도입',
        '신혼부부 주거지원 확대',
        '디지털 복지 서비스 확대'
      ]
    },
    '권영국': {
      '경제': [
        '전 국민 기본소득 도입',
        '대기업 지배구조 개선',
        '공공부문 일자리 확대'
      ],
      '노동': [
        '주 32시간 근무제 법제화',
        '노동자 권익 보호 강화',
        '특수고용직 노동자 보호'
      ],
      '복지': [
        '무상의료 실현',
        '국공립 어린이집 확충',
        '교육 공공성 강화'
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
              Colors.blue.shade50,
              Colors.purple.shade50,
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
    );
  }

  Widget _buildHeader() {
    return GlassCard(
      child: Column(
        children: [
          Text(
            '2025 대선',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              foreground: Paint()
                ..shader = LinearGradient(
                  colors: [
                    Colors.blue.shade700,
                    Colors.purple.shade700,
                  ],
                ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '밈으로 보는 대선 특집',
            style: TextStyle(
              fontSize: 18,
              color: Colors.black54,
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

        return GlassCard(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '2025년 대선까지',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
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
        color: Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.white.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Text(
            value.toString().padLeft(2, '0'),
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.black.withOpacity(0.6),
            ),
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
          const Text(
            '실시간 지지율',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 100,
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    tooltipBgColor: Colors.white.withOpacity(0.8),
                    tooltipRoundedRadius: 8,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      return BarTooltipItem(
                        '${rod.toY.toInt()}%',
                        const TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                        ),
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
                      getTitlesWidget: (value, meta) {
                        const names = ['이재명', '김문수', '이준석', '권영국'];
                        return Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Text(
                            names[value.toInt()],
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black87,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '${value.toInt()}%',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black54,
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
                      color: Colors.black12,
                      strokeWidth: 1,
                    );
                  },
                ),
                borderData: FlBorderData(show: false),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '출처: 한국갤럽 (2025.5.20~22)',
            style: TextStyle(
              fontSize: 12,
              color: Colors.black.withOpacity(0.6),
              fontStyle: FontStyle.italic,
            ),
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
            color: Colors.black.withOpacity(0.05),
          ),
        ),
      ],
    );
  }

  Widget _buildCandidateComparison() {
    return GlassCard(
      child: Column(
        children: [
          const Text(
            '후보자 공약 비교',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 20),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: 4,
            itemBuilder: (context, index) {
              final candidates = ['이재명', '김문수', '이준석', '권영국'];
              return _buildCandidateCard(candidates[index], '', index);
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
          return '"AI로 더 나은 미래, 일하는 시간은 줄이고 삶의 질은 높이고"';
        case '김문수':
          return '"청년이 일하기 좋은 나라, 기업하기 좋은 대한민국"';
        case '이준석':
          return '"디지털 시대의 젊은 리더십, 청년의 미래를 책임지다"';
        case '권영국':
          return '"노동이 존중받고 국민이 행복한 정의로운 대한민국"';
        default:
          return '';
      }
    }

    return GlassCard(
      opacity: 0.5,
      child: ExpansionTile(
        initiallyExpanded: _expandedPanelIndices.contains(index),
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
            Container(
              width: double.infinity,
              height: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: getPartyColor(name).withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  'assets/images/${getImageName()}.png',
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.black.withOpacity(0.05),
                      child: Center(
                        child: Icon(
                          Icons.person,
                          size: 50,
                          color: getPartyColor(name).withOpacity(0.3),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            Text(
              getParty(name),
              style: TextStyle(
                fontSize: 14,
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
                style: TextStyle(
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                  color: getPartyColor(name),
                ),
              ),
            ),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '이런 정책을 약속드립니다!',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 10),
                ...candidatesPolicies[name]!.entries.map((entry) {
                  return Column(
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
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: getPartyColor(name),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...entry.value.map((policy) => Padding(
                        padding: const EdgeInsets.only(
                          left: 16.0,
                          bottom: 8.0,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '✓ ',
                              style: TextStyle(
                                color: getPartyColor(name),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                policy,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )).toList(),
                      const SizedBox(height: 16),
                    ],
                  );
                }).toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 