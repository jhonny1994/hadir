import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hadir_core/src/domain/entities/entity.dart';

part 'schedule.freezed.dart';
part 'schedule.g.dart';

@freezed
class Schedule extends Entity with _$Schedule {
  const factory Schedule({
    required String id,
    required String courseId,
    required int dayOfWeek,
    required DateTime startTime,
    required DateTime endTime,
    required DateTime createdAt,
    @Default(15) int attendanceWindow,
  }) = _Schedule;

  factory Schedule.fromJson(Map<String, dynamic> json) =>
      _$ScheduleFromJson(json);
}
