import 'package:trainit/data/data_provider/local_data_provider.dart';

class LocalDataRepository {
  final LocalDataProvider _provider;

  LocalDataRepository({
    LocalDataProvider? provider,
  }) : _provider = provider ?? LocalDataProvider();

  Future<void> deleteAll() async {
    return await _provider.deleteAll();
  }
}
