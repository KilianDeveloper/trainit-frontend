import 'package:trainit/data/data_provider/provider.dart';
import 'package:trainit/data/shared_preferences.dart';

class LocalTutorialProvider extends Provider {
  final KeyValueStorage _storage;

  LocalTutorialProvider({
    KeyValueStorage? keyValueStorage,
  }) : _storage = keyValueStorage ?? KeyValueStorage.instance;

  Future<String> getTutorialStatus() async {
    return _storage.tutorialStatus;
  }

  Future<void> setTutorialStatus(String status) async {
    _storage.tutorialStatus = status;
  }
}
