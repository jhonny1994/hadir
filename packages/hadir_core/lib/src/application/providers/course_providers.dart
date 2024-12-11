import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hadir_core/src/application/providers/supabase_provider.dart';
import 'package:hadir_core/src/domain/entities/course.dart';
import 'package:hadir_core/src/domain/repositories/course_repository.dart';
import 'package:hadir_core/src/infrastructure/repositories/course_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'course_providers.g.dart';

@Riverpod(keepAlive: true)
ICourseRepository courseRepository(Ref ref) {
  return CourseRepository(ref.read(supabaseProvider));
}

@riverpod
Future<List<Course>> professorCourses(Ref ref) async {
  final result =
      await ref.watch(courseRepositoryProvider).getProfessorCourses();
  return result.fold(
    (failure) => [],
    (courses) => courses,
  );
}

@riverpod
Future<List<Course>> studentCourses(Ref ref) async {
  final result = await ref.watch(courseRepositoryProvider).getStudentCourses();
  return result.fold(
    (failure) => [],
    (courses) => courses,
  );
}
