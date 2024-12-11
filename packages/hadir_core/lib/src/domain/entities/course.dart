import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hadir_core/src/domain/entities/entity.dart';

part 'course.freezed.dart';
part 'course.g.dart';

@freezed
class Course extends Entity with _$Course {
  const factory Course({
    required String id,
    required String name,
    required String professorId,
    required String joinCode,
    required DateTime createdAt,
  }) = _Course;

  factory Course.fromJson(Map<String, dynamic> json) => _$CourseFromJson(json);
}
