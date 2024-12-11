import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hadir_core/src/application/providers/supabase_provider.dart';
import 'package:hadir_core/src/domain/entities/user.dart';
import 'package:hadir_core/src/domain/repositories/auth_repository.dart';
import 'package:hadir_core/src/infrastructure/repositories/auth_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_providers.g.dart';

@Riverpod(keepAlive: true)
IAuthRepository authRepository(Ref ref) {
  return AuthRepository(ref.read(supabaseProvider));
}

@Riverpod(keepAlive: true)
Stream<User?> authStateChanges(Ref ref) {
  return ref.watch(authRepositoryProvider).authStateChanges().map(
        (userOption) => userOption.toNullable(),
      );
}

@Riverpod(keepAlive: true)
Future<User?> currentUser(Ref ref) async {
  final result = await ref.watch(authRepositoryProvider).getCurrentUser();
  return result.fold(
    (failure) => null,
    (user) => user,
  );
}
