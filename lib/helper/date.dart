import 'package:intl/intl.dart';

extension Format on DateTime {
  String format() {
    var dateFormat = DateFormat("dd.MM.yyyy");
    return dateFormat.format(this);
  }

  bool isSameDate(DateTime other) {
    return other.day == day && other.month == month && other.year == year;
  }

  DateTime next(int day) {
    return add(Duration(days: (day + 1 - weekday) % DateTime.daysPerWeek));
  }

  DateTime asDate() {
    return DateTime(year, month, day);
  }

  bool isAfterOrEqualTo(DateTime dateTime) {
    final date = this;
    final isAtSameMomentAs = dateTime.isAtSameMomentAs(date);
    return isAtSameMomentAs | date.isAfter(dateTime);
  }

  bool isBeforeOrEqualTo(DateTime dateTime) {
    final date = this;
    final isAtSameMomentAs = dateTime.isAtSameMomentAs(date);
    return isAtSameMomentAs | date.isBefore(dateTime);
  }

  bool isBetween(
    DateTime fromDateTime,
    DateTime toDateTime,
  ) {
    final date = this;
    final isAfter = date.isAfterOrEqualTo(fromDateTime);
    final isBefore = date.isBeforeOrEqualTo(toDateTime);
    return isAfter && isBefore;
  }
}

class DateHelpers {
  static String weekDayNameAtIndex(int index) {
    if (index < 0 || index > 7) throw "Index out of bounds";

    const List<String> weekdayName = [
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday",
      "Sunday"
    ];
    return weekdayName[index];
  }
}
