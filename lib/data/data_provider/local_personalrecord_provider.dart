import 'package:trainit/data/data_provider/provider.dart';
import 'package:trainit/data/database.dart';
import 'package:trainit/data/model/personal_record.dart';
import 'package:trainit/helper/logging.dart';
import 'package:trainit/objectbox.g.dart';

class LocalPersonalRecordProvider extends Provider {
  final LocalDatabase _database = LocalDatabase.instance;

  Future<void> removeNotContained({required List<String> names}) async {
    final list = _database.personalRecordBox
        .getAll()
        .where((element) => !names.contains(element.name))
        .map((e) => e.localId)
        .toList();

    final query = _database.personalRecordBox
        .query(PersonalRecord_.localId.notOneOf(list))
        .build();

    await query.removeAsync();
  }

  Future<List<PersonalRecord>> readAll() async {
    return _database.personalRecordBox.getAllAsync();
  }

  Future<bool> writeMany(List<PersonalRecord> personalRecords) async {
    try {
      _database.personalRecordBox.removeAll();
      _database.personalRecordBox
          .putMany(personalRecords, mode: PutMode.insert);
      return true;
    } catch (ex) {
      Loggers.appLogger.e(ex);
      return false;
    }
  }
}
