import 'package:flutter/material.dart';

/// Simplified static illustration — no scan animation.
/// Just a clean icon in a styled container.
class ScanIllustration extends StatelessWidget {
  const ScanIllustration({super.key});

  static const double _frameSize = 180;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _frameSize,
      height: _frameSize,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        color: const Color(0xFF0E2B44),
      ),
      child: Center(
        child: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withValues(alpha: 0.12),
          ),
          child: const Icon(
            Icons.eco,
            size: 44,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}