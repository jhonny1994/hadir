import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hadir_core/src/application/providers/supabase_provider.dart';
import 'package:hadir_core/src/domain/entities/attendance_session.dart';
import 'package:hadir_core/src/domain/repositories/attendance_repository.dart';
import 'package:hadir_core/src/infrastructure/repositories/attendance_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'attendance_providers.g.dart';

@Riverpod(keepAlive: true)
IAttendanceRepository attendanceRepository(Ref ref) {
  return AttendanceRepository(ref.read(supabaseProvider));
}

@riverpod
Future<List<AttendanceSession>> courseAttendanceSessions(
  Ref ref,
  String courseId,
) async {
  final result = await ref
      .watch(attendanceRepositoryProvider)
      .getCourseAttendanceSessions(courseId);
  return result.fold(
    (failure) => [],
    (sessions) => sessions,
  );
}

@riverpod
Future<AttendanceStats?> courseAttendanceStats(
  Ref ref,
  String courseId,
) async {
  final result = await ref
      .watch(attendanceRepositoryProvider)
      .getCourseAttendanceStats(courseId);
  return result.fold(
    (failure) => null,
    (stats) => stats,
  );
}
