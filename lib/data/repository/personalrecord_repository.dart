import 'package:trainit/data/data_provider/local_personalrecord_provider.dart';
import 'package:trainit/data/data_provider/remote_authentication_provider.dart';
import 'package:trainit/data/data_provider/remote_personalrecord_provider.dart';
import 'package:trainit/data/model/personal_record.dart';

class PersonalRecordRepository {
  final LocalPersonalRecordProvider _localProvider;
  final RemotePersonalRecordProvider _remoteProvider;
  final RemoteAuthenticationProvider _authProvider;

  PersonalRecordRepository({
    RemoteAuthenticationProvider? authProvider,
    RemotePersonalRecordProvider? remoteProvider,
    LocalPersonalRecordProvider? localProvider,
  })  : _authProvider = authProvider ?? RemoteAuthenticationProvider(),
        _localProvider = localProvider ?? LocalPersonalRecordProvider(),
        _remoteProvider = remoteProvider ?? RemotePersonalRecordProvider();

  Future<List<PersonalRecord>> readAllLocal() async {
    return await _localProvider.readAll();
  }

  Future<bool> writeManyLocal(List<PersonalRecord> personalRecords) async {
    return await _localProvider.writeMany(personalRecords);
  }

  Future<bool> writeAllLocal(List<PersonalRecord> personalRecords) async {
    await _localProvider.removeNotContained(
      names: personalRecords.map((e) => e.name).toList(),
    );
    return await _localProvider.writeMany(personalRecords);
  }

  Future<bool> uploadLocalPersonalRecordsToRemote() async {
    final authToken = await _authProvider.getUserToken();
    if (authToken == null) return false;

    final localPersonalRecords = await readAllLocal();
    final result = await _remoteProvider.uploadPersonalRecords(
      personalRecords: localPersonalRecords,
      authToken: authToken,
    );

    return result.success == true;
  }
}
