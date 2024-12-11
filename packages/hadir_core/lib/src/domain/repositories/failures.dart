abstract class AppFailure {
  const AppFailure();
  String get message;
}

class ServerError extends AppFailure {
  @override
  String get message => 'Server error occurred';
}

class SessionExpired extends AppFailure {
  @override
  String get message => 'Attendance session has expired';
}

class InvalidQRCode extends AppFailure {
  @override
  String get message => 'Invalid QR code';
}

class AlreadyMarked extends AppFailure {
  @override
  String get message => 'Attendance already marked';
}

class EmailAlreadyInUse extends AppFailure {
  @override
  String get message => 'Email is already in use';
}

class InvalidEmailAndPasswordCombination extends AppFailure {
  @override
  String get message => 'Invalid email and password combination';
}

class InvalidStudentId extends AppFailure {
  @override
  String get message => 'Invalid student ID';
}

class InsufficientPermission extends AppFailure {
  @override
  String get message => 'Insufficient permissions';
}

class CourseNotFound extends AppFailure {
  @override
  String get message => 'Course not found';
}

class InvalidJoinCode extends AppFailure {
  @override
  String get message => 'Invalid join code';
}

class AlreadyEnrolled extends AppFailure {
  @override
  String get message => 'Student is already enrolled in this course';
}

class ScheduleConflict extends AppFailure {
  @override
  String get message => 'Schedule conflicts with existing schedule';
}

class ScheduleNotFound extends AppFailure {
  @override
  String get message => 'Schedule not found';
}
