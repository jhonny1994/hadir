import 'package:fluent_ui/fluent_ui.dart';

class HadirColors {
  static const Color primary = Color(0xFF0078D4);
  static const Color secondary = Color(0xFF2B579A);
  static const Color accent = Color(0xFF005A9E);
  static const Color background = Color(0xFFF3F3F3);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color error = Color(0xFFD83B01);
  static const Color success = Color(0xFF107C10);
  static const Color warning = Color(0xFFFFB900);
  static const Color textPrimary = Color(0xFF000000);
  static const Color textSecondary = Color(0xFF666666);
}

extension ColorExtension on Color {
  Color get darker => HSLColor.fromColor(this)
      .withLightness((HSLColor.fromColor(this).lightness - 0.1).clamp(0.0, 1.0))
      .toColor();

  Color get dark => HSLColor.fromColor(this)
      .withLightness(
        (HSLColor.fromColor(this).lightness - 0.05).clamp(0.0, 1.0),
      )
      .toColor();
}
