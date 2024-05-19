import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:trainit/data/database.dart';
import 'package:trainit/data/files.dart';
import 'package:trainit/data/model/account.dart';
import 'package:trainit/data/data_provider/provider.dart';
import 'package:trainit/data/model/units.dart';
import 'package:trainit/data/shared_preferences.dart';
import 'package:trainit/helper/logging.dart';
import 'package:trainit/objectbox.g.dart';

class LocalAccountProvider extends Provider {
  final LocalDatabase _database;
  final LocalFiles _files;
  KeyValueStorage _keyValueStorage;

  LocalAccountProvider({
    LocalDatabase? database,
    LocalFiles? files,
    KeyValueStorage? keyValueStorage,
  })  : _database = database ?? LocalDatabase.instance,
        _files = files ?? LocalFiles.instance,
        _keyValueStorage = keyValueStorage ?? KeyValueStorage.instance;

  static const int _accountId = 1;
  Future<Account> readBy(
      {required String id, required String? savedState}) async {
    return Account(
      id: id,
      username: "StativJovo",
      weightUnit: WeightUnit.kg,
      isPublicProfile: true,
      trainingPlanId: "sadads",
      lastModified: DateTime.now(),
    );
  }

  Future<Account?> readAuthenticated(String userId) async {
    final query = _database.accountBox
        .query(Account_.id.equals(userId).and(Account_.localId.equals(1)))
        .build();

    final result = query.find();
    if (result.isEmpty) {
      return null;
    }
    return result.first;
  }

  Future<bool> writeAuthenticated(Account account) async {
    try {
      account.localId = _accountId;
      _database.accountBox.put(account);
      return true;
    } catch (ex) {
      Loggers.appLogger.e(ex);
      return false;
    }
  }

  Future<bool> writeProfilePhoto(Uint8List data) async {
    try {
      final file = await _files.getProfilePhotoFile();
      await file.create();
      await file.writeAsBytes(data);
      return true;
    } catch (ex) {
      Loggers.appLogger.e(ex);
      return false;
    }
  }

  Future<bool> deleteProfilePhoto() async {
    try {
      final file = await _files.getProfilePhotoFile();
      await file.delete();
      return true;
    } catch (ex) {
      Loggers.appLogger.e(ex);
      return false;
    }
  }

  Future<Uint8List?> readProfilePhoto() async {
    final file = await _files.getProfilePhotoFile();
    final exists = await file.exists();
    if (exists && await file.length() != 0) {
      return await file.readAsBytes();
    }
    return null;
  }

  Future<ThemeMode> readTheme() async {
    if (_keyValueStorage.preferences == null) {
      _keyValueStorage = await KeyValueStorage.getInstance();
    }
    final theme = _keyValueStorage.theme;
    switch (theme) {
      case "system":
        return ThemeMode.system;
      case "light":
        return ThemeMode.light;
      case "dark":
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  void writeTheme(ThemeMode theme) async {
    if (_keyValueStorage.preferences == null) {
      _keyValueStorage = await KeyValueStorage.getInstance();
    }
    switch (theme) {
      case ThemeMode.system:
        _keyValueStorage.theme = "system";
        break;
      case ThemeMode.light:
        _keyValueStorage.theme = "light";
        break;
      case ThemeMode.dark:
        _keyValueStorage.theme = "dark";
        break;
      default:
        _keyValueStorage.theme = "system";
    }
  }
}
