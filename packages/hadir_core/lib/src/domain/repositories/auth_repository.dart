import 'package:fpdart/fpdart.dart';
import 'package:hadir_core/src/domain/domain.dart';

abstract class IAuthRepository {
  Future<Either<AppFailure, User>> signIn({
    required EmailAddress email,
    required String password,
  });

  Future<Either<AppFailure, Unit>> signOut();

  Future<Either<AppFailure, User>> getCurrentUser();

  Future<Either<AppFailure, User>> registerWithEmailAndPassword({
    required EmailAddress email,
    required String password,
    required String fullName,
    required String? studentId,
    required UserType userType,
  });

  Stream<Option<User>> authStateChanges();
}
