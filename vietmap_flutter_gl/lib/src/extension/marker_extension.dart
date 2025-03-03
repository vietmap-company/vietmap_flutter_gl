import 'dart:math';

import 'package:flutter/material.dart';

extension MarkerExtension on Point {
  bool pointInsideScreen(Size screenSize) {
    if (x < 0 || x > screenSize.width) {
      return false;
    }
    if (y < 0 || y > screenSize.height) {
      return false;
    }
    return true;
  }
}
