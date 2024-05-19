import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:intl/intl.dart';
import 'package:image/image.dart';
import 'package:trainit/data/data_provider/local_account_provider.dart';
import 'package:trainit/data/data_provider/remote_authentication_provider.dart';
import 'package:trainit/data/data_provider/remote_account_provider.dart';
import 'package:trainit/data/model/account.dart';
import 'package:trainit/data/model/dto/read_account.dart';
import 'package:trainit/data/model/dto/network_result.dart';
import 'package:trainit/data/model/dto/searched_profile.dart';
import 'package:trainit/data/model/profile.dart';

class AccountRepository {
  final RemoteAuthenticationProvider _authProvider;

  final LocalAccountProvider _localProvider;
  final RemoteAccountProvider _remoteProvider;

  AccountRepository({
    RemoteAuthenticationProvider? authProvider,
    RemoteAccountProvider? remoteProvider,
    LocalAccountProvider? localProvider,
  })  : _authProvider = authProvider ?? RemoteAuthenticationProvider(),
        _localProvider = localProvider ?? LocalAccountProvider(),
        _remoteProvider = remoteProvider ?? RemoteAccountProvider();

  Future<Account?> readLocalAuthenticated() async {
    final userId = _authProvider.userId;
    if (!_authProvider.isSignedIn || userId == null) return null;
    return await _localProvider.readAuthenticated(userId);
  }

  Future<bool> writeLocalAuthenticated(Account account) async {
    if (!_authProvider.isSignedIn) return false;
    return await _localProvider.writeAuthenticated(account);
  }

  Future<ReadAccountDto> readAllRemote(DateTime? currentState) async {
    final dateString = currentState != null
        ? "${DateFormat("yyyy-MM-ddTHH:mm:ss").format(currentState)}Z"
        : null;
    final authToken = await _authProvider.getUserToken();
    if (authToken == null) return ReadAccountDto.error();
    final userId = _authProvider.userId;
    if (userId == null) return ReadAccountDto.error();

    return await _remoteProvider.readAllForSignedIn(
      savedState: dateString,
      userId: userId,
      authToken: authToken,
    );
  }

  Future<NetworkResult> updateAccount() async {
    if (!_authProvider.isSignedIn) return NetworkResult(success: false);
    final userId = _authProvider.userId;

    if (userId == null) return NetworkResult(success: false);

    final account = await _localProvider.readAuthenticated(userId);
    if (account == null) {
      return NetworkResult(success: false);
    }
    final authToken = await _authProvider.getUserToken();
    if (authToken == null) return NetworkResult(success: false);

    return await _remoteProvider.updateAccount(
      account: account,
      authToken: authToken,
    );
  }

  Future<bool> downloadProfilePhoto() async {
    if (!_authProvider.isSignedIn) return false;
    final userId = _authProvider.userId;
    final accountId = userId;
    if (accountId == null) return false;

    final photoData =
        await _remoteProvider.readProfilePhoto(accountId: accountId);
    if (photoData == null) {
      return true;
    }
    return await _localProvider.writeProfilePhoto(photoData);
  }

  Future<bool> createAccount(
    String username, {
    bool conflictValid = false,
  }) async {
    final authToken = await _authProvider.getUserToken();
    if (authToken == null) return false;

    return await _remoteProvider.createAccount(
      username: username,
      authToken: authToken,
      conflictValid: conflictValid,
    );
  }

  Future<bool> uploadProfilePhoto(Uint8List? data) async {
    final authToken = await _authProvider.getUserToken();
    if (authToken == null) return false;

    if (data == null) {
      await _remoteProvider.deleteProfilePhoto(authToken: authToken);

      await _localProvider.deleteProfilePhoto();
      return true;
    }
    var formatter = Command()..decodeImage(data);
    final baseImage = await formatter.getImage();
    if (baseImage == null) {
      return false;
    }

    if (baseImage.height > baseImage.width) {
      formatter.copyResize(width: 500);
    } else {
      formatter.copyResize(height: 500);
    }
    formatter.copyCrop(x: 0, y: 0, width: 500, height: 500);

    formatter = await formatter.execute();
    final image = await formatter.getImage();
    if (image == null) {
      return false;
    }
    final bytes = await FlutterImageCompress.compressWithList(
      encodeJpg(image),
      quality: 100,
      format: CompressFormat.webp,
    );
    await _remoteProvider.updateProfilePhoto(
      data: bytes,
      authToken: authToken,
    );
    return await _localProvider.writeProfilePhoto(bytes);
  }

  Future<Uint8List?> readLocalProfilePhoto() async {
    return _localProvider.readProfilePhoto();
  }

  Future<Uint8List?> readRemoteProfilePhoto({required String userId}) async {
    return _remoteProvider.readProfilePhoto(accountId: userId);
  }

  Future<Profile?> readRemoteProfile({required String userId}) async {
    final authToken = await _authProvider.getUserToken();
    if (authToken == null) return null;
    return _remoteProvider.readProfile(
      userId: userId,
      authToken: authToken,
    );
  }

  Future<SearchedProfile?> readRemoteProfileByEmail(
      {required String email}) async {
    final authToken = await _authProvider.getUserToken();
    if (authToken == null) return null;
    final profile = await _remoteProvider.readProfileByEmail(
      email: email,
      authToken: authToken,
    );
    if (profile == null) {
      return SearchedProfile(
        profilePhoto: null,
        profile: null,
        wasFound: false,
      );
    }

    final profilePhoto =
        await _remoteProvider.readProfilePhoto(accountId: profile.id);

    return SearchedProfile(
      profilePhoto: profilePhoto,
      profile: profile,
      wasFound: true,
    );
  }

  Future<ThemeMode> readLocalTheme() {
    return _localProvider.readTheme();
  }

  void writeLocalTheme(ThemeMode theme) {
    return _localProvider.writeTheme(theme);
  }
}
