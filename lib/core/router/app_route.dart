import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pumba/modules/auth/pages/auth_page.dart';
import 'package:pumba/modules/auth/pages/splash_page.dart';
import 'package:pumba/modules/home/pages/home_page.dart';

class AppRouteModel {
  final String path;
  final String displayName;
  final Function(BuildContext context, {GoRouterState? state, Widget? child})?
      page;
  final FutureOr<String?> Function(BuildContext, GoRouterState)? redirect;
  final Page<dynamic> Function(BuildContext, GoRouterState)? pageBuilder;

  AppRouteModel({
    required this.path,
    this.displayName = '',
    this.page,
    this.redirect,
    this.pageBuilder,
  });

  String get asSubRoute => path[0] == '/' ? path.replaceFirst('/', '') : path;
}

enum AppRoute {
  splash,
  home,
  authPage;

  AppRouteModel get data {
    switch (this) {
      case AppRoute.splash:
        return AppRouteModel(
          path: '/',
          displayName: 'Splash',
          page: (context, {state, child}) => SplashPage(),
        );

      case AppRoute.home:
        return AppRouteModel(
          path: '/home',
          displayName: 'Home',
          page: (context, {state, child}) => HomePage(),
        );

      case AppRoute.authPage:
        return AppRouteModel(
          path: '/auth',
          displayName: 'Auth',
          page: (context, {state, child}) => const AuthPage(),
        );
    }
  }
}
