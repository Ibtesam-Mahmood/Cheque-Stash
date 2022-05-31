

// ignore_for_file: non_constant_identifier_names, constant_identifier_names

import 'package:flutter/material.dart';

class Constants {

  static const double SMALL_PADDING = 8;
  static const double MEDIUM_PADDING = 16;
  static const double DEFAULT_PADDING = 24;
  static const double LARGE_PADDING = 32;

  static Duration get DEFAULT_DURATION => const Duration(milliseconds: 200);

  static Curve get DEFAULT_CURVE => Curves.easeInOutCubic;

  static BorderRadius get DEFAULT_RADIUS => BorderRadius.circular(16);
  static BorderRadius get SQUARE_RADIUS => BorderRadius.circular(8);

}