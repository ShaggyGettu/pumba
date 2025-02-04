import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pumba/core/router/app_route.dart';

class AppRouter {
  static final _logger = FimberLog('AppRouter');

  AppRouter._();

  static GoRouter? _instance;

  static GoRouter get router {
    _instance ??= _initRouter();
    return _instance!;
  }

  static void pop(BuildContext context, [dynamic result]) {
    try {
      _logger.i('Pop with result: $result');
      router.pop(result);
    } catch (e) {
      _logger.e('Error popping route: $e');
    }
  }

  static void goNamed(
    AppRoute appRoute, {
    Map<String, String> pathParams = const {},
    Map<String, String> queryParams = const {},
    Object? extra,
  }) {
    try {
      _logger.i('Go to named route: ${appRoute.data.displayName}');
      router.goNamed(
        appRoute.data.displayName,
        pathParameters: pathParams,
        queryParameters: queryParams,
        extra: extra,
      );
    } catch (e) {
      _logger.e('Error navigating to named route: $e');
    }
  }

  static Future<T?> pushNamed<T>(
    AppRoute appRoute, {
    Map<String, String> pathParams = const {},
    Map<String, String> queryParams = const {},
    Object? extra,
  }) async {
    try {
      _logger.i('Push to named route: ${appRoute.data.displayName}');
      return router.pushNamed<T>(
        appRoute.data.displayName,
        pathParameters: pathParams,
        queryParameters: queryParams,
        extra: extra,
      );
    } catch (e) {
      _logger.e('Error pushing to named route: $e');
      return null;
    }
  }

  static void popAll() {
    try {
      while (router.canPop()) {
        router.pop();
      }
    } catch (e) {
      _logger.e('Error popping all routes: $e');
    }
  }

  static GoRoute _buildGoRoute(
    AppRoute appRoute, {
    List<RouteBase> routes = const [],
    GlobalKey<NavigatorState>? navigatorKey,
  }) {
    final path = appRoute.data.path;
    final displayName = appRoute.data.displayName;
    final page = appRoute.data.page;
    final pageBuilder = appRoute.data.pageBuilder;
    final redirect = appRoute.data.redirect;

    return GoRoute(
      path: path,
      parentNavigatorKey: navigatorKey,
      name: displayName,
      builder:
          page == null ? null : (context, state) => page(context, state: state),
      pageBuilder: pageBuilder == null
          ? null
          : (context, state) => pageBuilder(context, state),
      routes: routes,
      redirect: redirect,
    );
  }

  static final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>();

  static GoRouter _initRouter() => GoRouter(
        navigatorKey: _rootNavigatorKey,
        initialLocation: AppRoute.splash.data.path,
        routes: [
          _buildGoRoute(AppRoute.splash),
          _buildGoRoute(AppRoute.home),
          _buildGoRoute(AppRoute.authPage),
        ],
      );
}
