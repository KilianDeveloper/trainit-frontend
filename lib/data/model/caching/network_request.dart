import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:trainit/data/remote.dart';

class MultipartFileBody {
  final String fileName;
  final String fieldName;
  final String contentType;
  final String contentSubtype;
  final Uint8List content;

  MultipartFileBody({
    required this.fileName,
    required this.fieldName,
    required this.contentType,
    required this.contentSubtype,
    required this.content,
  });

  Map toJson() {
    return {
      "fileName": fileName,
      "fieldName": fieldName,
      "contentType": contentType,
      "contentSubtype": contentSubtype,
      "content": content,
    };
  }

  factory MultipartFileBody.fromJson(Map<String, dynamic> json) {
    return MultipartFileBody(
      fileName: json["fileName"],
      fieldName: json["fieldName"],
      content: Uint8List.fromList(json["content"].cast<int>()),
      contentSubtype: json["contentSubtype"],
      contentType: json["contentType"],
    );
  }

  MultipartFile generateMultipartFile() {
    return MultipartFile.fromBytes(
      fieldName,
      content,
      filename: fileName,
      contentType: MediaType(contentType, contentSubtype),
    );
  }
}

abstract class BaseRequest {
  final String path;
  final String method;
  final dynamic body;
  final Map<String, dynamic>? query;

  const BaseRequest({
    required this.path,
    required this.method,
    this.body,
    this.query,
  });

  Map toJson() {
    return {
      "path": path,
      "method": method,
      "body": jsonEncode(body),
      "query": query,
      "type": "normal",
    };
  }

  factory BaseRequest.fromJson(Map<String, dynamic> json) {
    final type = json["type"];
    if (type as String == "multipart") {
      return MultipartNetworkRequest(
        path: json["path"],
        method: json["method"],
        body: (jsonDecode(json["body"]) as List)
            .map((e) => MultipartFileBody.fromJson(e))
            .toList(),
        query: json["query"],
      );
    } else {
      return NetworkRequest(
        path: json["path"],
        method: json["method"],
        body: jsonDecode(json["body"]) as Map,
        query: json["query"],
      );
    }
  }

  Future<dynamic> generateRequest(
    Client client,
    String token,
  );
}

class NetworkRequest extends BaseRequest {
  NetworkRequest({
    required super.path,
    required super.method,
    super.body,
    super.query,
  });

  Future<Response> _generateRequestMethod({
    required Client client,
    required Uri uri,
    Map<String, String>? headers,
    String? body,
  }) {
    switch (method.toLowerCase()) {
      case "post":
        return client.post(
          uri,
          headers: headers,
          body: body,
        );
      case "put":
        return client.put(
          uri,
          headers: headers,
          body: body,
        );
      case "delete":
        return client.delete(
          uri,
          headers: headers,
          body: body,
        );
      case "patch":
        return client.patch(
          uri,
          headers: headers,
          body: body,
        );
      default:
        return client.get(
          uri,
          headers: headers,
        );
    }
  }

  @override
  Future<dynamic> generateRequest(
    Client client,
    String token,
  ) async {
    String uriString = "https://${Remote.url}$path?";
    query?.forEach((key, value) {
      uriString += "$key=$value&";
    });
    uriString = uriString.substring(0, uriString.length - 1);
    final uri = Uri.parse(uriString);

    final headers = {
      "Authorization": "Bearer $token",
      if (body != null) "content-type": "application/json"
    };
    final request = await _generateRequestMethod(
      client: client,
      uri: uri,
      body: jsonEncode(body),
      headers: headers,
    );
    return request;
  }

  @override
  Map toJson() {
    return {
      "path": path,
      "method": method,
      "body": jsonEncode(body),
      "query": query,
      "type": "normal",
    };
  }
}

class MultipartNetworkRequest extends BaseRequest {
  MultipartNetworkRequest({
    required super.path,
    required super.method,
    super.query,
    required List<MultipartFileBody> body,
  }) : super(body: body);

  List<MultipartFileBody> getBody() {
    return body as List<MultipartFileBody>;
  }

  @override
  Future<dynamic> generateRequest(
    Client client,
    String token,
  ) async {
    final uri = Uri.https(Remote.url, path, query);
    final headers = {"Authorization": "Bearer $token"};

    final request = MultipartRequest(method.toUpperCase(), uri);

    request.headers.addAll(headers);
    body?.forEach((element) {
      request.files.add(element.generateMultipartFile());
    });

    return request;
  }

  @override
  Map toJson() {
    return {
      "path": path,
      "method": method,
      "body": jsonEncode(body),
      "query": query,
      "type": "multipart",
    };
  }
}
