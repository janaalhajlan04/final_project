import 'package:flutter/material.dart';

const kPrimaryGradient = LinearGradient(
  colors: [
    Color(0xFF7F5AF0), Color(0xFF9F86FF)
  ],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

class GradientHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onBack;

  const GradientHeader({
    super.key,
    required this.title,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(
        top: 20,
        bottom: 20,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF7F5AF0), Color(0xFF9F86FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: onBack ?? () => Navigator.pop(context),
            child: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 15),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}