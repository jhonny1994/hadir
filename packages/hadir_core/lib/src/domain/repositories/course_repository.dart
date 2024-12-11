import 'package:fpdart/fpdart.dart';
import 'package:hadir_core/src/domain/entities/course.dart';
import 'package:hadir_core/src/domain/entities/schedule.dart';
import 'package:hadir_core/src/domain/entities/user.dart';
import 'package:hadir_core/src/domain/value_objects/course_code.dart';

abstract class CourseFailure {
  const CourseFailure();
  String get message;
}

class ServerError extends CourseFailure {
  @override
  String get message => 'Server error occurred';
}

class InsufficientPermission extends CourseFailure {
  @override
  String get message => 'Insufficient permissions';
}

class CourseNotFound extends CourseFailure {
  @override
  String get message => 'Course not found';
}

class InvalidJoinCode extends CourseFailure {
  @override
  String get message => 'Invalid join code';
}

class AlreadyEnrolled extends CourseFailure {
  @override
  String get message => 'Student is already enrolled in this course';
}

abstract class ICourseRepository {
  Future<Either<CourseFailure, List<Course>>> getProfessorCourses();

  Future<Either<CourseFailure, List<Course>>> getStudentCourses();

  Future<Either<CourseFailure, Course>> createCourse({
    required String name,
    required String professorId,
  });

  Future<Either<CourseFailure, Unit>> updateCourse(Course course);

  Future<Either<CourseFailure, Unit>> deleteCourse(String courseId);

  Future<Either<CourseFailure, Unit>> enrollStudent({
    required String courseId,
    required String studentId,
  });

  Future<Either<CourseFailure, List<User>>> getEnrolledStudents(
    String courseId,
  );

  Future<Either<CourseFailure, List<Schedule>>> getCourseSchedules(
    String courseId,
  );

  Future<Either<CourseFailure, Course>> joinCourse({
    required CourseCode joinCode,
    required String studentId,
  });
}
