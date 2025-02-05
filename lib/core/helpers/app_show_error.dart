import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pumba/core/app_strings.dart';
import 'package:pumba/core/models/check_platform.dart';

abstract class AppShowError {
  static Future<void> showError({
    required BuildContext context,
    required String message,
  }) async {
    if (CheckPlatform.isAndroid) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
    } else if (CheckPlatform.isIOS) {
      await showDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text(AppStrings.error),
            content: Text(message),
            actions: [
              CupertinoDialogAction(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(AppStrings.ok),
              ),
            ],
          );
        },
      );
    } else {
      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: SelectableText(message),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(AppStrings.ok),
              ),
            ],
          );
        },
      );
    }
  }

  static showMessage({
    required BuildContext context,
    required String message,
    required String title,
  }) {
    if (CheckPlatform.isMobile) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: SelectableText(title),
            content: SelectableText(message),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(AppStrings.ok),
              ),
            ],
          );
        },
      );
    }
  }
}
