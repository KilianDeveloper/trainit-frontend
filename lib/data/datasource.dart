abstract class DataSource {}

abstract class LocalDataSource extends DataSource {
  Future<void> deleteAll();
}
