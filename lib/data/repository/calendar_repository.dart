import 'package:trainit/data/data_provider/local_calendar_provider.dart';
import 'package:trainit/data/data_provider/remote_authentication_provider.dart';
import 'package:trainit/data/data_provider/remote_calendar_provider.dart';
import 'package:trainit/data/model/calendar.dart';

class CalendarRepository {
  final LocalCalendarProvider _localProvider;
  final RemoteCalendarProvider _remoteProvider;
  final RemoteAuthenticationProvider _authProvider;

  CalendarRepository({
    RemoteAuthenticationProvider? authProvider,
    RemoteCalendarProvider? remoteProvider,
    LocalCalendarProvider? localProvider,
  })  : _authProvider = authProvider ?? RemoteAuthenticationProvider(),
        _localProvider = localProvider ?? LocalCalendarProvider(),
        _remoteProvider = remoteProvider ?? RemoteCalendarProvider();

  Future<WeekCalendar?> readLocal() async {
    return await _localProvider.read();
  }

  Future<void> writeLocal(WeekCalendar calendar) async {
    return await _localProvider.write(calendar);
  }

  Future<bool> uploadLocalCalendarToRemote() async {
    final calendar = await readLocal();
    if (calendar == null) {
      return false;
    }
    final authToken = await _authProvider.getUserToken();
    if (authToken == null) return false;

    final result = await _remoteProvider.uploadCalendar(
      calendar: calendar,
      authToken: authToken,
    );
    return result.success;
  }
}
