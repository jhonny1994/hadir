import 'package:fpdart/fpdart.dart';
import 'package:hadir_core/src/domain/domain.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sp;

class AttendanceRepository extends IAttendanceRepository {
  AttendanceRepository(this._client);

  final sp.SupabaseClient _client;
  @override
  Future<Either<AppFailure, AttendanceSession>> createSession({
    required String courseId,
    required String scheduleId,
  }) async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) return left(ServerError());

      final response = await _client
          .from('attendance_sessions')
          .insert({
            'course_id': courseId,
            'schedule_id': scheduleId,
            'created_by': userId,
          })
          .select()
          .single();

      return right(AttendanceSession.fromJson(response));
    } catch (_) {
      return left(ServerError());
    }
  }

  @override
  Future<Either<AppFailure, String>> generateBackupCode(
    String sessionId,
  ) async {
    try {
      final response = await _client.rpc<String>(
        'generate_backup_code',
        params: {'p_session_id': sessionId},
      );

      return right(response);
    } catch (_) {
      return left(ServerError());
    }
  }

  @override
  Future<Either<AppFailure, List<AttendanceSession>>>
      getCourseAttendanceSessions(String courseId) async {
    try {
      final response = await _client
          .from('attendance_sessions')
          .select()
          .eq('course_id', courseId);

      return right(
        response.map((json) => AttendanceSession.fromJson(json)).toList(),
      );
    } catch (_) {
      return left(ServerError());
    }
  }

  @override
  Future<Either<AppFailure, AttendanceStats>> getCourseAttendanceStats(
    String courseId,
  ) async {
    try {
      final response = await _client.rpc<Map<String, dynamic>>(
        'get_course_attendance_stats',
        params: {'p_course_id': courseId},
      );

      return right(
        AttendanceStats(
          totalSessions: response['total_sessions'] as int,
          present: response['present'] as int,
          absent: response['absent'] as int,
          excused: response['excused'] as int,
          attendanceRate: (response['attendance_rate'] as num).toDouble(),
        ),
      );
    } catch (_) {
      return left(ServerError());
    }
  }

  @override
  Future<Either<AppFailure, List<AttendanceRecord>>> getSessionRecords(
    String sessionId,
  ) async {
    try {
      final response = await _client
          .from('attendance_records')
          .select()
          .eq('session_id', sessionId);

      return right(
        response.map((json) => AttendanceRecord.fromJson(json)).toList(),
      );
    } catch (_) {
      return left(ServerError());
    }
  }

  @override
  Future<Either<AppFailure, List<AttendanceRecord>>> getStudentAttendance({
    required String courseId,
    required String studentId,
  }) async {
    try {
      final response = await _client
          .from('attendance_records')
          .select()
          .eq('student_id', studentId)
          .eq('attendance_sessions.course_id', courseId);

      return right(
        response.map((json) => AttendanceRecord.fromJson(json)).toList(),
      );
    } catch (_) {
      return left(ServerError());
    }
  }

  @override
  Future<Either<AppFailure, Unit>> markAttendance({
    required String sessionId,
    required String studentId,
    required String qrCode,
  }) async {
    try {
      final session = await _client
          .from('attendance_sessions')
          .select()
          .eq('id', sessionId)
          .single();

      if (session['qr_code'] != qrCode) {
        return left(InvalidQRCode());
      }

      if (DateTime.now()
          .isAfter(DateTime.parse(session['expires_at'] as String))) {
        return left(SessionExpired());
      }

      await _client.from('attendance_records').insert({
        'session_id': sessionId,
        'student_id': studentId,
      });

      return right(unit);
    } on sp.PostgrestException catch (e) {
      if (e.message.contains('already_marked')) {
        return left(AlreadyMarked());
      }
      return left(ServerError());
    } catch (_) {
      return left(ServerError());
    }
  }

  @override
  Future<Either<AppFailure, Unit>> reviewExcuse({
    required String recordId,
    required bool isApproved,
  }) async {
    try {
      await _client.from('attendance_excuses').update({
        'is_approved': isApproved,
        'reviewed_at': DateTime.now().toIso8601String(),
      }).eq('record_id', recordId);

      return right(unit);
    } catch (_) {
      return left(ServerError());
    }
  }

  @override
  Future<Either<AppFailure, Unit>> submitExcuse({
    required String recordId,
    required String note,
  }) async {
    try {
      await _client.from('attendance_excuses').insert({
        'record_id': recordId,
        'note': note,
      });

      return right(unit);
    } catch (_) {
      return left(ServerError());
    }
  }
}
