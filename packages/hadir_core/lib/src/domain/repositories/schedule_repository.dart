import 'package:fpdart/fpdart.dart';
import 'package:hadir_core/src/domain/entities/schedule.dart';

abstract class ScheduleFailure {
  const ScheduleFailure();
  String get message;
}

class ServerError extends ScheduleFailure {
  @override
  String get message => 'Server error occurred';
}

class ScheduleConflict extends ScheduleFailure {
  @override
  String get message => 'Schedule conflicts with existing schedule';
}

class ScheduleNotFound extends ScheduleFailure {
  @override
  String get message => 'Schedule not found';
}

class InsufficientPermission extends ScheduleFailure {
  @override
  String get message => 'Insufficient permissions';
}

abstract class IScheduleRepository {
  Future<Either<ScheduleFailure, List<Schedule>>> getCourseSchedules(
    String courseId,
  );

  Future<Either<ScheduleFailure, Schedule>> createSchedule(Schedule schedule);

  Future<Either<ScheduleFailure, Unit>> updateSchedule(Schedule schedule);

  Future<Either<ScheduleFailure, Unit>> deleteSchedule(String scheduleId);
}
