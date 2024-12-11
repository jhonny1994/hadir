import 'package:fluent_ui/fluent_ui.dart';
import 'package:hadir_ui_desktop/src/theme/spacing.dart';

class TextInput extends StatelessWidget {
  const TextInput({
    required this.label,
    super.key,
    this.placeholder,
    this.errorText,
    this.obscureText = false,
    this.controller,
    this.onChanged,
    this.keyboardType,
    this.autofocus = false,
    this.validator,
  });
  final String label;
  final String? placeholder;
  final String? errorText;
  final bool obscureText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final TextInputType? keyboardType;
  final bool autofocus;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        InfoLabel(
          label: label,
          labelStyle: FluentTheme.of(context).typography.caption,
        ),
        const SizedBox(height: HadirSpacing.xs),
        SizedBox(
          height: HadirSpacing.inputHeight,
          child: TextBox(
            controller: controller,
            placeholder: placeholder,
            obscureText: obscureText,
            onChanged: onChanged,
            keyboardType: keyboardType,
            autofocus: autofocus,
            decoration: BoxDecoration(
              border: Border.all(
                color: errorText != null
                    ? FluentTheme.of(context)
                        .resources
                        .systemFillColorCriticalBackground
                    : FluentTheme.of(context)
                        .resources
                        .controlStrokeColorDefault,
              ),
              borderRadius: BorderRadius.circular(HadirSpacing.xs),
            ),
            style: errorText != null
                ? TextStyle(
                    color: FluentTheme.of(context)
                        .resources
                        .systemFillColorCriticalBackground,
                  )
                : null,
            suffix: errorText != null
                ? Icon(
                    FluentIcons.error_badge,
                    color: FluentTheme.of(context)
                        .resources
                        .systemFillColorCriticalBackground,
                    size: 16,
                  )
                : null,
          ),
        ),
        if (errorText != null) ...[
          const SizedBox(height: HadirSpacing.xs),
          Text(
            errorText!,
            style: FluentTheme.of(context).typography.caption?.copyWith(
                  color: FluentTheme.of(context)
                      .resources
                      .systemFillColorCriticalBackground,
                ),
          ),
        ],
      ],
    );
  }
}
