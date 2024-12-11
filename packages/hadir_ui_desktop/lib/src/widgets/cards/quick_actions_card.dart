import 'package:fluent_ui/fluent_ui.dart';
import 'package:hadir_ui_desktop/src/theme/spacing.dart';
import 'package:hadir_ui_desktop/src/widgets/buttons/primary_button.dart';

class QuickActionsCard extends StatelessWidget {
  const QuickActionsCard({
    super.key,
    this.onQRPressed,
    this.onManualPressed,
  });
  final VoidCallback? onQRPressed;
  final VoidCallback? onManualPressed;

  @override
  Widget build(BuildContext context) {
    return Card(
      padding: const EdgeInsets.all(HadirSpacing.md),
      borderRadius: BorderRadius.circular(HadirSpacing.cardBorderRadius),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Quick Actions',
            style: FluentTheme.of(context).typography.subtitle,
          ),
          const SizedBox(height: HadirSpacing.md),
          Row(
            children: [
              Expanded(
                child: PrimaryButton(
                  text: 'Generate QR',
                  icon: const Icon(FluentIcons.q_r_code),
                  onPressed: onQRPressed,
                ),
              ),
              const SizedBox(width: HadirSpacing.sm),
              Expanded(
                child: PrimaryButton(
                  text: 'Manual Entry',
                  icon: const Icon(FluentIcons.edit),
                  onPressed: onManualPressed,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
