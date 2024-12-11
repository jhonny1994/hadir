import 'package:fluent_ui/fluent_ui.dart';
import 'package:hadir_ui_desktop/src/theme/spacing.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    required this.text,
    super.key,
    this.onPressed,
    this.loading = false,
    this.width,
    this.icon,
  });
  final String text;
  final VoidCallback? onPressed;
  final bool loading;
  final double? width;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: HadirSpacing.buttonHeight,
      width: width,
      child: FilledButton(
        onPressed: loading ? null : onPressed,
        child: loading
            ? const ProgressRing(strokeWidth: 2)
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    icon!,
                    const SizedBox(width: 8),
                  ],
                  Text(text),
                ],
              ),
      ),
    );
  }
}
