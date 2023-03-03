import 'package:flutter_animate/flutter_animate.dart';

extension DateTimeUtilMethod on DateTime {
  bool isToday() {
    final dateTime = DateTime.now();
    return dateTime.day == day &&
        dateTime.month == month &&
        dateTime.year == year;
  }

  bool isYesterday() {
    final dateTime = DateTime.now().subtract(1.days);
    return dateTime.day == day &&
        dateTime.month == month &&
        dateTime.year == year;
  }

  bool isTomorrow() {
    final dateTime = DateTime.now().add(1.days);
    return dateTime.day == day &&
        dateTime.month == month &&
        dateTime.year == year;
  }

  bool isLastWeek() {
    final dateTime = DateTime.now();
    dateTime.subtract(
      Duration(
        hours: dateTime.hour,
        minutes: dateTime.minute,
        seconds: dateTime.second,
      ),
    );
    final myTime = DateTime(year, month, day);
    return myTime.difference(dateTime) > const Duration(days: -8) &&
        myTime.difference(dateTime).isNegative;
  }

  bool isNextWeek() {
    var dateTime = DateTime.now();
    dateTime = dateTime.subtract(
      Duration(
        hours: dateTime.hour,
        minutes: dateTime.minute,
        seconds: dateTime.second,
      ),
    );
    final myTime = DateTime(year, month, day);
    return myTime.difference(dateTime) < const Duration(days: 7) &&
        !myTime.difference(dateTime).isNegative;
  }
}
