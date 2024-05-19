import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:trainit/data/datasource.dart';

class FirebaseSource extends DataSource {
  static bool handleError(Object exception, StackTrace stackTrace) {
    FirebaseCrashlytics.instance
        .recordError(exception, stackTrace, reason: 'a non-fatal error');
    return true;
  }
}
