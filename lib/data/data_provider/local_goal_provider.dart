import 'package:trainit/data/data_provider/provider.dart';
import 'package:trainit/data/database.dart';
import 'package:trainit/data/model/goal.dart';
import 'package:trainit/helper/logging.dart';
import 'package:trainit/objectbox.g.dart';

class LocalGoalProvider extends Provider {
  final LocalDatabase _database = LocalDatabase.instance;

  Future<List<Goal>> read() async {
    return _database.goalBox.getAllAsync();
  }

  Future<void> add(Goal goal) async {
    await _database.goalBox.putAsync(goal);
  }

  Future<int> removeNotContained({required List<String> ids}) async {
    final list = _database.goalBox
        .getAll()
        .where((element) => !ids.contains(element.id))
        .map((e) => e.localId)
        .toList();

    final query = _database.goalBox.query(Goal_.localId.notOneOf(list)).build();

    return await query.removeAsync();
  }

  Future<int> removeAll() async {
    return await _database.goalBox.removeAllAsync();
  }

  Future<bool> writeMany(List<Goal> goals) async {
    try {
      await _database.goalBox.putManyAsync(goals);
      return true;
    } catch (ex) {
      Loggers.appLogger.e(ex);
      return false;
    }
  }
}
