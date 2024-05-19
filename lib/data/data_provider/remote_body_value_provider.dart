import 'dart:convert';

import 'package:http/http.dart';
import 'package:trainit/data/data_provider/provider.dart';
import 'package:trainit/data/model/body_value.dart';
import 'package:trainit/data/model/caching/network_request.dart';
import 'package:trainit/data/model/dto/error.dart';
import 'package:trainit/data/model/dto/get_body_values_result.dart';
import 'package:trainit/data/model/dto/put_body_value.dart';
import 'package:trainit/data/model/dto/network_result.dart';
import 'package:trainit/data/remote.dart';

class RemoteBodyValueProvider extends Provider {
  final Client client;
  final Remote remote = Remote.instance;
  final Function(DataSourceError e)? onError;

  RemoteBodyValueProvider({
    Client? client,
    this.onError,
  }) : client = client ?? Client();

  Future<NetworkResult> uploadBodyValue({
    required BodyValue bodyValue,
    required String authToken,
  }) async {
    final Response? response = await remote.execute(
      request: NetworkRequest(
        path: "/user/body",
        method: "put",
        body: PutBodyValues(
          value: bodyValue,
        ),
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

  Future<GetBodyValueResult> getBodyValues({
    required String authToken,
    required int duration,
  }) async {
    final Response? response = await remote.execute(
      request: NetworkRequest(
        path: "/user/body",
        method: "get",
        query: {
          "duration": duration,
        },
      ),
      client: client,
      token: authToken,
      onError: onError,
    );
    if (response == null) {
      return GetBodyValueResult(values: null, success: false);
    }
    final body = response.body;
    final jsonBody = jsonDecode(body);
    return GetBodyValueResult.fromJson(jsonBody);
  }
}
