import 'package:fpdart/fpdart.dart';
import 'package:hadir_core/src/domain/domain.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sp;

class AuthRepository implements IAuthRepository {
  AuthRepository(this._client);

  final sp.SupabaseClient _client;

  @override
  Stream<Option<User>> authStateChanges() {
    return _client.auth.onAuthStateChange.map((event) {
      final session = event.session;
      if (session == null) return const None();
      return Option.of(_mapAuthUserToUser(session.user));
    });
  }

  @override
  Future<Either<AppFailure, User>> getCurrentUser() async {
    try {
      final user = _client.auth.currentUser;
      if (user == null) {
        return left(ServerError());
      }
      return right(_mapAuthUserToUser(user));
    } catch (_) {
      return left(ServerError());
    }
  }

  @override
  Future<Either<AppFailure, User>> registerWithEmailAndPassword({
    required EmailAddress email,
    required String password,
    required String fullName,
    required String? studentId,
    required UserType userType,
  }) async {
    try {
      final response = await _client.auth.signUp(
        email: email.value.getOrElse((l) => ''),
        password: password,
        data: {
          'full_name': fullName,
          'user_type': userType.toJson(),
          if (studentId != null) 'student_id': studentId,
        },
      );

      if (response.user == null) {
        return left(ServerError());
      }

      return right(_mapAuthUserToUser(response.user!));
    } on sp.AuthException catch (e) {
      if (e.message.contains('email')) {
        return left(EmailAlreadyInUse());
      }
      return left(ServerError());
    } catch (_) {
      return left(ServerError());
    }
  }

  @override
  Future<Either<AppFailure, User>> signIn({
    required EmailAddress email,
    required String password,
  }) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email.value.getOrElse((l) => ''),
        password: password,
      );

      if (response.user == null) {
        return left(InvalidEmailAndPasswordCombination());
      }

      return right(_mapAuthUserToUser(response.user!));
    } on sp.AuthException {
      return left(InvalidEmailAndPasswordCombination());
    } catch (_) {
      return left(ServerError());
    }
  }

  @override
  Future<Either<AppFailure, Unit>> signOut() async {
    try {
      await _client.auth.signOut();
      return right(unit);
    } catch (_) {
      return left(ServerError());
    }
  }

  User _mapAuthUserToUser(sp.User authUser) {
    final metadata = authUser.userMetadata;
    return User(
      id: authUser.id,
      email: authUser.email!,
      fullName: metadata?['full_name'] as String? ?? '',
      userType: UserType.fromJson(metadata?['user_type'] as String? ?? ''),
      studentId: metadata?['student_id'] as String?,
      createdAt: DateTime.parse(authUser.createdAt),
    );
  }
}
