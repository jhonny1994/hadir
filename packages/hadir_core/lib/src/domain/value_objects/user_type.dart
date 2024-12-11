import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_type.freezed.dart';

@freezed
class UserType with _$UserType {
  factory UserType.fromJson(String json) {
    switch (json) {
      case 'professor':
        return const UserType.professor();
      case 'student':
        return const UserType.student();
      default:
        throw ArgumentError('Invalid UserType: $json');
    }
  }
  const factory UserType.professor() = Professor;
  const factory UserType.student() = Student;

  const UserType._();

  bool get isProfessor => this is Professor;
  bool get isStudent => this is Student;

  String toJson() {
    return when(
      professor: () => 'professor',
      student: () => 'student',
    );
  }
}
