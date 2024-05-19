import 'package:trainit/data/database.dart';
import 'package:trainit/data/data_provider/provider.dart';
import 'package:trainit/data/model/training_plan.dart';
import 'package:trainit/helper/logging.dart';
import 'package:trainit/objectbox.g.dart';

class LocalTrainingPlanProvider extends Provider {
  final LocalDatabase _database = LocalDatabase.instance;

  Future<TrainingPlan?> readBy({required String id}) async {
    final query =
        _database.trainingPlanBox.query(TrainingPlan_.id.equals(id)).build();

    return query.findFirstAsync();
  }

  Future<void> removeNotContained({required List<String> ids}) async {
    final list = _database.trainingPlanBox
        .getAll()
        .where((element) => !ids.contains(element.id))
        .map((e) => e.localId)
        .toList();

    final query = _database.trainingPlanBox
        .query(TrainingPlan_.localId.notOneOf(list))
        .build();

    await query.removeAsync();
  }

  Future<List<TrainingPlan>> readAll() async {
    return _database.trainingPlanBox.getAllAsync();
  }

  Future<bool> writeMany(List<TrainingPlan> trainingPlans) async {
    try {
      await _database.trainingPlanBox.putManyAsync(trainingPlans);
      return true;
    } catch (ex) {
      Loggers.appLogger.e(ex);
      return false;
    }
  }

  Future<bool> write(TrainingPlan trainingPlan) async {
    try {
      await _database.trainingPlanBox.putAsync(trainingPlan);
      return true;
    } catch (ex) {
      Loggers.appLogger.e(ex);
      return false;
    }
  }
}
