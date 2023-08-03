import 'package:flutter/material.dart';

import 'package:vietmap_flutter_gl/vietmap_flutter_gl.dart';

class Marker {
  final Widget child;
  final LatLng latLng;
  final double width;
  final double height;

  /// The alignment of the marker, which controls where the [child] is drawn
  /// and how the [anchor] of the marker widget and screen [position] are interpreted.
  /// Defaults to [Alignment.center], but with marker like location icon, you might want to use [Alignment.bottomCenter].
  final Alignment alignment;
  Marker(
      {required this.child,
      required this.latLng,
      this.alignment = Alignment.center,
      this.width = 20,
      this.height = 20});
}
