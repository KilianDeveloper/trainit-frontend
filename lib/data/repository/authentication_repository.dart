import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:trainit/data/data_provider/remote_authentication_provider.dart';
import 'package:trainit/data/model/dto/authentication_user.dart';

enum FirebaseAuthenticationResult {
  ok,
  invalidEmail,
  userDisabled,
  userNotFound,
  wrongPassword,
  emailAlreadyInUser,
  operationNotAllowed,
  weakPassword,
  stillNotVerified,
  verified,
  serverNotAvailable,
  unknown;

  static FirebaseAuthenticationResult byFirebaseAuthException(
      FirebaseAuthException e) {
    final Map<String, FirebaseAuthenticationResult> codes = {
      "invalid-email": FirebaseAuthenticationResult.invalidEmail,
      "user-disabled": FirebaseAuthenticationResult.userDisabled,
      "user-not-found": FirebaseAuthenticationResult.userNotFound,
      "wrong-password": FirebaseAuthenticationResult.wrongPassword,
      "email-already-in-use": FirebaseAuthenticationResult.emailAlreadyInUser,
      "operation-not-allowed": FirebaseAuthenticationResult.operationNotAllowed,
      "weak-password": FirebaseAuthenticationResult.weakPassword,
      "network-request-failed": FirebaseAuthenticationResult.serverNotAvailable,
    };
    return codes[e.code] ?? FirebaseAuthenticationResult.unknown;
  }

  String toUIString() {
    final Map<FirebaseAuthenticationResult, String> strings = {
      FirebaseAuthenticationResult.invalidEmail:
          "Your given Email is invalid. Try again!",
      FirebaseAuthenticationResult.userDisabled:
          "The user you tried to login with is disabled.",
      FirebaseAuthenticationResult.userNotFound:
          "The user you tried to login with was not found.",
      FirebaseAuthenticationResult.wrongPassword: "Wrong password. Try again!",
      FirebaseAuthenticationResult.emailAlreadyInUser:
          "The email you tried to register with is already in use.",
      FirebaseAuthenticationResult.operationNotAllowed:
          "Operation not allowed.",
      FirebaseAuthenticationResult.weakPassword:
          "This password is too weak. Try another one!",
      FirebaseAuthenticationResult.ok: "Sucessful authenticated.",
      FirebaseAuthenticationResult.unknown:
          "An unknown exception occured. Try again!",
      FirebaseAuthenticationResult.stillNotVerified: "Still not verified!",
      FirebaseAuthenticationResult.verified: "Verified, navigating to Home!",
      FirebaseAuthenticationResult.serverNotAvailable:
          "The connection to the server failed. Make sure to have a stable internet connection and try later again!",
    };
    return strings[this]!;
  }
}

class AuthenticationRepository {
  final RemoteAuthenticationProvider _provider;

  AuthenticationRepository({RemoteAuthenticationProvider? provider})
      : _provider = provider ?? RemoteAuthenticationProvider();

  Stream<User?> get authStateChanges => _provider.userStream;

  Future<String?> getToken({bool forceRefresh = false}) async {
    return _provider.getUserToken(forceRefresh: forceRefresh);
  }

  bool get isSignedIn => _provider.isSignedIn;
  bool get isVerified => _provider.isVerified;

  AuthenticationUser? get userData => _provider.userData;

  Future<UserCredential?> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    return await _provider.signInWithCredentials(credential);
  }

  Future<FirebaseAuthenticationResult> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      final _ = await _provider.signInWithEmailAndPassword(email, password);
      return FirebaseAuthenticationResult.ok;
    } on FirebaseAuthException catch (e) {
      return FirebaseAuthenticationResult.byFirebaseAuthException(e);
    } catch (e) {
      return FirebaseAuthenticationResult.unknown;
    }
  }

  Future<FirebaseAuthenticationResult> createUserWithEmailAndPassword(
      {required String email,
      required String password,
      required String username}) async {
    try {
      await _provider.createUserWithEmailAndPassword(email, password);
      await _provider.updateUserDisplayName(username);
      return FirebaseAuthenticationResult.ok;
    } on FirebaseAuthException catch (e) {
      return FirebaseAuthenticationResult.byFirebaseAuthException(e);
    }
  }

  Future<void> signOut() async {
    try {
      await _provider.signOut();
    } on FirebaseAuthException catch (_) {
    } on PlatformException catch (_) {}
  }

  Future<void> reloadUser() async {
    await _provider.reloadUser();
  }

  Future<void> sendVerficationMailIfSignedIn() async {
    _provider.sendEmailVerificationIfSignedIn();
  }
}
