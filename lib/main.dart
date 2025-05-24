import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '2025 대선 정보',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.notoSansKrTextTheme(),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DateTime electionDay = DateTime(2025, 6, 3);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('2025 대선 정보'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildDDayCounter(),
            _buildCandidateComparison(),
            _buildSupportRateChart(),
          ],
        ),
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
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.blue.shade100,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              const Text(
                '2025년 대선까지 남은 시간',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                '$days일 $hours시간 $minutes분 $seconds초',
                style: const TextStyle(fontSize: 20),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCandidateComparison() {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          const Text(
            '후보자 공약 비교',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          _buildCandidateCard('이재명', '민주당'),
          _buildCandidateCard('김문수', '국민의힘'),
          _buildCandidateCard('이준석', '새로운미래'),
          _buildCandidateCard('권영국', '진보당'),
        ],
      ),
    );
  }

  Widget _buildCandidateCard(String name, String party) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  color: Colors.grey.shade300,
                  child: const Center(child: Text('사진')),
                ),
                const SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      party,
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 15),
            const Text(
              '주요 공약',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildPolicyPoint('경제'),
            _buildPolicyPoint('교육'),
            _buildPolicyPoint('복지'),
          ],
        ),
      ),
    );
  }

  Widget _buildPolicyPoint(String category) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Text(
            '• $category: ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const Text('주요 정책 내용이 들어갈 자리입니다.'),
        ],
      ),
    );
  }

  Widget _buildSupportRateChart() {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.green.shade100,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          const Text(
            '실시간 지지율',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 300,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 100,
                barGroups: [
                  _makeBarGroup(0, 30, '이재명'),
                  _makeBarGroup(1, 25, '김문수'),
                  _makeBarGroup(2, 20, '이준석'),
                  _makeBarGroup(3, 15, '권영국'),
                ],
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const names = ['이재명', '김문수', '이준석', '권영국'];
                        return Text(
                          names[value.toInt()],
                          style: const TextStyle(fontSize: 12),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                    ),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  BarChartGroupData _makeBarGroup(int x, double y, String label) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: Colors.blue,
          width: 25,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(5)),
        ),
      ],
    );
  }
}
