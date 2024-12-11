import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hadir_core/src/application/providers/supabase_provider.dart';
import 'package:hadir_core/src/domain/entities/schedule.dart';
import 'package:hadir_core/src/domain/repositories/schedule_repository.dart';
import 'package:hadir_core/src/infrastructure/repositories/schedule_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'schedule_providers.g.dart';

@Riverpod(keepAlive: true)
IScheduleRepository scheduleRepository(Ref ref) {
  return ScheduleRepository(ref.read(supabaseProvider));
}

@riverpod
Future<List<Schedule>> courseSchedules(Ref ref, String courseId) async {
  final result =
      await ref.watch(scheduleRepositoryProvider).getCourseSchedules(courseId);
  return result.fold(
    (failure) => [],
    (schedules) => schedules,
  );
}

@riverpod
Future<Schedule?> createSchedule(
  Ref ref,
  Schedule schedule,
) async {
  final result =
      await ref.watch(scheduleRepositoryProvider).createSchedule(schedule);
  return result.fold(
    (failure) => null,
    (schedule) => schedule,
  );
}
