import 'package:fpdart/fpdart.dart';
import 'package:hadir_core/src/domain/entities/schedule.dart';
import 'package:hadir_core/src/domain/repositories/schedule_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sp;

class ScheduleRepository implements IScheduleRepository {
  ScheduleRepository(this._client);

  final sp.SupabaseClient _client;

  @override
  Future<Either<ScheduleFailure, Schedule>> createSchedule(
    Schedule schedule,
  ) async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) return left(InsufficientPermission());

      final response = await _client
          .from('schedules')
          .insert(schedule.toJson())
          .select()
          .single();

      return right(Schedule.fromJson(response));
    } catch (_) {
      return left(ServerError());
    }
  }

  @override
  Future<Either<ScheduleFailure, Unit>> deleteSchedule(
    String scheduleId,
  ) async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) return left(InsufficientPermission());

      await _client.from('schedules').delete().eq('id', scheduleId);
      return right(unit);
    } on sp.PostgrestException {
      return left(ScheduleNotFound());
    } catch (_) {
      return left(ServerError());
    }
  }

  @override
  Future<Either<ScheduleFailure, List<Schedule>>> getCourseSchedules(
    String courseId,
  ) async {
    try {
      final response =
          await _client.from('schedules').select().eq('course_id', courseId);

      return right(response.map((json) => Schedule.fromJson(json)).toList());
    } catch (_) {
      return left(ServerError());
    }
  }

  @override
  Future<Either<ScheduleFailure, Unit>> updateSchedule(
    Schedule schedule,
  ) async {
    try {
      await _client
          .from('schedules')
          .update(schedule.toJson())
          .eq('id', schedule.id);

      return right(unit);
    } on sp.PostgrestException {
      return left(ScheduleNotFound());
    } catch (_) {
      return left(ServerError());
    }
  }
}
