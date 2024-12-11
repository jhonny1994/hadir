import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hadir_core/src/domain/entities/entity.dart';
import 'package:hadir_core/src/domain/value_objects/user_type.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
class User extends Entity with _$User {
  const factory User({
    required String id,
    required String fullName,
    required String email,
    required UserType userType,
    required DateTime createdAt,
    String? studentId,
    String? avatarUrl,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
