import 'package:flutter/material.dart';

class SmartSummaryCard extends StatelessWidget {
  final int completed;
  final int remaining;
  final int overdue;

  const SmartSummaryCard({
    super.key,
    required this.completed,
    required this.remaining,
    required this.overdue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF7F5AF0), Color(0xFF9F86FF)],
        ),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildItem("Completed", completed, Colors.green),
          _buildItem("Remaining", remaining, Colors.orange),
          _buildItem("Overdue", overdue, Colors.red),
        ],
      ),
    );
  }

  Widget _buildItem(String label, int value, Color color) {
    return Column(
      children: [
        Text(
          value.toString(),
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.white)),
      ],
    );
  }
}
