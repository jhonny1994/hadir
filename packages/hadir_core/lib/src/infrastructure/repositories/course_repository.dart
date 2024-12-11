import 'package:fpdart/fpdart.dart';
import 'package:hadir_core/src/domain/domain.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sp;

class CourseRepository extends ICourseRepository {
  CourseRepository(this._client);

  final sp.SupabaseClient _client;

  @override
  Future<Either<AppFailure, Course>> createCourse({
    required String name,
    required String professorId,
  }) async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null || userId != professorId) {
        return left(InsufficientPermission());
      }

      final response = await _client
          .from('courses')
          .insert({
            'name': name,
            'professor_id': professorId,
          })
          .select()
          .single();

      return right(Course.fromJson(response));
    } catch (_) {
      return left(ServerError());
    }
  }

  @override
  Future<Either<AppFailure, Unit>> deleteCourse(String courseId) async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) return left(InsufficientPermission());

      final course =
          await _client.from('courses').select().eq('id', courseId).single();

      if (course['professor_id'] != userId) {
        return left(InsufficientPermission());
      }

      await _client.from('courses').delete().eq('id', courseId);
      return right(unit);
    } on sp.PostgrestException {
      return left(CourseNotFound());
    } catch (_) {
      return left(ServerError());
    }
  }

  @override
  Future<Either<AppFailure, Unit>> enrollStudent({
    required String courseId,
    required String studentId,
  }) async {
    try {
      await _client.from('enrollments').insert({
        'course_id': courseId,
        'student_id': studentId,
      });

      return right(unit);
    } on sp.PostgrestException catch (e) {
      if (e.message.contains('not_found')) {
        return left(CourseNotFound());
      }
      return left(ServerError());
    } catch (_) {
      return left(ServerError());
    }
  }

  @override
  Future<Either<AppFailure, List<Schedule>>> getCourseSchedules(
    String courseId,
  ) async {
    try {
      final response =
          await _client.from('schedules').select().eq('course_id', courseId);

      return right(response.map((json) => Schedule.fromJson(json)).toList());
    } on sp.PostgrestException {
      return left(CourseNotFound());
    } catch (_) {
      return left(ServerError());
    }
  }

  @override
  Future<Either<AppFailure, List<User>>> getEnrolledStudents(
    String courseId,
  ) async {
    try {
      final response = await _client
          .from('enrollments')
          .select('profiles(*)')
          .eq('course_id', courseId);

      return right(
        response
            .map(
              (json) => User.fromJson(json['profiles'] as Map<String, dynamic>),
            )
            .toList(),
      );
    } on sp.PostgrestException {
      return left(CourseNotFound());
    } catch (_) {
      return left(ServerError());
    }
  }

  @override
  Future<Either<AppFailure, List<Course>>> getProfessorCourses() async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) return left(InsufficientPermission());

      final response =
          await _client.from('courses').select().eq('professor_id', userId);

      return right(response.map((json) => Course.fromJson(json)).toList());
    } catch (_) {
      return left(ServerError());
    }
  }

  @override
  Future<Either<AppFailure, List<Course>>> getStudentCourses() async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) return left(InsufficientPermission());

      final response = await _client
          .from('enrollments')
          .select('courses(*)')
          .eq('student_id', userId);

      return right(
        response
            .map(
              (json) =>
                  Course.fromJson(json['courses'] as Map<String, dynamic>),
            )
            .toList(),
      );
    } catch (_) {
      return left(ServerError());
    }
  }

  @override
  Future<Either<AppFailure, Course>> joinCourse({
    required CourseCode joinCode,
    required String studentId,
  }) async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null || userId != studentId) {
        return left(InsufficientPermission());
      }

      final course = await _client
          .from('courses')
          .select()
          .eq('join_code', joinCode.value)
          .single();

      await _client.from('enrollments').insert({
        'course_id': course['id'],
        'student_id': studentId,
      });

      return right(Course.fromJson(course));
    } on sp.PostgrestException catch (e) {
      if (e.message.contains('not_found')) {
        return left(CourseNotFound());
      }
      if (e.message.contains('already_enrolled')) {
        return left(AlreadyEnrolled());
      }
      return left(ServerError());
    } catch (_) {
      return left(ServerError());
    }
  }

  @override
  Future<Either<AppFailure, Unit>> updateCourse(Course course) async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null || userId != course.professorId) {
        return left(InsufficientPermission());
      }

      await _client
          .from('courses')
          .update(course.toJson())
          .eq('id', course.id)
          .select()
          .single();

      return right(unit);
    } catch (_) {
      return left(ServerError());
    }
  }
}
