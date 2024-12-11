import 'package:intl/intl.dart';

class DateTimeUtils {
  static String formatTime(DateTime time) {
    return DateFormat('HH:mm').format(time);
  }

  static String formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  static String formatDayOfWeek(int dayOfWeek) {
    final days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    return days[dayOfWeek - 1];
  }

  static bool isWithinWindow(DateTime startTime, int windowMinutes) {
    final now = DateTime.now();
    final windowEnd = startTime.add(Duration(minutes: windowMinutes));
    return now.isAfter(startTime) && now.isBefore(windowEnd);
  }

  static String formatScheduleTime(DateTime startTime, DateTime endTime) {
    return '${formatTime(startTime)} - ${formatTime(endTime)}';
  }

  static String formatScheduleDay(
    int dayOfWeek,
    DateTime startTime,
    DateTime endTime,
  ) {
    return '${formatDayOfWeek(dayOfWeek)} ${formatScheduleTime(startTime, endTime)}';
  }
}
