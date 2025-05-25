class PolicyExplanation {
  final String title;
  final String problemStatement;
  final String problemEmoji;
  final List<String> solutions;
  final String expectationStatement;
  final String expectationEmoji;

  PolicyExplanation({
    required this.title,
    required this.problemStatement,
    required this.problemEmoji,
    required this.solutions,
    required this.expectationStatement,
    required this.expectationEmoji,
  });

  static List<PolicyExplanation> getSamplePolicies() {
    return [
      PolicyExplanation(
        title: '청년 주거정책',
        problemStatement: '30평 아파트가 15억이라고요...?',
        problemEmoji: '😱',
        solutions: [
          '토지비용 50% 절감',
          '분양가 30% 할인',
          '전매제한 없음'
        ],
        expectationStatement: '이제 진짜 내 집 마련 가능...?',
        expectationEmoji: '🥳',
      ),
      PolicyExplanation(
        title: '반값 등록금',
        problemStatement: '1학기 등록금 납부 문자가 왔습니다',
        problemEmoji: '😭',
        solutions: [
          '국립대: 50% 지원',
          '사립대: 35% 지원',
          '학자금 대출 무이자'
        ],
        expectationStatement: '이제 알바 안 해도 되나요?!',
        expectationEmoji: '💰',
      ),
      PolicyExplanation(
        title: '노인 복지정책',
        problemStatement: '치매 걱정없는 노후 만들기',
        problemEmoji: '😰',
        solutions: [
          '치매 검사 무료',
          '치료비 90% 지원',
          '간병인 파견 서비스'
        ],
        expectationStatement: '이제 효도했다고 할 수 있겠죠?',
        expectationEmoji: '😊',
      ),
      PolicyExplanation(
        title: '일자리 정책',
        problemStatement: '취업 준비생 현실',
        problemEmoji: '🔥',
        solutions: [
          '취준생 월 80만원 지원',
          'AI/코딩 교육 무료 제공',
          '중소기업 취업시 월 100만원 추가'
        ],
        expectationStatement: '이거 실화...?',
        expectationEmoji: '🤑',
      ),
      PolicyExplanation(
        title: '환경 정책',
        problemStatement: '미세먼지 보고서 들어왔습니다',
        problemEmoji: '😷',
        solutions: [
          '노후 석탄발전 즉시 폐쇄',
          '전기차 보조금 2배 확대',
          '도심 숲 1000개 조성'
        ],
        expectationStatement: '드디어 창문 열어도 되는건가요?!',
        expectationEmoji: '🌱',
      ),
    ];
  }
} 