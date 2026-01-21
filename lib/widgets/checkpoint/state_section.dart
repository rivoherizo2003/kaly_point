import 'package:flutter/material.dart';

class StateSection extends StatelessWidget {
  const StateSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildStatCard(
            title: "Total:",
            score: "150",
            valueColor: Colors.black,
            borderCardColor: Colors.black.withAlpha(100)
          ),
          SizedBox(width: 8),
          _buildStatCard(
            title: "Servi:",
            score: "50",
            valueColor: Colors.green,
            borderCardColor: Colors.green.shade200
          ),
          SizedBox(width: 8),
          _buildStatCard(
            title: "A servir:",
            score: "100",
            valueColor: Colors.deepOrange,
            borderCardColor: Colors.deepOrange.shade200
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String score,
    required Color valueColor,
    required Color borderCardColor
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 22),
        decoration: BoxDecoration(
          border: Border.all(color: borderCardColor),
          borderRadius: BorderRadius.circular(12),
          color: Colors.white10
        ),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 4),
            Text(
              score,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: valueColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
