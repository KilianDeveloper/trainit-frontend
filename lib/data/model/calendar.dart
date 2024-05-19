import 'dart:convert';

import 'package:objectbox/objectbox.dart';
import 'package:trainit/data/model/calendar_training.dart';
import 'package:trainit/helper/date.dart';

@Entity()
class WeekCalendar {
  @Id(assignable: true)
  int localId = 0;

  @Transient()
  late List<CalendarTraining> day0;
  @Transient()
  late List<CalendarTraining> day1;
  @Transient()
  late List<CalendarTraining> day2;
  @Transient()
  late List<CalendarTraining> day3;
  @Transient()
  late List<CalendarTraining> day4;
  @Transient()
  late List<CalendarTraining> day5;
  @Transient()
  late List<CalendarTraining> day6;

  String get dbDay0 {
    return jsonEncode(day0);
  }

  set dbDay0(String value) {
    day0 = fromJson(value);
  }

  String get dbDay1 {
    return jsonEncode(day1);
  }

  set dbDay1(String value) {
    day1 = fromJson(value);
  }

  String get dbDay2 {
    return jsonEncode(day2);
  }

  set dbDay2(String value) {
    day2 = fromJson(value);
  }

  String get dbDay3 {
    return jsonEncode(day3);
  }

  set dbDay3(String value) {
    day3 = fromJson(value);
  }

  String get dbDay4 {
    return jsonEncode(day4);
  }

  set dbDay4(String value) {
    day4 = fromJson(value);
  }

  String get dbDay5 {
    return jsonEncode(day5);
  }

  set dbDay5(String value) {
    day5 = fromJson(value);
  }

  String get dbDay6 {
    return jsonEncode(day6);
  }

  set dbDay6(String value) {
    day6 = fromJson(value);
  }

  List<CalendarTraining> fromJson(String value) {
    final json = jsonDecode(value);
    return (json as List<dynamic>)
        .map<CalendarTraining>((e) => CalendarTraining.fromJson(e))
        .toList();
  }

  WeekCalendar({
    this.localId = 0,
    List<CalendarTraining>? day0,
    List<CalendarTraining>? day1,
    List<CalendarTraining>? day2,
    List<CalendarTraining>? day3,
    List<CalendarTraining>? day4,
    List<CalendarTraining>? day5,
    List<CalendarTraining>? day6,
  }) {
    this.day0 = day0 ?? [];
    this.day1 = day1 ?? [];
    this.day2 = day2 ?? [];
    this.day3 = day3 ?? [];
    this.day4 = day4 ?? [];
    this.day5 = day5 ?? [];
    this.day6 = day6 ?? [];
  }

  CalendarTraining? getElementWithBaseId(String baseId) {
    final List<CalendarTraining?> combined = [
      day0,
      day1,
      day2,
      day3,
      day4,
      day5,
      day6
    ].expand((element) => element).toList();
    final foundElements =
        combined.where((element) => element!.baseTrainingId == baseId).toList();
    return foundElements.isNotEmpty ? foundElements.first : null;
  }

  void insertAt({required int index, required CalendarTraining value}) {
    switch (index) {
      case 0:
        day0.add(value);
        break;
      case 1:
        day1.add(value);
        break;
      case 2:
        day2.add(value);
        break;
      case 3:
        day3.add(value);
        break;
      case 4:
        day4.add(value);
        break;
      case 5:
        day5.add(value);
        break;
      case 6:
        day6.add(value);
        break;
      default:
        return;
    }
  }

  void replace(String searchedId, CalendarTraining newValue) {
    day0 = _replaceAtList(day0, searchedId, newValue);
    day1 = _replaceAtList(day1, searchedId, newValue);
    day2 = _replaceAtList(day2, searchedId, newValue);
    day3 = _replaceAtList(day3, searchedId, newValue);
    day4 = _replaceAtList(day4, searchedId, newValue);
    day5 = _replaceAtList(day5, searchedId, newValue);
    day6 = _replaceAtList(day6, searchedId, newValue);
  }

  List<CalendarTraining> _replaceAtList(
    List<CalendarTraining> list,
    String searchedId,
    CalendarTraining newValue,
  ) {
    int index = list.indexWhere((element) => element.id == searchedId);
    if (index >= 0) list[index] = newValue;
    return list;
  }

  void deleteIncorrectDates(DateTime fromDate) {
    bool isCorrectDate(CalendarTraining training, int offset) {
      final dateTime = fromDate.add(Duration(days: offset));
      final expectedDate =
          DateTime(dateTime.year, dateTime.month, dateTime.day);
      final givenDate =
          DateTime(training.date.year, training.date.month, training.date.day);
      return expectedDate.difference(givenDate).inDays != 0;
    }

    day0.removeWhere((e) => isCorrectDate(e, 0));
    day1.removeWhere((e) => isCorrectDate(e, 1));
    day2.removeWhere((e) => isCorrectDate(e, 2));
    day3.removeWhere((e) => isCorrectDate(e, 3));
    day4.removeWhere((e) => isCorrectDate(e, 4));
    day5.removeWhere((e) => isCorrectDate(e, 5));
    day6.removeWhere((e) => isCorrectDate(e, 6));
  }

  static WeekCalendar ofCalendarTrainingList(List<CalendarTraining> calendar) {
    final now = DateTime.now();
    final List<List<CalendarTraining>> sortedCalendar = [];

    for (int i = 0; i <= 6; i++) {
      final trainings = calendar
          .where(
              (element) => element.date.isSameDate(now.add(Duration(days: i))))
          .toList();
      sortedCalendar.add(trainings);
    }

    return WeekCalendar(
        day0: sortedCalendar[0],
        day1: sortedCalendar[1],
        day2: sortedCalendar[2],
        day3: sortedCalendar[3],
        day4: sortedCalendar[4],
        day5: sortedCalendar[5],
        day6: sortedCalendar[6]);
  }

  List<CalendarTraining> combined() {
    return [day0, day1, day2, day3, day4, day5, day6]
        .expand((element) => element)
        .toList();
  }

  List<CalendarTraining> atIndex(int index) {
    switch (index) {
      case 0:
        return day0;
      case 1:
        return day1;
      case 2:
        return day2;
      case 3:
        return day3;
      case 4:
        return day4;
      case 5:
        return day5;
      case 6:
        return day6;
      default:
        throw IndexError.withLength(index, 7);
    }
  }
}
