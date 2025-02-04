import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pumba/core/app_colors.dart';

class AppFormField extends ConsumerWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final FocusNode? focusNode;
  final String? label;
  final String? placeholder;
  final TextStyle? placeholderStyle;
  final TextInputType? keyboardType;
  final EdgeInsetsGeometry padding;
  final EdgeInsets headTextPadding;
  final bool isShowingLabel;
  final bool isObscureText;
  final Widget? suffixIcon;
  final int? errorMaxLines;
  final bool readOnly;
  final bool autoFocus;
  final Widget? suffixWidget;
  final TextInputAction? textInputAction;
  final void Function()? onEditingComplete;
  final bool isDense;
  final String? prefixText;
  final int? maxLines;
  final EdgeInsetsGeometry? textPadding;

  const AppFormField({
    super.key,
    this.label,
    this.placeholder,
    this.placeholderStyle,
    required this.controller,
    this.keyboardType,
    this.padding = EdgeInsets.zero,
    this.headTextPadding = EdgeInsets.zero,
    this.isShowingLabel = false,
    this.isObscureText = false,
    this.suffixIcon,
    this.validator,
    this.errorMaxLines,
    this.readOnly = false,
    this.autoFocus = false,
    this.suffixWidget,
    this.focusNode,
    this.onEditingComplete,
    this.textInputAction,
    this.isDense = false,
    this.prefixText,
    this.maxLines,
    this.textPadding,
  });

  BorderRadius get _textFieldBorderRadius => BorderRadius.circular(18.0);

  EdgeInsets get _contentPadding => const EdgeInsets.only(left: 28, right: 16);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isShowingLabel && label != null)
            Padding(
              padding: headTextPadding,
              child: Text(
                label!,
                style: theme.textTheme.bodySmall,
              ),
            ),
          TextFormField(
            validator: validator,
            focusNode: focusNode,
            readOnly: readOnly,
            autofocus: autoFocus,
            onEditingComplete: onEditingComplete,
            maxLines: maxLines,
            decoration: InputDecoration(
              isDense: isDense,
              errorMaxLines: errorMaxLines,
              labelText: !isShowingLabel ? label : null,
              hintText: placeholder,
              hintStyle: placeholderStyle,
              fillColor: AppColors.lightGreen,
              filled: true,
              prefix: prefixText != null ? Text(prefixText!) : null,
              border: OutlineInputBorder(
                borderRadius: _textFieldBorderRadius,
                borderSide: BorderSide.none,
              ),
              contentPadding: textPadding ?? _contentPadding,
              suffix: suffixIcon,
              suffixIconConstraints: const BoxConstraints(
                minWidth: 24,
                minHeight: 24,
              ),
              suffixIcon: suffixWidget,
            ),
            controller: controller,
            style: theme.textTheme.bodySmall,
            keyboardType: keyboardType,
            obscureText: isObscureText,
            obscuringCharacter: '●',
            textInputAction: textInputAction,
          ),
        ],
      ),
    );
  }
}
