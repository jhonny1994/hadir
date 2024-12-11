import 'package:fluent_ui/fluent_ui.dart';
import 'package:hadir_ui_desktop/src/theme/spacing.dart';

class SearchBox extends StatelessWidget {
  const SearchBox({
    super.key,
    this.placeholder = 'Search',
    this.controller,
    this.onChanged,
    this.onClear,
    this.autofocus = false,
  });
  final String placeholder;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: HadirSpacing.inputHeight,
      child: TextBox(
        controller: controller,
        placeholder: placeholder,
        onChanged: onChanged,
        autofocus: autofocus,
        prefix: const Padding(
          padding: EdgeInsets.only(left: 8),
          child: Icon(FluentIcons.search, size: 16),
        ),
        suffix: controller?.text.isNotEmpty == true
            ? IconButton(
                icon: const Icon(FluentIcons.clear, size: 16),
                onPressed: () {
                  controller?.clear();
                  onClear?.call();
                },
              )
            : null,
        decoration: BoxDecoration(
          border: Border.all(
            color: FluentTheme.of(context).resources.controlStrokeColorDefault,
          ),
          borderRadius: BorderRadius.circular(HadirSpacing.xs),
        ),
      ),
    );
  }
}
