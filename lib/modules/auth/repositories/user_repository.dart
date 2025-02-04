import 'package:pumba/modules/auth/models/app_user.dart';
import 'package:pumba/modules/auth/models/gender.dart';

abstract class UserRepository {
  Future<void> signOut();

  Future<void> createUserWithEmailAndPassword(String email, String password);

  Future<void> deleteUser();

  Future<void> removeUserData();

  Stream<AppUser?> getAppUser();

  Stream<AppUser?> listenToUser();

  Future<void> sendTerminationTime();

  Future<void> saveUserData({
    required String firstName,
    required String lastName,
    required String email,
    required Gender gender,
  });

  Future<void> signInWithEmailAndPassword(String email, String password);
}
