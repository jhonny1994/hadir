import 'package:fpdart/fpdart.dart';
import 'package:hadir_core/src/domain/entities/attendance_record.dart';
import 'package:hadir_core/src/domain/entities/attendance_session.dart';

abstract class AttendanceFailure {
  const AttendanceFailure();
  String get message;
}

class ServerError extends AttendanceFailure {
  @override
  String get message => 'Server error occurred';
}

class SessionExpired extends AttendanceFailure {
  @override
  String get message => 'Attendance session has expired';
}

class InvalidQRCode extends AttendanceFailure {
  @override
  String get message => 'Invalid QR code';
}

class AlreadyMarked extends AttendanceFailure {
  @override
  String get message => 'Attendance already marked';
}

class AttendanceStats {
  const AttendanceStats({
    required this.totalSessions,
    required this.present,
    required this.absent,
    required this.excused,
    required this.attendanceRate,
  });
  final int totalSessions;
  final int present;
  final int absent;
  final int excused;
  final double attendanceRate;
}

abstract class IAttendanceRepository {
  Future<Either<AttendanceFailure, AttendanceSession>> createSession({
    required String courseId,
    required String scheduleId,
  });

  Future<Either<AttendanceFailure, Unit>> markAttendance({
    required String sessionId,
    required String studentId,
    required String qrCode,
  });

  Future<Either<AttendanceFailure, List<AttendanceRecord>>> getSessionRecords(
    String sessionId,
  );

  Future<Either<AttendanceFailure, List<AttendanceRecord>>>
      getStudentAttendance({
    required String courseId,
    required String studentId,
  });

  Future<Either<AttendanceFailure, List<AttendanceSession>>>
      getCourseAttendanceSessions(
    String courseId,
  );

  Future<Either<AttendanceFailure, AttendanceStats>> getCourseAttendanceStats(
    String courseId,
  );

  Future<Either<AttendanceFailure, Unit>> submitExcuse({
    required String recordId,
    required String note,
  });

  Future<Either<AttendanceFailure, Unit>> reviewExcuse({
    required String recordId,
    required bool isApproved,
  });

  Future<Either<AttendanceFailure, String>> generateBackupCode(
    String sessionId,
  );
}
