import 'package:fpdart/fpdart.dart';
import 'package:hadir_core/src/domain/entities/user.dart';
import 'package:hadir_core/src/domain/value_objects/email_address.dart';
import 'package:hadir_core/src/domain/value_objects/user_type.dart';

abstract class AuthFailure {
  const AuthFailure();
  String get message;
}

class ServerError extends AuthFailure {
  @override
  String get message => 'Server error occurred';
}

class EmailAlreadyInUse extends AuthFailure {
  @override
  String get message => 'Email is already in use';
}

class InvalidEmailAndPasswordCombination extends AuthFailure {
  @override
  String get message => 'Invalid email and password combination';
}

class InvalidStudentId extends AuthFailure {
  @override
  String get message => 'Invalid student ID';
}

abstract class IAuthRepository {
  Future<Either<AuthFailure, User>> signIn({
    required EmailAddress email,
    required String password,
  });

  Future<Either<AuthFailure, Unit>> signOut();

  Future<Either<AuthFailure, User>> getCurrentUser();

  Future<Either<AuthFailure, User>> registerWithEmailAndPassword({
    required EmailAddress email,
    required String password,
    required String fullName,
    required String? studentId,
    required UserType userType,
  });

  Stream<Option<User>> authStateChanges();
}
