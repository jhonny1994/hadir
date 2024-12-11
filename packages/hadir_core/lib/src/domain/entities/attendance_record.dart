import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hadir_core/src/domain/entities/entity.dart';

part 'attendance_record.freezed.dart';
part 'attendance_record.g.dart';

enum AttendanceStatus { present, absent, excused }

@freezed
class AttendanceRecord extends Entity with _$AttendanceRecord {
  const factory AttendanceRecord({
    required String sessionId,
    required String studentId,
    required DateTime markedAt,
    required AttendanceStatus status,
    String? excuseNote,
    DateTime? excusedAt,
  }) = _AttendanceRecord;

  factory AttendanceRecord.fromJson(Map<String, dynamic> json) =>
      _$AttendanceRecordFromJson(json);
}
