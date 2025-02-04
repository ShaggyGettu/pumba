import 'dart:math';

import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pumba/modules/home/services/notification_service.dart';

final notificationProvider = ChangeNotifierProvider(
  (ref) => NotificationNotifier(),
);

class NotificationNotifier extends ChangeNotifier {
  final _logger = FimberLog('NotificationNotifier');
  late final NotificationService _notificationService;
  bool _isFirstTime = true;

  NotificationNotifier() {
    _notificationService = NotificationService();
    _notificationService.init().then(
          (_) => notifyListeners(),
        );
  }

  bool get isPermissionGranted => _notificationService.isPermissionGranted;

  Future<void> showNotification({
    required BuildContext context,
    required String title,
    required String body,
    required DateTime scheduledDate,
  }) async {
    try {
      await _notificationService.requestPermission(
        context,
        isFirstTime: _isFirstTime,
      );
      _isFirstTime = false;
      if (isPermissionGranted) {
        await _notificationService.showScheduledNotification(
          id: (Random().nextInt(100000)),
          channelType: ChannelType.location,
          title: title,
          body: body,
          scheduledTime: scheduledDate,
        );
        notifyListeners();
      }
    } catch (e) {
      _logger.e('Error showing notification: $e');
    }
  }
}
