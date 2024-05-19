import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:trainit/data/authentication.dart';
import 'package:trainit/data/data_provider/provider.dart';
import 'package:trainit/data/model/dto/authentication_user.dart';
import 'package:trainit/data/model/dto/error.dart';

class RemoteAuthenticationProvider extends Provider {
  final Authentication _authentication;

  final Function(DataSourceError e)? onError;

  RemoteAuthenticationProvider({
    this.onError,
    Authentication? authentication,
  }) : _authentication = authentication ?? Authentication.instance;

  AuthenticationUser? get userData {
    final user = _authentication.currentUser;
    final mockUser = user != null
        ? AuthenticationUser(
            id: user.uid, email: user.email, displayName: user.displayName)
        : null;

    return mockUser;
  }

  Future<String?> getUserToken({bool forceRefresh = true}) async {
    try {
      final token = await _authentication.currentUser?.getIdToken(forceRefresh);
      if (token == null) {
        if (onError != null) {
          onError!(DataSourceError(
              type: ErrorType.authentication, data: "token null"));
        }
        return null;
      }
      return token;
    } catch (e) {
      if (onError != null) {
        onError!(DataSourceError(type: ErrorType.unknown, data: e));
      }
      return null;
    }
  }

  String? get userId {
    final userId = _authentication.currentUser?.uid;
    if (userId == null) {
      if (onError != null) {
        onError!(DataSourceError(
            type: ErrorType.authentication, data: "userId is Null"));
      }
    }
    return userId;
  }

  Future<void> reloadUser() async {
    await _authentication.currentUser?.reload();
  }

  bool get isSignedIn => _authentication.currentUser != null;
  bool get isVerified => _authentication.currentUser?.emailVerified ?? false;

  Stream<User?> get userStream => _authentication.auth!.authStateChanges();

  Future<void> updateUserDisplayName(String displayName) async {
    await _authentication.currentUser?.updateDisplayName(displayName);
  }

  Future<void> createUserWithEmailAndPassword(
      String email, String password) async {
    await _authentication.auth?.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signInWithEmailAndPassword(
          String email, String password) async =>
      await _authentication.auth?.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

  Future<UserCredential> signInWithCredentials(
          AuthCredential credential) async =>
      FirebaseAuth.instance.signInWithCredential(credential);

  Future<void> signOut() async {
    await _authentication.auth?.signOut();
  }

  Future<void> sendEmailVerificationIfSignedIn() async {
    try {
      await _authentication.currentUser?.sendEmailVerification();
      await _authentication.currentUser?.reload();
    } on FirebaseAuthException catch (_) {
    } on PlatformException catch (_) {}
  }
}
