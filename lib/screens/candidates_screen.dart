import 'package:flutter/material.dart';
import '../models/candidate.dart';
import '../widgets/candidate_card.dart';

class CandidatesScreen extends StatelessWidget {
  const CandidatesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final candidates = Candidate.getSampleCandidates();

    return Scaffold(
      appBar: AppBar(
        title: const Text('2025 대선 후보'),
        backgroundColor: Colors.blue[50],
        centerTitle: true,
      ),
      body: Column(
        children: [
          // 헤더
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue[50]!, Colors.white],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Column(
              children: [
                const Text(
                  '🗳️',
                  style: TextStyle(fontSize: 50),
                ),
                const SizedBox(height: 12),
                Text(
                  '후보별 공약 비교',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[800],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '각 후보를 탭해서 상세 공약을 확인해보세요!',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          
          // 후보자 목록
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.8,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: candidates.length,
              itemBuilder: (context, index) {
                return CandidateCard(candidate: candidates[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
} 