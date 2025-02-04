import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fimber/fimber.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pumba/modules/auth/models/app_user.dart';
import 'package:pumba/modules/auth/models/gender.dart';
import 'package:pumba/modules/auth/repositories/user_repository.dart';

class FirebaseUserRepository implements UserRepository {
  final _logger = FimberLog('FirebaseUserRepository');
  final _firebaseAuth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  String get _usersCollection => AppUser.COLLECTION_NAME;
  String get _appEventsCollection => 'app_events';

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  @override
  Future<void> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      _logger.e('Error creating user: $e');
      throw Exception('Error creating user');
    }
  }

  @override
  Future<void> deleteUser() async {
    return _firebaseAuth.currentUser!.delete();
  }

  @override
  Future<void> removeUserData() async {
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      await _firestore.collection(_usersCollection).doc(user.uid).delete();
      await _firestore.collection(_appEventsCollection).doc(user.uid).delete();
    }
  }

  @override
  Stream<AppUser?> getAppUser() {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      return Stream.value(null);
    }
    return _firestore
        .collection(_usersCollection)
        .doc(user.uid)
        .snapshots()
        .map(
      (event) {
        final map = event.data();
        if (map != null) {
          map[AppUser.UID_FIELD] = user.uid;
          try {
            return AppUser.fromJson(map);
          } catch (e) {
            _logger.e('Error getting user: $e');
          }
        }
        return null;
      },
    );
  }

  @override
  Stream<AppUser?> listenToUser() {
    return _firebaseAuth.authStateChanges().map((user) {
      if (user != null) {
        return AppUser.fromFirebaseUser(user);
      }
      return null;
    });
  }

  @override
  Future<void> saveUserData({
    required String firstName,
    required String lastName,
    required String email,
    required Gender gender,
  }) async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user != null) {
        _firestore.collection(_usersCollection).doc(user.uid).set({
          AppUser.FIRST_NAME_FIELD: firstName,
          AppUser.LAST_NAME_FIELD: lastName,
          AppUser.EMAIL_FIELD: email,
          AppUser.CREATED_AT_FIELD: DateTime.now().toIso8601String(),
          AppUser.UPDATED_AT_FIELD: DateTime.now().toIso8601String(),
          AppUser.GENDER_FIELD: gender.json,
        });
      }
    } catch (e) {
      _logger.e('Error saving user data: $e');
      throw Exception('Error saving user data');
    }
  }

  @override
  Future<void> signInWithEmailAndPassword(String email, String password) {
    return _firebaseAuth
        .signInWithEmailAndPassword(
      email: email,
      password: password,
    )
        .catchError((e) {
      _logger.e('Error signing in: $e');
      throw Exception('Error signing in');
    });
  }

  @override
  Future<void> sendTerminationTime() async {
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      _logger.i('sendTerminationTime');
      await _firestore.collection(_appEventsCollection).doc(user.uid).set({
        AppUser.TERMINATION_TIME_FIELD: DateTime.now().toIso8601String(),
      });
    }
  }
}
