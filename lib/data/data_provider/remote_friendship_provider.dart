import 'dart:convert';

import 'package:http/http.dart';
import 'package:trainit/data/data_provider/provider.dart';
import 'package:trainit/data/model/caching/network_request.dart';
import 'package:trainit/data/model/dto/error.dart';
import 'package:trainit/data/model/dto/following_status_result.dart';
import 'package:trainit/data/remote.dart';

class RemoteFriendshipProvider extends Provider {
  final Client client;
  final Remote remote = Remote.instance;
  final Function(DataSourceError e)? onError;

  RemoteFriendshipProvider({
    Client? client,
    this.onError,
  }) : client = client ?? Client();

  Future<FollowingStatusResult> follow({
    required String userId,
    required String authToken,
  }) async {
    final Response? response = await remote.execute(
      request: NetworkRequest(
        path: "/user/friends/",
        method: "put",
        query: {
          "id": userId,
        },
      ),
      client: client,
      token: authToken,
      onError: onError,
    );
    if (response == null) {
      return FollowingStatusResult(
        success: false,
        friendship: null,
      );
    }
    final body = response.body;
    final jsonBody = jsonDecode(body);
    return FollowingStatusResult.fromJson(jsonBody);
  }

  Future<FollowingStatusResult> acceptFollow({
    required String userId,
    required String authToken,
  }) async {
    final Response? response = await remote.execute(
      request: NetworkRequest(
        path: "/user/friends/accept/",
        method: "put",
        query: {
          "id": userId,
        },
      ),
      client: client,
      token: authToken,
      onError: onError,
    );
    if (response == null) {
      return FollowingStatusResult(
        success: false,
        friendship: null,
      );
    }
    final body = response.body;
    final jsonBody = jsonDecode(body);
    return FollowingStatusResult.fromJson(jsonBody);
  }

  Future<FollowingStatusResult> unfollow({
    required String userId,
    required String authToken,
  }) async {
    final Response? response = await remote.execute(
      request: NetworkRequest(
        path: "/user/friends/",
        method: "delete",
        query: {
          "id": userId,
        },
      ),
      client: client,
      token: authToken,
      onError: onError,
    );
    if (response == null) {
      return FollowingStatusResult(
        success: false,
        friendship: null,
      );
    }
    final body = response.body;
    final jsonBody = jsonDecode(body);
    return FollowingStatusResult.fromJson(jsonBody);
  }
}
