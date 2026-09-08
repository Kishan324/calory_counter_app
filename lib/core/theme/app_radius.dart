import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Centralized border radius definitions with explicit numeric values.
class AppRadius {
  static double get radius2 => 2.r;
  static double get radius3 => 3.r;
  static double get radius4 => 4.r;
  static double get radius6 => 6.r;
  static double get radius8 => 8.r;
  static double get radius10 => 10.r;
  static double get radius12 => 12.r;
  static double get radius14 => 14.r;
  static double get radius16 => 16.r;
  static double get radius20 => 20.r;
  static double get radius24 => 24.r;
  static double get radius28 => 28.r;
  static double get radius32 => 32.r;
  static double get radius50 => 50.r;
  static double get radiusCircular => 999.r;

  // BorderRadius Conveniences
  static BorderRadius get border2 => BorderRadius.circular(radius2);
  static BorderRadius get border4 => BorderRadius.circular(radius4);
  static BorderRadius get border6 => BorderRadius.circular(radius6);
  static BorderRadius get border8 => BorderRadius.circular(radius8);
  static BorderRadius get border10 => BorderRadius.circular(radius10);
  static BorderRadius get border12 => BorderRadius.circular(radius12);
  static BorderRadius get border14 => BorderRadius.circular(radius14);
  static BorderRadius get border16 => BorderRadius.circular(radius16);
  static BorderRadius get border20 => BorderRadius.circular(radius20);
  static BorderRadius get border24 => BorderRadius.circular(radius24);
  static BorderRadius get border28 => BorderRadius.circular(radius28);
  static BorderRadius get border32 => BorderRadius.circular(radius32);
  static BorderRadius get border50 => BorderRadius.circular(radius50);
  static BorderRadius get borderCircular => BorderRadius.circular(radiusCircular);
}
