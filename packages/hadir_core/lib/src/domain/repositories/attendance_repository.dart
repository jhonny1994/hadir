import 'package:fpdart/fpdart.dart';
import 'package:hadir_core/src/domain/domain.dart';

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
  Future<Either<AppFailure, AttendanceSession>> createSession({
    required String courseId,
    required String scheduleId,
  });

  Future<Either<AppFailure, Unit>> markAttendance({
    required String sessionId,
    required String studentId,
    required String qrCode,
  });

  Future<Either<AppFailure, List<AttendanceRecord>>> getSessionRecords(
    String sessionId,
  );

  Future<Either<AppFailure, List<AttendanceRecord>>> getStudentAttendance({
    required String courseId,
    required String studentId,
  });

  Future<Either<AppFailure, List<AttendanceSession>>>
      getCourseAttendanceSessions(
    String courseId,
  );

  Future<Either<AppFailure, AttendanceStats>> getCourseAttendanceStats(
    String courseId,
  );

  Future<Either<AppFailure, Unit>> submitExcuse({
    required String recordId,
    required String note,
  });

  Future<Either<AppFailure, Unit>> reviewExcuse({
    required String recordId,
    required bool isApproved,
  });

  Future<Either<AppFailure, String>> generateBackupCode(
    String sessionId,
  );
}
