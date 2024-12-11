import 'package:fpdart/fpdart.dart';
import 'package:hadir_core/src/domain/domain.dart';

abstract class ICourseRepository {
  Future<Either<AppFailure, List<Course>>> getProfessorCourses();

  Future<Either<AppFailure, List<Course>>> getStudentCourses();

  Future<Either<AppFailure, Course>> createCourse({
    required String name,
    required String professorId,
  });

  Future<Either<AppFailure, Unit>> updateCourse(Course course);

  Future<Either<AppFailure, Unit>> deleteCourse(String courseId);

  Future<Either<AppFailure, Unit>> enrollStudent({
    required String courseId,
    required String studentId,
  });

  Future<Either<AppFailure, List<User>>> getEnrolledStudents(
    String courseId,
  );

  Future<Either<AppFailure, List<Schedule>>> getCourseSchedules(
    String courseId,
  );

  Future<Either<AppFailure, Course>> joinCourse({
    required CourseCode joinCode,
    required String studentId,
  });
}
