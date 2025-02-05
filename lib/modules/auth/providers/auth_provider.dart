import 'dart:async';

import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pumba/core/app_strings.dart';
import 'package:pumba/core/providers/permission_provider.dart';
import 'package:pumba/core/router/app_route.dart';
import 'package:pumba/core/router/app_routes.dart';
import 'package:pumba/modules/auth/models/app_user.dart';
import 'package:pumba/modules/auth/models/gender.dart';
import 'package:pumba/modules/auth/providers/user_provider.dart';
import 'package:pumba/modules/auth/repositories/firebase_user_repository.dart';
import 'package:pumba/modules/auth/repositories/user_repository.dart';

final authProvider = ChangeNotifierProvider((ref) => AuthNotifier(ref));

class AuthNotifier extends ChangeNotifier {
  final _logger = FimberLog('AuthProvider');
  final Ref _ref;
  final UserRepository _firebaseUserRepository = FirebaseUserRepository();
  StreamSubscription<AppUser?>? _authChangeSubscription;
  Timer? _terminateTimer;
  String? _errorMessage;

  AuthNotifier(this._ref) {
    _listenToAuthState();
  }

  UserNotifier get _userNotifier => _ref.read(userProvider.notifier);
  Duration get _terminationUpdateDuration => const Duration(seconds: 10);
  String? get errorMessage => _errorMessage;

  void _listenToAuthState() {
    _authChangeSubscription =
        _firebaseUserRepository.listenToUser().listen((user) async {
      _logger.i('authStateChanges: $user');
      if (user == null) {
        AppRouter.goNamed(AppRoute.authPage);
        _terminateTimer?.cancel();
        _logger.i('not authenticated');
      } else {
        _logger.i('authenticated');
        _userNotifier.initStream();
        await _ref.read(permissionProvider).requestLocationPermission();
        AppRouter.goNamed(AppRoute.home);
        _terminateTimer = Timer.periodic(_terminationUpdateDuration, (timer) {
          _logger.i('terminateSubscription');
          _firebaseUserRepository.sendTerminationTime();
        });
      }
      notifyListeners();
    });
  }

  Future<bool> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    _logger.i('signInWithEmailAndPassword: $email, $password');
    try {
      await _firebaseUserRepository.signInWithEmailAndPassword(
        email,
        password,
      );

      notifyListeners();
      _logger.i('signInWithEmailAndPassword: success');
      return true;
    } catch (e) {
      _logger.e('signInWithEmailAndPassword: $e');

      _errorMessage = AppStrings.invalidCredentials;
      notifyListeners();

      return false;
    }
  }

  Future<void> createUserWithEmailAndPassword({
    required String email,
    required String firstName,
    required String lastName,
    required String password,
    required Gender gender,
  }) async {
    try {
      _logger.i(
        'createUserWithEmailAndPassword: $firstName, $lastName, $email, $password',
      );
      await _firebaseUserRepository.createUserWithEmailAndPassword(
        email,
        password,
      );

      _logger.i('createUserWithEmailAndPassword: success');
      _firebaseUserRepository.saveUserData(
        firstName: firstName,
        lastName: lastName,
        email: email,
        gender: gender,
      );
      notifyListeners();
    } catch (e) {
      _logger.e('createUserWithEmailAndPassword: $e');
      _errorMessage = AppStrings.errorCreatingUser;
      notifyListeners();
    }
  }

  Future<void> deleteUser() async {
    try {
      _logger.i('deleteUser');
      AppRouter.goNamed(AppRoute.authPage);
      await _firebaseUserRepository.removeUserData();
      await _firebaseUserRepository.deleteUser();
    } catch (e) {
      _logger.e('deleteUser: $e');
      _errorMessage = AppStrings.failedToDeleteUser;
      notifyListeners();
    }
  }

  void clearErrorMessage() {
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> signOut() async {
    _logger.i('signout');
    try {
      await _firebaseUserRepository.sendTerminationTime();
      _firebaseUserRepository.signOut();
      notifyListeners();
    } catch (e) {
      _logger.e('signout: $e');
      _errorMessage = AppStrings.failedToSignOut;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _logger.i('dispose');
    _authChangeSubscription?.cancel();
    _terminateTimer?.cancel();
    super.dispose();
  }
}
