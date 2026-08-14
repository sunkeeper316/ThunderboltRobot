import 'package:flutter/material.dart';

class GlowButton extends StatelessWidget {
  const GlowButton({super.key, required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.infinity,
    height: 58,
    child: FilledButton(
      onPressed: onTap,
      style: FilledButton.styleFrom(
        backgroundColor: const Color(0xFF078DBE),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: Color(0xFF69E9FF), width: 2),
        ),
        elevation: 12,
        shadowColor: const Color(0xFF00D5FF),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 19,
          fontWeight: FontWeight.w800,
          letterSpacing: 3,
        ),
      ),
    ),
  );
}
