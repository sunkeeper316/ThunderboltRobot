import 'package:flutter/material.dart';

class RobotStat extends StatelessWidget {
  const RobotStat({super.key, required this.label, required this.value});
  final String label;
  final double value;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 5),
    child: Row(
      children: [
        SizedBox(width: 42, child: Text(label)),
        Expanded(
          child: LinearProgressIndicator(
            value: value,
            minHeight: 5,
            color: const Color(0xFF1DE2FF),
            backgroundColor: Colors.white12,
          ),
        ),
      ],
    ),
  );
}
