import 'package:flutter_animate/flutter_animate.dart';

extension DateTimeUtilMethod on DateTime {
  bool isToday() {
    DateTime dateTime = DateTime.now();
    return (dateTime.day == day &&
        dateTime.month == month &&
        dateTime.year == year);
  }

  bool isYesterday() {
    DateTime dateTime = DateTime.now().subtract(1.days);
    return (dateTime.day == day &&
        dateTime.month == month &&
        dateTime.year == year);
  }

  bool isTomorrow() {
    DateTime dateTime = DateTime.now().add(1.days);
    return (dateTime.day == day &&
        dateTime.month == month &&
        dateTime.year == year);
  }

  bool isLastWeek() {
    DateTime dateTime = DateTime.now();
    dateTime.subtract(
      Duration(
          hours: dateTime.hour,
          minutes: dateTime.minute,
          seconds: dateTime.second),
    );
    DateTime myTime = DateTime(year, month, day);
    return (myTime.difference(dateTime) > const Duration(days: -8) &&
        myTime.difference(dateTime).isNegative);
  }

  bool isNextWeek() {
    DateTime dateTime = DateTime.now();
    dateTime.subtract(
      Duration(
          hours: dateTime.hour,
          minutes: dateTime.minute,
          seconds: dateTime.second),
    );
    DateTime myTime = DateTime(year, month, day);
    return (myTime.difference(dateTime) < const Duration(days: 7) &&
        !myTime.difference(dateTime).isNegative);
  }
}
