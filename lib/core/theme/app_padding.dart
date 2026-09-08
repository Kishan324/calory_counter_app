import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Centralized padding and margin definitions with explicit numeric values.
class AppPadding {
  static double get padding2 => 2.w;
  static double get padding4 => 4.w;
  static double get padding6 => 6.w;
  static double get padding8 => 8.w;
  static double get padding10 => 10.w;
  static double get padding12 => 12.w;
  static double get padding14 => 14.w;
  static double get padding16 => 16.w;
  static double get padding18 => 18.w;
  static double get padding20 => 20.w;
  static double get padding24 => 24.w;
  static double get padding28 => 28.w;
  static double get padding32 => 32.w;
  static double get padding40 => 40.w;
  static double get padding48 => 48.w;

  // EdgeInsets Conveniences
  static EdgeInsets get all4 => EdgeInsets.all(padding4);
  static EdgeInsets get all8 => EdgeInsets.all(padding8);
  static EdgeInsets get all12 => EdgeInsets.all(padding12);
  static EdgeInsets get all14 => EdgeInsets.all(padding14);
  static EdgeInsets get all16 => EdgeInsets.all(padding16);
  static EdgeInsets get all20 => EdgeInsets.all(padding20);
  static EdgeInsets get all24 => EdgeInsets.all(padding24);
  static EdgeInsets get all32 => EdgeInsets.all(padding32);

  static EdgeInsets get symmetricH12 => EdgeInsets.symmetric(horizontal: 12.w);
  static EdgeInsets get symmetricH16 => EdgeInsets.symmetric(horizontal: 16.w);
  static EdgeInsets get symmetricH20 => EdgeInsets.symmetric(horizontal: 20.w);
  static EdgeInsets get symmetricH24 => EdgeInsets.symmetric(horizontal: 24.w);
  static EdgeInsets get symmetricH32 => EdgeInsets.symmetric(horizontal: 32.w);

  static EdgeInsets get symmetricV8 => EdgeInsets.symmetric(vertical: 8.h);
  static EdgeInsets get symmetricV12 => EdgeInsets.symmetric(vertical: 12.h);
  static EdgeInsets get symmetricV14 => EdgeInsets.symmetric(vertical: 14.h);
  static EdgeInsets get symmetricV16 => EdgeInsets.symmetric(vertical: 16.h);
  static EdgeInsets get symmetricV18 => EdgeInsets.symmetric(vertical: 18.h);
  static EdgeInsets get symmetricV20 => EdgeInsets.symmetric(vertical: 20.h);
}
