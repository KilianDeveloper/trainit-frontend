import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:trainit/data/datasource.dart';
import 'package:trainit/data/model/caching/network_request.dart';

class LocalCache extends LocalDataSource {
  static const String undoneRequestCacheFileName = "request_cache.json";

  Future<File> getUndoneRequestCacheFile() async {
    final dir = (await getApplicationDocumentsDirectory()).path;
    return File('$dir/$undoneRequestCacheFileName');
  }

  Future<void> addUndoneRequest(BaseRequest request) async {
    final file = await getUndoneRequestCacheFile();
    await file.create();
    var content = await file.readAsString();
    if (content.isEmpty) content = "[]";
    final array = jsonDecode(content) as List;
    array.add(jsonDecode(jsonEncode(request)));
    file.writeAsString(jsonEncode(array));
  }

  Future<void> setUndoneRequests(List<BaseRequest> requests) async {
    final file = await getUndoneRequestCacheFile();
    await file.create();
    file.writeAsString(jsonEncode(requests));
  }

  Future<List<BaseRequest>> getUndoneRequests() async {
    final file = await getUndoneRequestCacheFile();
    await file.create();
    var content = await file.readAsString();
    if (content.isEmpty) content = "[]";
    final array = jsonDecode(content) as List;

    return array.map((e) => BaseRequest.fromJson(e)).toList();
  }

  LocalCache._create();
  static LocalCache? _instance;

  static LocalCache get instance {
    _instance ??= LocalCache._create();
    return _instance!;
  }

  static void recreateInstance() {
    _instance ??= LocalCache._create();
  }

  @override
  Future<void> deleteAll() async {
    final network = await getUndoneRequestCacheFile();
    if (await network.exists()) {
      await network.delete();
    }
  }
}
