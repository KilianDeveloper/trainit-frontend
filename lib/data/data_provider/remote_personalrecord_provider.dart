import 'dart:convert';

import 'package:http/http.dart';
import 'package:trainit/data/data_provider/provider.dart';
import 'package:trainit/data/model/caching/network_request.dart';
import 'package:trainit/data/model/dto/error.dart';
import 'package:trainit/data/model/dto/update_statistics.dart';
import 'package:trainit/data/model/dto/network_result.dart';
import 'package:trainit/data/model/personal_record.dart';
import 'package:trainit/data/remote.dart';

class RemotePersonalRecordProvider extends Provider {
  final Client client;
  final Remote remote = Remote.instance;
  final Function(DataSourceError e)? onError;

  RemotePersonalRecordProvider({
    Client? client,
    this.onError,
  }) : client = client ?? Client();

  Future<NetworkResult> uploadPersonalRecords({
    required List<PersonalRecord> personalRecords,
    required String authToken,
  }) async {
    final Response? response = await remote.execute(
      request: NetworkRequest(
        path: "/user/statistics",
        method: "put",
        body: UpdateStatistics(personalRecords: personalRecords),
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
