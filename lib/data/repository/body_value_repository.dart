import 'package:trainit/data/data_provider/local_body_value_provider.dart';
import 'package:trainit/data/data_provider/remote_authentication_provider.dart';
import 'package:trainit/data/data_provider/remote_body_value_provider.dart';
import 'package:trainit/data/model/body_value.dart';
import 'package:trainit/data/model/dto/body_value_collection.dart';

class BodyValueRepository {
  final LocalBodyValueProvider _localProvider;
  final RemoteBodyValueProvider _remoteProvider;

  final RemoteAuthenticationProvider _authProvider;

  BodyValueRepository({
    RemoteAuthenticationProvider? authProvider,
    LocalBodyValueProvider? localProvider,
    RemoteBodyValueProvider? remoteProvider,
  })  : _authProvider = authProvider ?? RemoteAuthenticationProvider(),
        _localProvider = localProvider ?? LocalBodyValueProvider(),
        _remoteProvider = remoteProvider ?? RemoteBodyValueProvider();

  Future<BodyValueCollection> readAllLocal() async {
    return _localProvider.readAll();
  }

  Future<List<BodyValue>> readBodyWeight() async {
    return _localProvider.readBodyWeight();
  }

  Future<List<BodyValue>> readBodyFat() async {
    return _localProvider.readBodyFat();
  }

  Future<void> writeAllLocal(List<BodyValue> bodyValues) async {
    await _localProvider.removeAll();
    return _localProvider.addAll(bodyValues);
  }

  Future<void> addLocal(BodyValue bodyValue) async {
    return _localProvider.add(bodyValue);
  }

  Future<bool> uploadToRemote(BodyValue bodyValue) async {
    final authToken = await _authProvider.getUserToken();
    if (authToken == null) return false;

    final result = await _remoteProvider.uploadBodyValue(
      bodyValue: bodyValue,
      authToken: authToken,
    );

    return result.success == true;
  }

  Future<BodyValueCollection?> getRemote({int duration = 8}) async {
    final authToken = await _authProvider.getUserToken();
    if (authToken == null) return null;

    final result = await _remoteProvider.getBodyValues(
      duration: duration,
      authToken: authToken,
    );
    if (result.success == true) {
      return result.values;
    } else {
      return null;
    }
  }
}
