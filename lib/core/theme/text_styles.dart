import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color primary = Color(0xFF2E6B4F); 
  static const Color accent = Color(0xFFFF7043);  // Premium deep orange
  static const Color background = Color(0xFFF7F8FA);
  static const Color cardBgLight = Colors.white;
  static const Color textMain = Color(0xFF141414); // Sleeker black
  static const Color textSub = Color(0xFF757575);
}

class AppTextStyles {
  // Sora Headings
  static TextStyle h1 = GoogleFonts.sora(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: AppColors.textMain,
    letterSpacing: -0.5,
  );
  
  static TextStyle h2 = GoogleFonts.sora(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: AppColors.textMain,
    letterSpacing: -0.3,
  );

  static TextStyle h3 = GoogleFonts.sora(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textMain,
  );
  
  // Inter Body Text
  static TextStyle bodyLg = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textMain,
  );

  static TextStyle bodyMd = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textMain,
  );

  static TextStyle bodySm = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textSub,
  );

  // Labels & Subheadings (Inter Medium)
  static TextStyle subMedium = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textSub,
  );

  static TextStyle labelMedium = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.textSub,
  );

  // Important Numbers (Inter Bold)
  static TextStyle numberLg = GoogleFonts.inter(
    fontSize: 32,
    fontWeight: FontWeight.w800,
    color: AppColors.textMain,
    letterSpacing: -1.0,
  );

  static TextStyle numberMd = GoogleFonts.inter(
    fontSize: 20,
    fontWeight: FontWeight.w800,
    color: AppColors.accent,
  );
}
