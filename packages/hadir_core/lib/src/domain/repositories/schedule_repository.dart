import 'package:fpdart/fpdart.dart';
import 'package:hadir_core/src/domain/entities/schedule.dart';
import 'package:hadir_core/src/domain/repositories/repositories.dart';

abstract class IScheduleRepository {
  Future<Either<AppFailure, List<Schedule>>> getCourseSchedules(
    String courseId,
  );

  Future<Either<AppFailure, Schedule>> createSchedule(Schedule schedule);

  Future<Either<AppFailure, Unit>> updateSchedule(Schedule schedule);

  Future<Either<AppFailure, Unit>> deleteSchedule(String scheduleId);
}
