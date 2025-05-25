import 'package:flutter/material.dart';
import '../models/policy_explanation.dart';
import '../widgets/policy_card.dart';

class PolicyListScreen extends StatelessWidget {
  const PolicyListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final policies = PolicyExplanation.getSamplePolicies();

    return Scaffold(
      appBar: AppBar(
        title: const Text('정책 설명'),
      ),
      body: ListView.builder(
        itemCount: policies.length,
        itemBuilder: (context, index) {
          return PolicyCard(policy: policies[index]);
        },
      ),
    );
  }
} 