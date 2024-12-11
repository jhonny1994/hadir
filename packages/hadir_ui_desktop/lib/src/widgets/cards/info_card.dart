import 'package:fluent_ui/fluent_ui.dart';
import 'package:hadir_ui_desktop/src/theme/spacing.dart';

class InfoCard extends StatelessWidget {
  const InfoCard({
    required this.title,
    required this.value,
    super.key,
    this.icon,
    this.iconColor,
    this.onTap,
  });
  final String title;
  final String value;
  final IconData? icon;
  final Color? iconColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      padding: const EdgeInsets.all(HadirSpacing.md),
      borderRadius: BorderRadius.circular(HadirSpacing.cardBorderRadius),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null)
            Icon(
              icon,
              color: iconColor ?? FluentTheme.of(context).accentColor,
              size: 24,
            ),
          const SizedBox(height: HadirSpacing.sm),
          Text(
            title,
            style: FluentTheme.of(context).typography.caption,
          ),
          const SizedBox(height: HadirSpacing.xs),
          Text(
            value,
            style: FluentTheme.of(context).typography.title,
          ),
        ],
      ),
    );
  }
}
