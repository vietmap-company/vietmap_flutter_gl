import 'package:flutter/material.dart';

import 'package:vietmap_flutter_gl/vietmap_flutter_gl.dart';

class Marker {
  final Widget child;
  final LatLng latLng;

  Marker({required this.child, required this.latLng});
}
