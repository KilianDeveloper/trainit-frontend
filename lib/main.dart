import 'dart:io';

import 'package:event_bus/event_bus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:trainit/app.dart';
import 'package:trainit/data/database.dart';
import 'package:trainit/data/firebase.dart';
import 'package:trainit/data/model/static_data.dart';
import 'package:trainit/data/repository/account_repository.dart';
import 'package:trainit/helper/http.dart';
import 'package:trainit/helper/logging.dart';

const isDebug = true;
const useLocalFirebaseEmulator = true;
final staticData = StaticData(
  supportMail: "sup.kiliandev@gmail.com",
  termsOfServiceLink: "https://kilian-dev.de/trainIt/terms.html",
  privacyPolicyLink: "https://kilian-dev.de/trainIt/privacy.html",
);

EventBus dataChangeBus = EventBus();

late LocalDatabase database;
late ThemeMode startTheme;

void main() async {
  if (isDebug) HttpOverrides.global = DevHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();

  PlatformDispatcher.instance.onError = FirebaseSource.handleError;

  database = LocalDatabase.instance;
  await Firebase.initializeApp();
  if (useLocalFirebaseEmulator) {
    try {
      await FirebaseAuth.instance
          .useAuthEmulator(Platform.isAndroid ? "10.0.2.2" : "localhost", 9099);
    } catch (e) {
      Loggers.firebaseLogger.w("Firebase Emulator", e);
    }
  }

  if (isDebug) {
    HttpOverrides.global = DevHttpOverrides();
  }

  startTheme = await AccountRepository().readLocalTheme();

  runApp(const App());
}
