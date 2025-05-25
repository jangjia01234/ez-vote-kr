import 'policy_explanation.dart';

class Candidate {
  final String name;
  final String party;
  final String profileEmoji;
  final String description;
  final List<PolicyExplanation> policies;

  Candidate({
    required this.name,
    required this.party,
    required this.profileEmoji,
    required this.description,
    required this.policies,
  });

  static List<Candidate> getSampleCandidates() {
    return [
      Candidate(
        name: '김정치',
        party: '미래당',
        profileEmoji: '👨‍💼',
        description: '청년과 미래를 위한 정치',
        policies: [
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
            title: 'AI 일자리 정책',
            problemStatement: 'AI가 내 일자리를 뺏어간다고요?',
            problemEmoji: '🤖',
            solutions: [
              'AI 교육 무료 제공',
              '신기술 창업 지원금 1억',
              'AI 협업 일자리 창출'
            ],
            expectationStatement: 'AI와 함께 일하는 미래!',
            expectationEmoji: '🚀',
          ),
        ],
      ),
      Candidate(
        name: '박복지',
        party: '국민당',
        profileEmoji: '👩‍⚕️',
        description: '모든 국민의 복지를 위해',
        policies: [
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
            title: '의료비 지원',
            problemStatement: '병원비가 너무 비싸요',
            problemEmoji: '💸',
            solutions: [
              '중증질환 100% 지원',
              '건강검진 무료 확대',
              '응급실 대기시간 단축'
            ],
            expectationStatement: '이제 아파도 걱정 없어요!',
            expectationEmoji: '🏥',
          ),
          PolicyExplanation(
            title: '육아 지원정책',
            problemStatement: '아이 키우기가 너무 힘들어요',
            problemEmoji: '😵',
            solutions: [
              '육아수당 월 100만원',
              '국공립 어린이집 확대',
              '육아휴직 급여 100%'
            ],
            expectationStatement: '아이 키우는 재미가 생겼어요!',
            expectationEmoji: '👶',
          ),
        ],
      ),
      Candidate(
        name: '이환경',
        party: '녹색당',
        profileEmoji: '🌱',
        description: '지구를 살리는 정치',
        policies: [
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
          PolicyExplanation(
            title: '재생에너지 정책',
            problemStatement: '전기요금이 계속 올라가네요',
            problemEmoji: '⚡',
            solutions: [
              '태양광 패널 무료 설치',
              '풍력발전 확대',
              '에너지 자립마을 조성'
            ],
            expectationStatement: '전기요금 걱정 끝!',
            expectationEmoji: '☀️',
          ),
        ],
      ),
    ];
  }
} 