import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pumba/core/app_strings.dart';

class AppConfirmDialog extends ConsumerStatefulWidget {
  final String title;
  final String message;
  final String? confirmText;
  final String? cancelText;

  const AppConfirmDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmText,
    this.cancelText,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AppConfirmDialogState();

  static Future<bool?> show({
    required BuildContext context,
    required String title,
    required String message,
    String? confirmText,
    String? cancelText,
  }) async {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: AppConfirmDialog(
            title: title,
            message: message,
            confirmText: confirmText,
            cancelText: cancelText,
          ),
        );
      },
    );
  }
}

class _AppConfirmDialogState extends ConsumerState<AppConfirmDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: Text(widget.message),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(widget.cancelText ?? AppStrings.cancel),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(widget.confirmText ?? AppStrings.ok),
        ),
      ],
    );
  }
}
