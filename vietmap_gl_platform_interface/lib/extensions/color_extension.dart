part of '../vietmap_gl_platform_interface.dart';

extension ColorExtension on Color? {
  String toHex() {
    // ignore: deprecated_member_use
    return '#${this?.value.toRadixString(16).substring(2).padLeft(6, '0').toUpperCase() ?? 000000}';
  }
}

extension ColorExtension2 on String {
  Color toColor() {
    return Color(int.parse(replaceFirst('#', ''), radix: 16))
        .withAlpha((1.0 * 255).round());
  }
}
