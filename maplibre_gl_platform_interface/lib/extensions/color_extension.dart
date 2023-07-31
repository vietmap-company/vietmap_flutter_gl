import 'dart:ui';

extension ColorExtension on Color? {
  String toHex() {
    return '#${this?.value.toRadixString(16).substring(2).padLeft(6, '0').toUpperCase() ?? 000000}';
  }
}

extension ColorExtension2 on String {
  Color toColor() {
    return Color(int.parse(this.replaceFirst('#', ''), radix: 16))
        .withOpacity(1.0);
  }
}
