import 'package:trainit/data/cache.dart';
import 'package:trainit/data/data_provider/provider.dart';
import 'package:trainit/data/database.dart';
import 'package:trainit/data/files.dart';
import 'package:trainit/data/shared_preferences.dart';

class LocalDataProvider extends Provider {
  final LocalDatabase _database = LocalDatabase.instance;
  final LocalCache _cache = LocalCache.instance;
  final LocalFiles _files = LocalFiles.instance;
  final KeyValueStorage _keyValue = KeyValueStorage.instance;

  Future<void> deleteAll() async {
    await _database.deleteAll();
    await _files.deleteAll();
    await _cache.deleteAll();
    await _keyValue.deleteAll();
  }
}
