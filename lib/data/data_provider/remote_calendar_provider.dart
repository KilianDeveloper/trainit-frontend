import 'dart:convert';

import 'package:http/http.dart';
import 'package:trainit/data/data_provider/provider.dart';
import 'package:trainit/data/model/caching/network_request.dart';
import 'package:trainit/data/model/calendar.dart';
import 'package:trainit/data/model/dto/error.dart';
import 'package:trainit/data/model/dto/network_result.dart';
import 'package:trainit/data/model/dto/put_calendar.dart';
import 'package:trainit/data/remote.dart';

class RemoteCalendarProvider extends Provider {
  final Client client;
  final Remote remote = Remote.instance;
  final Function(DataSourceError e)? onError;

  RemoteCalendarProvider({
    Client? client,
    this.onError,
  }) : client = client ?? Client();

  Future<NetworkResult> uploadCalendar({
    required WeekCalendar calendar,
    required String authToken,
  }) async {
    final Response? response = await remote.execute(
      request: NetworkRequest(
        path: "/user/calendar",
        method: "put",
        body: PutCalendar(values: calendar.combined()),
      ),
      client: client,
      token: authToken,
      onError: onError,
    );
    if (response == null) return NetworkResult(success: false);

    final body = response.body;
    final jsonBody = jsonDecode(body);
    return NetworkResult.fromJson(jsonBody);
  }
}
