import 'package:fluent_ui/fluent_ui.dart';
import 'package:hadir_ui_desktop/src/theme/colors.dart';
import 'package:hadir_ui_desktop/src/theme/typography.dart';

class HadirTheme {
  static FluentThemeData light() {
    return FluentThemeData(
      accentColor: AccentColor.swatch({
        'darkest': HadirColors.primary.darker,
        'darker': HadirColors.primary.dark,
        'dark': HadirColors.primary.withOpacity(0.8),
        'normal': HadirColors.primary,
        'light': HadirColors.primary.withOpacity(0.6),
        'lighter': HadirColors.primary.withOpacity(0.4),
        'lightest': HadirColors.primary.withOpacity(0.2),
      }),
      typography: const Typography.raw(
        titleLarge: HadirTypography.heading1,
        title: HadirTypography.heading2,
        body: HadirTypography.body,
        caption: HadirTypography.caption,
      ),
      brightness: Brightness.light,
      visualDensity: VisualDensity.standard,
      focusTheme: const FocusThemeData(glowFactor: 0),
    );
  }

  static FluentThemeData dark() {
    return light().copyWith(brightness: Brightness.dark);
  }
}
