import 'package:trainit/data/data_provider/local_trainingplan_provider.dart';
import 'package:trainit/data/data_provider/remote_authentication_provider.dart';
import 'package:trainit/data/data_provider/remote_trainingplan_provider.dart';
import 'package:trainit/data/model/dto/network_result.dart';
import 'package:trainit/data/model/training_plan.dart';

class TrainingPlanRepository {
  final LocalTrainingPlanProvider _localProvider;
  final RemoteTrainingPlanProvider _remoteProvider;
  final RemoteAuthenticationProvider _authProvider;

  TrainingPlanRepository({
    RemoteAuthenticationProvider? authProvider,
    RemoteTrainingPlanProvider? remoteProvider,
    LocalTrainingPlanProvider? localProvider,
  })  : _authProvider = authProvider ?? RemoteAuthenticationProvider(),
        _localProvider = localProvider ?? LocalTrainingPlanProvider(),
        _remoteProvider = remoteProvider ?? RemoteTrainingPlanProvider();

  Future<TrainingPlan?> readByIdLocal(String id) async {
    return await _localProvider.readBy(id: id);
  }

  Future<List<TrainingPlan>> readAllLocal() async {
    return await _localProvider.readAll();
  }

  Future<bool> writeManyLocal(List<TrainingPlan> trainingPlans) async {
    return await _localProvider.writeMany(trainingPlans);
  }

  Future<bool> writeLocal(TrainingPlan trainingPlan) async {
    return await _localProvider.write(trainingPlan);
  }

  Future<bool> writeAllLocal(List<TrainingPlan> trainingPlans) async {
    await _localProvider.removeNotContained(
      ids: trainingPlans.map((e) => e.id).toList(),
    );
    return await _localProvider.writeMany(trainingPlans);
  }

  Future<NetworkResult> updateRemoteTrainingPlan(String id) async {
    final trainingPlan = await _localProvider.readBy(id: id);
    final authToken = await _authProvider.getUserToken();
    if (authToken == null) return NetworkResult(success: false);

    if (trainingPlan == null) {
      return NetworkResult(success: false);
    }
    return await _remoteProvider.updateTrainingPlan(
      trainingPlan: trainingPlan,
      authToken: authToken,
    );
  }
}
