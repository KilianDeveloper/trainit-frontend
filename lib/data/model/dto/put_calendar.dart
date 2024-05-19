import 'package:trainit/data/model/calendar_training.dart';

class PutCalendar {
  final List<CalendarTraining> values;

  PutCalendar({
    required this.values,
  });

  Map<String, dynamic> toJson() {
    return {
      "arr": values.map((e) => e.toJson()).toList(),
    };
  }
}
