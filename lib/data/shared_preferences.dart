import 'package:shared_preferences/shared_preferences.dart';
import 'package:trainit/data/datasource.dart';

class KeyValueStorage extends LocalDataSource {
  SharedPreferences? preferences;
  String get theme {
    return preferences?.getString("theme") ?? "system";
  }

  set theme(String value) {
    preferences?.setString("theme", value);
  }

  String get tutorialStatus {
    return preferences?.getString("tutorialStatus") ?? "u";
  }

  set tutorialStatus(String value) {
    preferences?.setString("tutorialStatus", value);
  }

  KeyValueStorage._create() {
    SharedPreferences.getInstance().then((value) {
      preferences = value;
    });
  }

  KeyValueStorage._createWithGiven(SharedPreferences prefs) {
    preferences = prefs;
  }

  static KeyValueStorage? _instance;

  static KeyValueStorage get instance {
    _instance ??= KeyValueStorage._create();
    return _instance!;
  }

  static Future<KeyValueStorage> getInstance() async {
    return KeyValueStorage._createWithGiven(
        await SharedPreferences.getInstance());
  }

  @override
  Future<void> deleteAll() async {
    await preferences?.clear();
  }
}
