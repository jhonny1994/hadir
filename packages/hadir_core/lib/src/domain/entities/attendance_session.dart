import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hadir_core/src/domain/entities/entity.dart';

part 'attendance_session.freezed.dart';
part 'attendance_session.g.dart';

@freezed
class AttendanceSession extends Entity with _$AttendanceSession {
  const factory AttendanceSession({
    required String id,
    required String courseId,
    required String scheduleId,
    required String qrCode,
    required DateTime createdAt,
    required DateTime expiresAt,
    String? backupCode,
    @Default(true) bool isActive,
  }) = _AttendanceSession;

  factory AttendanceSession.fromJson(Map<String, dynamic> json) =>
      _$AttendanceSessionFromJson(json);
}
