import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Custom spacing widget for vertical gaps instead of hardcoded SizedBox(height: ...).
class VSpace extends StatelessWidget {
  final double height;
  const VSpace(this.height, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: height.h);
  }
}

/// Custom spacing widget for horizontal gaps instead of hardcoded SizedBox(width: ...).
class HSpace extends StatelessWidget {
  final double width;
  const HSpace(this.width, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: width.w);
  }
}

// Explicit vertical spacing widgets
class VSpace2 extends StatelessWidget { const VSpace2({Key? key}) : super(key: key); @override Widget build(BuildContext context) => const VSpace(2); }
class VSpace4 extends StatelessWidget { const VSpace4({Key? key}) : super(key: key); @override Widget build(BuildContext context) => const VSpace(4); }
class VSpace5 extends StatelessWidget { const VSpace5({Key? key}) : super(key: key); @override Widget build(BuildContext context) => const VSpace(5); }
class VSpace6 extends StatelessWidget { const VSpace6({Key? key}) : super(key: key); @override Widget build(BuildContext context) => const VSpace(6); }
class VSpace8 extends StatelessWidget { const VSpace8({Key? key}) : super(key: key); @override Widget build(BuildContext context) => const VSpace(8); }
class VSpace10 extends StatelessWidget { const VSpace10({Key? key}) : super(key: key); @override Widget build(BuildContext context) => const VSpace(10); }
class VSpace12 extends StatelessWidget { const VSpace12({Key? key}) : super(key: key); @override Widget build(BuildContext context) => const VSpace(12); }
class VSpace14 extends StatelessWidget { const VSpace14({Key? key}) : super(key: key); @override Widget build(BuildContext context) => const VSpace(14); }
class VSpace16 extends StatelessWidget { const VSpace16({Key? key}) : super(key: key); @override Widget build(BuildContext context) => const VSpace(16); }
class VSpace18 extends StatelessWidget { const VSpace18({Key? key}) : super(key: key); @override Widget build(BuildContext context) => const VSpace(18); }
class VSpace20 extends StatelessWidget { const VSpace20({Key? key}) : super(key: key); @override Widget build(BuildContext context) => const VSpace(20); }
class VSpace24 extends StatelessWidget { const VSpace24({Key? key}) : super(key: key); @override Widget build(BuildContext context) => const VSpace(24); }
class VSpace28 extends StatelessWidget { const VSpace28({Key? key}) : super(key: key); @override Widget build(BuildContext context) => const VSpace(28); }
class VSpace32 extends StatelessWidget { const VSpace32({Key? key}) : super(key: key); @override Widget build(BuildContext context) => const VSpace(32); }
class VSpace36 extends StatelessWidget { const VSpace36({Key? key}) : super(key: key); @override Widget build(BuildContext context) => const VSpace(36); }
class VSpace40 extends StatelessWidget { const VSpace40({Key? key}) : super(key: key); @override Widget build(BuildContext context) => const VSpace(40); }
class VSpace48 extends StatelessWidget { const VSpace48({Key? key}) : super(key: key); @override Widget build(BuildContext context) => const VSpace(48); }
class VSpace50 extends StatelessWidget { const VSpace50({Key? key}) : super(key: key); @override Widget build(BuildContext context) => const VSpace(50); }
class VSpace60 extends StatelessWidget { const VSpace60({Key? key}) : super(key: key); @override Widget build(BuildContext context) => const VSpace(60); }
class VSpace70 extends StatelessWidget { const VSpace70({Key? key}) : super(key: key); @override Widget build(BuildContext context) => const VSpace(70); }
class VSpace80 extends StatelessWidget { const VSpace80({Key? key}) : super(key: key); @override Widget build(BuildContext context) => const VSpace(80); }
class VSpace100 extends StatelessWidget { const VSpace100({Key? key}) : super(key: key); @override Widget build(BuildContext context) => const VSpace(100); }
class VSpace110 extends StatelessWidget { const VSpace110({Key? key}) : super(key: key); @override Widget build(BuildContext context) => const VSpace(110); }
class VSpace120 extends StatelessWidget { const VSpace120({Key? key}) : super(key: key); @override Widget build(BuildContext context) => const VSpace(120); }
class VSpace150 extends StatelessWidget { const VSpace150({Key? key}) : super(key: key); @override Widget build(BuildContext context) => const VSpace(150); }
class VSpace200 extends StatelessWidget { const VSpace200({Key? key}) : super(key: key); @override Widget build(BuildContext context) => const VSpace(200); }

// Explicit horizontal spacing widgets
class HSpace2 extends StatelessWidget { const HSpace2({Key? key}) : super(key: key); @override Widget build(BuildContext context) => const HSpace(2); }
class HSpace4 extends StatelessWidget { const HSpace4({Key? key}) : super(key: key); @override Widget build(BuildContext context) => const HSpace(4); }
class HSpace5 extends StatelessWidget { const HSpace5({Key? key}) : super(key: key); @override Widget build(BuildContext context) => const HSpace(5); }
class HSpace6 extends StatelessWidget { const HSpace6({Key? key}) : super(key: key); @override Widget build(BuildContext context) => const HSpace(6); }
class HSpace8 extends StatelessWidget { const HSpace8({Key? key}) : super(key: key); @override Widget build(BuildContext context) => const HSpace(8); }
class HSpace10 extends StatelessWidget { const HSpace10({Key? key}) : super(key: key); @override Widget build(BuildContext context) => const HSpace(10); }
class HSpace12 extends StatelessWidget { const HSpace12({Key? key}) : super(key: key); @override Widget build(BuildContext context) => const HSpace(12); }
class HSpace14 extends StatelessWidget { const HSpace14({Key? key}) : super(key: key); @override Widget build(BuildContext context) => const HSpace(14); }
class HSpace16 extends StatelessWidget { const HSpace16({Key? key}) : super(key: key); @override Widget build(BuildContext context) => const HSpace(16); }
class HSpace18 extends StatelessWidget { const HSpace18({Key? key}) : super(key: key); @override Widget build(BuildContext context) => const HSpace(18); }
class HSpace20 extends StatelessWidget { const HSpace20({Key? key}) : super(key: key); @override Widget build(BuildContext context) => const HSpace(20); }
class HSpace24 extends StatelessWidget { const HSpace24({Key? key}) : super(key: key); @override Widget build(BuildContext context) => const HSpace(24); }
class HSpace28 extends StatelessWidget { const HSpace28({Key? key}) : super(key: key); @override Widget build(BuildContext context) => const HSpace(28); }
class HSpace32 extends StatelessWidget { const HSpace32({Key? key}) : super(key: key); @override Widget build(BuildContext context) => const HSpace(32); }
class HSpace48 extends StatelessWidget { const HSpace48({Key? key}) : super(key: key); @override Widget build(BuildContext context) => const HSpace(48); }
