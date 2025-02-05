import 'dart:io';

import 'package:flutter/foundation.dart';

class CheckPlatform {
  static bool get isMobile => Platform.isAndroid || Platform.isIOS;

  static bool get isWeb => kIsWeb;

  static bool get isDesktop =>
      Platform.isWindows || Platform.isLinux || Platform.isMacOS;

  static bool get isWindows => Platform.isWindows;

  static bool get isLinux => Platform.isLinux;

  static bool get isMacOS => Platform.isMacOS;

  static bool get isAndroid => Platform.isAndroid;

  static bool get isIOS => Platform.isIOS;
}
