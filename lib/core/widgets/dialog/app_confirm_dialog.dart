import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pumba/core/app_strings.dart';
import 'package:pumba/core/models/check_platform.dart';

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
    if (CheckPlatform.isAndroid) {
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
    } else if (CheckPlatform.isIOS) {
      return showCupertinoDialog<bool>(
        context: context,
        builder: (context) {
          return AppConfirmDialog(
            title: title,
            message: message,
            confirmText: confirmText,
            cancelText: cancelText,
          );
        },
      );
    }
    return null;
  }
}

class _AppConfirmDialogState extends ConsumerState<AppConfirmDialog> {
  @override
  Widget build(BuildContext context) {
    if (CheckPlatform.isAndroid) {
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
    } else if (CheckPlatform.isIOS) {
      return CupertinoAlertDialog(
        title: Text(widget.title),
        content: Text(widget.message),
        actions: <Widget>[
          CupertinoDialogAction(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(widget.cancelText ?? AppStrings.cancel),
          ),
          CupertinoDialogAction(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(widget.confirmText ?? AppStrings.ok),
          ),
        ],
      );
    } else {
      return Container();
    }
  }
}
