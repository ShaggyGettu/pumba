import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pumba/core/app_strings.dart';
import 'package:pumba/core/models/check_platform.dart';
import 'package:pumba/core/widgets/dialog/app_confirm_dialog.dart';
import 'package:timezone/timezone.dart' as tz;

enum ChannelType {
  location;

  String get id {
    switch (this) {
      case location:
        return 'location_channel_id';
    }
  }

  String get name {
    switch (this) {
      case location:
        return 'Location Channel';
    }
  }
}

class NotificationService {
  final _logger = FimberLog('NotificationService');
  static final _instance = NotificationService._internal();
  bool isPermissionGranted = false;
  final _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  factory NotificationService() => _instance;

  NotificationService._internal();

  Future<void> init() async {
    _logger.i('Initializing notification service');
    final androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final iosSettings = DarwinInitializationSettings();

    final settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _flutterLocalNotificationsPlugin.initialize(settings);
    await _isNotificationPermissionGranted();
  }

  Future<void> _isNotificationPermissionGranted() async {
    _logger.i('Checking notification permission');
    try {
      if (CheckPlatform.isAndroid) {
        final isGranted = await _flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>()
            ?.areNotificationsEnabled();
        isPermissionGranted = isGranted ?? false;
      } else if (CheckPlatform.isIOS) {
        final iosGranted = await Permission.notification.status.isGranted;
        isPermissionGranted = iosGranted;
      }
    } catch (e) {
      _logger.e('Error checking notification permission: $e');
    }
  }

  Future<void> requestPermission(
    BuildContext context, {
    required bool isFirstTime,
  }) async {
    _logger.i('Requesting notification permission');
    try {
      if (CheckPlatform.isAndroid) {
        await Permission.scheduleExactAlarm.request();
        isPermissionGranted = (await _flutterLocalNotificationsPlugin
                .resolvePlatformSpecificImplementation<
                    AndroidFlutterLocalNotificationsPlugin>()
                ?.requestNotificationsPermission()) ??
            false;
      } else if (CheckPlatform.isIOS) {
        isPermissionGranted = (await _flutterLocalNotificationsPlugin
                .resolvePlatformSpecificImplementation<
                    IOSFlutterLocalNotificationsPlugin>()
                ?.requestPermissions(
                  alert: true,
                  badge: true,
                  sound: true,
                )) ??
            false;
      }

      if (!isFirstTime && context.mounted && isPermissionGranted == false) {
        _logger.i('User denied notification permission');
        await AppConfirmDialog.show(
          context: context,
          title: AppStrings.notificationPermissionTitle,
          message: AppStrings.notificationPermissionMessage,
          confirmText: AppStrings.notificationPermissionConfirm,
        ).then(
          (value) async {
            if (value == true) {
              await openAppSettings();
            }
          },
        );
      }
    } catch (e) {
      _logger.e('Error requesting notification permission: $e');
    }
  }

  Future<void> showInstantNotification({
    required int id,
    required ChannelType channelType,
    required String title,
    required String body,
  }) async {
    _logger.i('Showing instant notification');
    final androidDetails = AndroidNotificationDetails(
      channelType.id,
      channelType.name,
      importance: Importance.high,
      priority: Priority.high,
    );
    final iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    try {
      await _flutterLocalNotificationsPlugin.show(
        id,
        title,
        body,
        notificationDetails,
      );
    } catch (e) {
      _logger.e('Error showing instant notification: $e');
    }
  }

  Future<void> showScheduledNotification({
    required int id,
    required ChannelType channelType,
    required String title,
    required String body,
    required DateTime scheduledTime,
  }) async {
    _logger.i('Showing scheduled notification');
    final androidDetails = AndroidNotificationDetails(
      channelType.id,
      channelType.name,
      importance: Importance.high,
      priority: Priority.high,
    );

    final notificationDetails = NotificationDetails(android: androidDetails);

    try {
      await _flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(scheduledTime, tz.local),
        notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    } catch (e) {
      _logger.e('Error showing scheduled notification: $e');
    }
  }
}
