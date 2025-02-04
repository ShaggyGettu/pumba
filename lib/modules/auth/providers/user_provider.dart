import 'dart:async';

import 'package:fimber/fimber.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pumba/modules/auth/models/app_user.dart';
import 'package:pumba/modules/auth/repositories/firebase_user_repository.dart';
import 'package:pumba/modules/auth/repositories/user_repository.dart';

final userProvider = StateNotifierProvider<UserNotifier, AppUser?>((ref) {
  return UserNotifier();
});

class UserNotifier extends StateNotifier<AppUser?> {
  final _logger = FimberLog('UserNotifier');
  StreamSubscription<AppUser?>? _authChangeSubscription;
  final UserRepository _userRepository = FirebaseUserRepository();
  UserNotifier() : super(null);

  void setUser(AppUser user) {
    state = user;
  }

  void clearUser() {
    state = null;
  }

  void initStream() {
    _authChangeSubscription?.cancel();
    clearUser();
    _listenToAppUser();
  }

  void _listenToAppUser() {
    _authChangeSubscription = _userRepository.getAppUser().listen((event) {
      _logger.i('_listenToAppUser: $event');
      state = event;
    });
  }

  @override
  void dispose() {
    _authChangeSubscription?.cancel();
    super.dispose();
  }
}
