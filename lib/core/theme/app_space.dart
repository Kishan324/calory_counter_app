import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Custom spacing widget for vertical gaps instead of hardcoded SizedBox(height: ...).
class VSpace extends StatelessWidget {
  final double height;
  const VSpace(this.height, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: height.h);
  }
}

/// Custom spacing widget for horizontal gaps instead of hardcoded SizedBox(width: ...).
class HSpace extends StatelessWidget {
  final double width;
  const HSpace(this.width, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: width.w);
  }
}

// Explicit vertical spacing widgets
class VSpace2 extends StatelessWidget { const VSpace2({super.key}); @override Widget build(BuildContext context) => const VSpace(2); }
class VSpace4 extends StatelessWidget { const VSpace4({super.key}); @override Widget build(BuildContext context) => const VSpace(4); }
class VSpace5 extends StatelessWidget { const VSpace5({super.key}); @override Widget build(BuildContext context) => const VSpace(5); }
class VSpace6 extends StatelessWidget { const VSpace6({super.key}); @override Widget build(BuildContext context) => const VSpace(6); }
class VSpace8 extends StatelessWidget { const VSpace8({super.key}); @override Widget build(BuildContext context) => const VSpace(8); }
class VSpace10 extends StatelessWidget { const VSpace10({super.key}); @override Widget build(BuildContext context) => const VSpace(10); }
class VSpace12 extends StatelessWidget { const VSpace12({super.key}); @override Widget build(BuildContext context) => const VSpace(12); }
class VSpace14 extends StatelessWidget { const VSpace14({super.key}); @override Widget build(BuildContext context) => const VSpace(14); }
class VSpace16 extends StatelessWidget { const VSpace16({super.key}); @override Widget build(BuildContext context) => const VSpace(16); }
class VSpace18 extends StatelessWidget { const VSpace18({super.key}); @override Widget build(BuildContext context) => const VSpace(18); }
class VSpace20 extends StatelessWidget { const VSpace20({super.key}); @override Widget build(BuildContext context) => const VSpace(20); }
class VSpace24 extends StatelessWidget { const VSpace24({super.key}); @override Widget build(BuildContext context) => const VSpace(24); }
class VSpace28 extends StatelessWidget { const VSpace28({super.key}); @override Widget build(BuildContext context) => const VSpace(28); }
class VSpace32 extends StatelessWidget { const VSpace32({super.key}); @override Widget build(BuildContext context) => const VSpace(32); }
class VSpace36 extends StatelessWidget { const VSpace36({super.key}); @override Widget build(BuildContext context) => const VSpace(36); }
class VSpace40 extends StatelessWidget { const VSpace40({super.key}); @override Widget build(BuildContext context) => const VSpace(40); }
class VSpace48 extends StatelessWidget { const VSpace48({super.key}); @override Widget build(BuildContext context) => const VSpace(48); }
class VSpace50 extends StatelessWidget { const VSpace50({super.key}); @override Widget build(BuildContext context) => const VSpace(50); }
class VSpace60 extends StatelessWidget { const VSpace60({super.key}); @override Widget build(BuildContext context) => const VSpace(60); }
class VSpace70 extends StatelessWidget { const VSpace70({super.key}); @override Widget build(BuildContext context) => const VSpace(70); }
class VSpace80 extends StatelessWidget { const VSpace80({super.key}); @override Widget build(BuildContext context) => const VSpace(80); }
class VSpace100 extends StatelessWidget { const VSpace100({super.key}); @override Widget build(BuildContext context) => const VSpace(100); }
class VSpace110 extends StatelessWidget { const VSpace110({super.key}); @override Widget build(BuildContext context) => const VSpace(110); }
class VSpace120 extends StatelessWidget { const VSpace120({super.key}); @override Widget build(BuildContext context) => const VSpace(120); }
class VSpace150 extends StatelessWidget { const VSpace150({super.key}); @override Widget build(BuildContext context) => const VSpace(150); }
class VSpace200 extends StatelessWidget { const VSpace200({super.key}); @override Widget build(BuildContext context) => const VSpace(200); }

// Explicit horizontal spacing widgets
class HSpace2 extends StatelessWidget { const HSpace2({super.key}); @override Widget build(BuildContext context) => const HSpace(2); }
class HSpace4 extends StatelessWidget { const HSpace4({super.key}); @override Widget build(BuildContext context) => const HSpace(4); }
class HSpace5 extends StatelessWidget { const HSpace5({super.key}); @override Widget build(BuildContext context) => const HSpace(5); }
class HSpace6 extends StatelessWidget { const HSpace6({super.key}); @override Widget build(BuildContext context) => const HSpace(6); }
class HSpace8 extends StatelessWidget { const HSpace8({super.key}); @override Widget build(BuildContext context) => const HSpace(8); }
class HSpace10 extends StatelessWidget { const HSpace10({super.key}); @override Widget build(BuildContext context) => const HSpace(10); }
class HSpace12 extends StatelessWidget { const HSpace12({super.key}); @override Widget build(BuildContext context) => const HSpace(12); }
class HSpace14 extends StatelessWidget { const HSpace14({super.key}); @override Widget build(BuildContext context) => const HSpace(14); }
class HSpace16 extends StatelessWidget { const HSpace16({super.key}); @override Widget build(BuildContext context) => const HSpace(16); }
class HSpace18 extends StatelessWidget { const HSpace18({super.key}); @override Widget build(BuildContext context) => const HSpace(18); }
class HSpace20 extends StatelessWidget { const HSpace20({super.key}); @override Widget build(BuildContext context) => const HSpace(20); }
class HSpace24 extends StatelessWidget { const HSpace24({super.key}); @override Widget build(BuildContext context) => const HSpace(24); }
class HSpace28 extends StatelessWidget { const HSpace28({super.key}); @override Widget build(BuildContext context) => const HSpace(28); }
class HSpace32 extends StatelessWidget { const HSpace32({super.key}); @override Widget build(BuildContext context) => const HSpace(32); }
class HSpace48 extends StatelessWidget { const HSpace48({super.key}); @override Widget build(BuildContext context) => const HSpace(48); }
