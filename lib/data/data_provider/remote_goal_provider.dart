import 'dart:convert';

import 'package:http/http.dart';
import 'package:trainit/data/data_provider/provider.dart';
import 'package:trainit/data/model/caching/network_request.dart';
import 'package:trainit/data/model/dto/error.dart';
import 'package:trainit/data/model/dto/finish_goal_result.dart';
import 'package:trainit/data/model/dto/update_statistics.dart';
import 'package:trainit/data/model/dto/network_result.dart';
import 'package:trainit/data/model/goal.dart';
import 'package:trainit/data/remote.dart';

class RemoteGoalProvider extends Provider {
  final Client client;
  final Remote remote = Remote.instance;
  final Function(DataSourceError e)? onError;

  RemoteGoalProvider({
    Client? client,
    this.onError,
  }) : client = client ?? Client();

  Future<NetworkResult> uploadGoals({
    required List<Goal> goals,
    required String authToken,
  }) async {
    final Response? response = await remote.execute(
      request: NetworkRequest(
        path: "/user/statistics",
        method: "put",
        body: UpdateStatistics(goals: goals),
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

  Future<FinishGoalResult> finishGoal({
    required Goal goal,
    required String authToken,
  }) async {
    final Response? response = await remote.execute(
      request: NetworkRequest(
        path: "/user/statistics/goal/finish/${goal.id}",
        method: "post",
      ),
      client: client,
      token: authToken,
      onError: onError,
    );
    if (response == null || response.statusCode != 200) {
      return FinishGoalResult(success: false);
    }
    return FinishGoalResult(
      imageBytes: response.bodyBytes,
      success: true,
    );
  }
}
