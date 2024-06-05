part of '../vietmap_flutter_gl.dart';

class Marker {
  final Widget child;
  final LatLng latLng;

  /// Make sure the width of the marker are match with it child width to the marker display exactly
  final double width;

  /// Make sure the height of the marker are match with it child height to the marker display exactly
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
