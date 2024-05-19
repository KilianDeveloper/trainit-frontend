import 'package:trainit/data/data_provider/provider.dart';
import 'package:trainit/data/database.dart';
import 'package:trainit/data/model/calendar.dart';

class LocalCalendarProvider extends Provider {
  final LocalDatabase _database = LocalDatabase.instance;

  static const int _calendarId = 1;

  Future<WeekCalendar?> read() async {
    return await _database.calendarBox.getAsync(_calendarId);
  }

  Future<void> write(WeekCalendar calendar) async {
    calendar.localId = _calendarId;
    await _database.calendarBox.putAsync(calendar);
  }
}
