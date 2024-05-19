import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:trainit/data/model/account.dart';
import 'package:trainit/data/data_provider/provider.dart';
import 'package:trainit/data/model/caching/network_request.dart';
import 'package:trainit/data/model/dto/error.dart';
import 'package:trainit/data/model/dto/read_account.dart';
import 'package:trainit/data/model/dto/network_result.dart';
import 'package:trainit/data/model/profile.dart';
import 'package:trainit/data/remote.dart';

class RemoteAccountProvider extends Provider {
  final Client client;
  final Remote remote = Remote.instance;
  final Function(DataSourceError e)? onError;

  RemoteAccountProvider({
    Client? client,
    this.onError,
  }) : client = client ?? Client();

  Future<Uint8List?> readProfilePhoto({
    required String accountId,
  }) async {
    final Response? response = await remote.execute(
      request: NetworkRequest(
        path: "/user/photo/$accountId/photo.webp",
        method: "get",
      ),
      client: client,
      token: "",
      cacheIfFailed: false,
      showErrorMessage: false,
      unnormalValidResponseCodes: [409, 404],
      onError: onError,
    );
    if (response == null || response.statusCode == 404) return null;

    return response.bodyBytes;
  }

  Future<ReadAccountDto> readAllForSignedIn({
    required String authToken,
    required String userId,
    required String? savedState,
  }) async {
    final Response? response = await remote.execute(
      request: NetworkRequest(
        path: "/user/",
        method: "get",
        query: {
          "savedState": savedState,
        },
      ),
      client: client,
      token: authToken,
      cacheIfFailed: false,
      onError: onError,
    );
    if (response == null) return ReadAccountDto.error();

    final body = response.body;
    final jsonBody = jsonDecode(body);
    return ReadAccountDto.fromJson(jsonBody);
  }

  Future<Profile?> readProfile({
    required String authToken,
    required String userId,
  }) async {
    final Response? response = await remote.execute(
      request: NetworkRequest(
        path: "/user/profile/$userId",
        method: "get",
      ),
      client: client,
      token: authToken,
      cacheIfFailed: false,
      unnormalValidResponseCodes: [404],
      onError: onError,
    );
    if (response == null || response.statusCode == 404) return null;

    final body = response.body;
    final jsonBody = jsonDecode(body);
    return Profile.fromJson(jsonBody);
  }

  Future<Profile?> readProfileByEmail({
    required String authToken,
    required String email,
  }) async {
    final Response? response = await remote.execute(
      request: NetworkRequest(
        path: "/user/profile/email",
        method: "get",
        query: {
          "email": email,
        },
      ),
      client: client,
      token: authToken,
      cacheIfFailed: false,
      unnormalValidResponseCodes: [404],
      onError: onError,
    );
    if (response == null || response.statusCode == 404) return null;

    final body = response.body;
    final jsonBody = jsonDecode(body);
    return Profile.fromJson(jsonBody);
  }

  Future<NetworkResult> updateAccount({
    required String authToken,
    required Account account,
  }) async {
    final Response? response = await remote.execute(
      request: NetworkRequest(
        path: "/user",
        method: "put",
        body: account,
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

  Future<bool> createAccount({
    required String username,
    required String authToken,
    bool conflictValid = false,
  }) async {
    final Response? response = await remote.execute(
      request: NetworkRequest(
        path: "/user",
        method: "post",
        query: {
          "username": username,
        },
      ),
      unnormalValidResponseCodes: [if (conflictValid) 409],
      client: client,
      token: authToken,
      onError: onError,
    );
    if (response == null || response.statusCode != 200) return false;

    return true;
  }

  Future<NetworkResult> updateProfilePhoto({
    required String authToken,
    required Uint8List data,
  }) async {
    final StreamedResponse? response = await remote.execute(
      request:
          MultipartNetworkRequest(path: "/user/photo", method: "put", body: [
        MultipartFileBody(
          fileName: "photo.webp",
          fieldName: "image",
          contentType: "image",
          contentSubtype: "webp",
          content: data,
        )
      ]),
      client: client,
      token: authToken,
      onError: onError,
    );

    if (response == null) return NetworkResult(success: false);

    final body = await Response.fromStream(response);
    final jsonBody = jsonDecode(body.body);
    return NetworkResult.fromJson(jsonBody);
  }

  Future<NetworkResult> deleteProfilePhoto({
    required String authToken,
  }) async {
    final Response? response = await remote.execute(
      request: NetworkRequest(
        path: "/user/photo",
        method: "delete",
      ),
      client: client,
      token: authToken,
      onError: onError,
    );
    if (response == null) return NetworkResult(success: true);

    return NetworkResult(success: false);
  }
}
