import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

final permissionProvider = ChangeNotifierProvider(
  (_) => PermissionNotifier(),
);

class PermissionNotifier extends ChangeNotifier {
  final _logger = FimberLog('PermissionNotifier');
  late PermissionStatus _locationPermissionStatus;

  PermissionNotifier() {
    _logger.i('PermissionNotifier created');
  }

  PermissionStatus get locationPermissionStatus => _locationPermissionStatus;

  Future<void> requestLocationPermission() async {
    _logger.i('requestLocationPermission');
    _locationPermissionStatus = await Permission.location.request();
    notifyListeners();
    if (_locationPermissionStatus.isGranted) {
      _logger.i('Location permission granted');
    } else if (_locationPermissionStatus.isDenied) {
      _logger.i('Location permission denied');
    } else if (_locationPermissionStatus.isPermanentlyDenied) {
      _logger.i('Location permission permanently denied');
      openAppSettings();
    }
  }
}
