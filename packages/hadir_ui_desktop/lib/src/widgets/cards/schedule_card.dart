import 'package:fluent_ui/fluent_ui.dart';
import 'package:hadir_ui_desktop/src/theme/spacing.dart';

class ScheduleCard extends StatelessWidget {
  const ScheduleCard({
    required this.courseName,
    required this.time,
    super.key,
    this.onTap,
    this.isActive = false,
  });
  final String courseName;
  final String time;
  final VoidCallback? onTap;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Card(
      padding: const EdgeInsets.all(HadirSpacing.sm),
      borderRadius: BorderRadius.circular(HadirSpacing.cardBorderRadius),
      child: SizedBox(
        height: HadirSpacing.listItemHeight,
        child: ListTile(
          leading: Icon(
            FluentIcons.calendar,
            color: isActive
                ? FluentTheme.of(context).accentColor
                : FluentTheme.of(context).typography.body?.color,
          ),
          title: Text(
            courseName,
            style: FluentTheme.of(context).typography.body?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          subtitle: Text(
            time,
            style: FluentTheme.of(context).typography.caption,
          ),
          trailing: isActive
              ? FilledButton(
                  onPressed: onTap,
                  child: const Text('Start Session'),
                )
              : null,
        ),
      ),
    );
  }
}
