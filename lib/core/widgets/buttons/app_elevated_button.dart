import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppElevatedButton extends ConsumerStatefulWidget {
  final Future<void> Function()? onPressed;
  final String text;
  final Color backgroundColor;
  final TextStyle? textStyle;
  final EdgeInsets padding;
  final double? width;
  final double? height;

  const AppElevatedButton({
    super.key,
    this.onPressed,
    required this.text,
    required this.backgroundColor,
    this.textStyle,
    this.padding = const EdgeInsets.all(0),
    this.width,
    this.height,
  });

  @override
  ConsumerState<AppElevatedButton> createState() => _AppElevatedButtonState();
}

class _AppElevatedButtonState extends ConsumerState<AppElevatedButton> {
  bool _isPressed = false;

  Future<void> Function()? get onPressed => widget.onPressed;
  String get text => widget.text;
  Color get backgroundColor => widget.backgroundColor;
  TextStyle? get textStyle => widget.textStyle;
  EdgeInsets get padding => widget.padding;
  double? get width => widget.width;
  double? get height => widget.height;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed != null
          ? () async {
              if (_isPressed) return;
              setState(() {
                _isPressed = true;
              });
              await onPressed!();
              setState(() {
                _isPressed = false;
              });
            }
          : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
      ),
      child: Container(
        width: width,
        padding: padding,
        height: height,
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: textStyle ?? Theme.of(context).textTheme.bodyMedium,
            ),
            if (_isPressed) const CircularProgressIndicator.adaptive(),
          ],
        ),
      ),
    );
  }
}
