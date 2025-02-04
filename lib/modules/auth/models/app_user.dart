import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pumba/modules/auth/models/gender.dart';

class AppUser extends Equatable {
  static const String COLLECTION_NAME = 'users';
  static const String UID_FIELD = 'uid';
  static const String EMAIL_FIELD = 'email';
  static const String FIRST_NAME_FIELD = 'first_name';
  static const String LAST_NAME_FIELD = 'last_name';
  static const String CREATED_AT_FIELD = 'created_at';
  static const String UPDATED_AT_FIELD = 'updated_at';
  static const String GENDER_FIELD = 'gender';
  static const String TERMINATION_TIME_FIELD = 'termination_time';

  final String uid;
  final String? email;
  final String? firstName;
  final String? lastName;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Gender? gender;

  const AppUser({
    required this.uid,
    this.email,
    this.firstName,
    this.lastName,
    required this.createdAt,
    required this.updatedAt,
    this.gender,
  });

  factory AppUser.fromFirebaseUser(User user) {
    if (user.metadata.creationTime == null ||
        user.metadata.lastSignInTime == null) {
      throw Exception('User metadata is null');
    }
    return AppUser(
      uid: user.uid,
      email: user.email,
      createdAt: user.metadata.creationTime!,
      updatedAt: user.metadata.lastSignInTime!,
    );
  }

  AppUser copyWith({
    String? uid,
    String? email,
    String? firstName,
    String? lastName,
    DateTime? createdAt,
    DateTime? updatedAt,
    Gender? gender,
  }) {
    return AppUser(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      gender: gender ?? this.gender,
    );
  }

  factory AppUser.fromJson(Map<String, dynamic> json) {
    if (json[CREATED_AT_FIELD] == null || json[UPDATED_AT_FIELD] == null) {
      throw Exception('User metadata is null');
    }
    return AppUser(
      uid: json[UID_FIELD],
      email: json[EMAIL_FIELD],
      firstName: json[FIRST_NAME_FIELD],
      lastName: json[LAST_NAME_FIELD],
      createdAt: DateTime.parse(json[CREATED_AT_FIELD]),
      updatedAt: DateTime.parse(json[UPDATED_AT_FIELD]),
      gender: Gender.fromString(json[GENDER_FIELD]),
    );
  }

  @override
  String toString() => 'AppUser('
      '$UID_FIELD: $uid, '
      '$EMAIL_FIELD: $email, '
      '$FIRST_NAME_FIELD: $firstName, '
      '$LAST_NAME_FIELD: $lastName, '
      '$CREATED_AT_FIELD: $createdAt, '
      '$UPDATED_AT_FIELD: $updatedAt, '
      '$GENDER_FIELD: $gender'
      ')';

  Map<String, dynamic> get json => {
        UID_FIELD: uid,
        if (email != null) EMAIL_FIELD: email,
        if (firstName != null) FIRST_NAME_FIELD: firstName,
        if (lastName != null) LAST_NAME_FIELD: lastName,
        CREATED_AT_FIELD: createdAt,
        UPDATED_AT_FIELD: updatedAt,
        if (gender != null) GENDER_FIELD: gender,
      };

  @override
  List<Object?> get props => [
        uid,
        email,
        firstName,
        lastName,
        createdAt.toIso8601String(),
        updatedAt.toIso8601String(),
        gender?.name,
      ];

  @override
  bool get stringify => true;
}
