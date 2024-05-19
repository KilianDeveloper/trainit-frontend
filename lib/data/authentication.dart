import 'package:firebase_auth/firebase_auth.dart';
import 'package:trainit/data/datasource.dart';

class Authentication extends DataSource {
  FirebaseAuth? auth;
  User? get currentUser {
    return auth?.currentUser;
  }

  Authentication._create() {
    auth = FirebaseAuth.instance;
  }

  Authentication._createWithGiven(FirebaseAuth auth) {
    auth = auth;
  }

  static Authentication? _instance;

  static Authentication get instance {
    _instance ??= Authentication._create();
    return _instance!;
  }

  static Future<Authentication> getInstance() async {
    return Authentication._createWithGiven(FirebaseAuth.instance);
  }
}
