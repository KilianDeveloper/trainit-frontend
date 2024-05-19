import 'dart:async';
import 'dart:io';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:http/http.dart';
import 'package:trainit/data/cache.dart';
import 'package:trainit/data/datasource.dart';
import 'package:trainit/data/model/caching/network_request.dart' as network;
import 'package:trainit/data/model/dto/error.dart';
import 'package:trainit/helper/logging.dart';
import 'package:trainit/main.dart';

class Remote extends DataSource {
  static get timeoutDuration {
    return const Duration(seconds: 10);
  }

  static get url {
    if (isDebug) {
      return Platform.isIOS ? "localhost:8080" : "10.0.2.2:8080";
    } else {
      return "2189f9c.online-server.cloud:80";
    }
  }

  void executeCache(String token, Function(DataSourceError e)? onError) async {
    final requestList = await LocalCache.instance.getUndoneRequests();
    final stillUndoneRequests = requestList
        .where((element) =>
            execute(
              request: element,
              client: Client(),
              token: token,
              onError: onError,
            ) ==
            null)
        .toList();
    LocalCache.instance.setUndoneRequests(stillUndoneRequests);
  }

  dynamic execute({
    required network.BaseRequest request,
    required Client client,
    required String token,
    List<int> unnormalValidResponseCodes = const [],
    bool cacheIfFailed = true,
    bool showErrorMessage = true,
    Function(DataSourceError e)? onError,
  }) async {
    try {
      final req = await request.generateRequest(client, token);
      if (req is Response) {
        final response = req;
        if ((response.statusCode ~/ 100) == 2 ||
            unnormalValidResponseCodes.contains(response.statusCode)) {
          return response;
        } else {
          _logError(
            request.path,
            response.statusCode.toString(),
            response.reasonPhrase,
          );
          if (onError != null && showErrorMessage) {
            onError(
                DataSourceError(type: ErrorType.responseCode, data: response));
          }
          return null;
        }
      } else if (req is MultipartRequest) {
        final response = await req.send().timeout(timeoutDuration);
        if ((response.statusCode ~/ 100) == 2 ||
            unnormalValidResponseCodes.contains(response.statusCode)) {
          return response;
        } else {
          if (onError != null && showErrorMessage) {
            onError(
                DataSourceError(type: ErrorType.responseCode, data: response));
          }

          _logError(
            request.path,
            response.statusCode.toString(),
            response.reasonPhrase,
          );
          return null;
        }
      } else {
        return null;
      }
    } on TimeoutException catch (e) {
      if (cacheIfFailed) LocalCache.instance.addUndoneRequest(request);
      Loggers.appLogger.i("Network: Timeout");
      if (onError != null && showErrorMessage) {
        onError(DataSourceError(type: ErrorType.timeout, data: e));
      }

      return null;
    } on SocketException catch (e) {
      if (cacheIfFailed) LocalCache.instance.addUndoneRequest(request);
      Loggers.appLogger.i("Network: ${e.message} on ${e.address?.address}");
      if (onError != null && showErrorMessage) {
        onError(DataSourceError(type: ErrorType.socket, data: e));
      }

      return null;
    }
  }

  void _logError(String path, String? statusCode, String? reasonPhrase) {
    try {
      final text = "Network Error: $path $statusCode, $reasonPhrase";
      FirebaseCrashlytics.instance.log(text);
      Loggers.appLogger.i(text);
    } catch (e) {/**/}
  }

  Remote._create();
  static Remote? _instance;

  static Remote get instance {
    _instance ??= Remote._create();
    return _instance!;
  }

  static void recreateInstance() {
    _instance ??= Remote._create();
  }
}
