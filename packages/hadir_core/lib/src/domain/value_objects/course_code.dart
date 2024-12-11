import 'package:fpdart/fpdart.dart';
import 'package:hadir_core/src/domain/value_objects/value_object.dart';

class CourseCodeFailure extends ValueFailure<String> {
  @override
  String get message => 'Course code must be between 6 and 10 characters';
}

class CourseCode extends ValueObject<String> {
  factory CourseCode(String input) {
    return CourseCode._(
      _validateCourseCode(input),
    );
  }

  const CourseCode._(this.value);

  @override
  final Either<ValueFailure<String>, String> value;

  static Either<ValueFailure<String>, String> _validateCourseCode(
    String input,
  ) {
    if (input.length >= 6 && input.length <= 10) {
      return right(input);
    } else {
      return left(CourseCodeFailure());
    }
  }
}
