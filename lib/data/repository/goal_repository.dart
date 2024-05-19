import 'dart:typed_data';

import 'package:trainit/data/data_provider/local_goal_provider.dart';
import 'package:trainit/data/data_provider/remote_authentication_provider.dart';
import 'package:trainit/data/data_provider/remote_goal_provider.dart';
import 'package:trainit/data/model/goal.dart';

class GoalRepository {
  final LocalGoalProvider _localProvider;
  final RemoteGoalProvider _remoteProvider;

  final RemoteAuthenticationProvider _authProvider;

  GoalRepository({
    RemoteAuthenticationProvider? authProvider,
    LocalGoalProvider? localProvider,
    RemoteGoalProvider? remoteProvider,
  })  : _authProvider = authProvider ?? RemoteAuthenticationProvider(),
        _localProvider = localProvider ?? LocalGoalProvider(),
        _remoteProvider = remoteProvider ?? RemoteGoalProvider();

  Future<List<Goal>> readAllLocal() async {
    return await _localProvider.read();
  }

  Future<void> addLocal(Goal goal) async {
    return await _localProvider.add(goal);
  }

  Future<bool> writeAllLocal(List<Goal> goals) async {
    await _localProvider.removeAll();
    return await _localProvider.writeMany(goals);
  }

  Future<bool> uploadLocalGoalsToRemote() async {
    final authToken = await _authProvider.getUserToken();
    if (authToken == null) return false;

    final localGoals = await readAllLocal();
    final result = await _remoteProvider.uploadGoals(
      goals: localGoals,
      authToken: authToken,
    );

    return result.success == true;
  }

  Future<Uint8List?> finishGoalRemote(Goal goal) async {
    final authToken = await _authProvider.getUserToken();
    if (authToken == null) return null;
    final result = await _remoteProvider.finishGoal(
      goal: goal,
      authToken: authToken,
    );

    return result.imageBytes;
  }
}
