import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:trainit/app.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:trainit/data/model/dto/error.dart';

class ErrorBuilder extends StatefulWidget {
  final Widget Function(
      BuildContext context, Function(DataSourceError e) onError) builder;
  const ErrorBuilder({super.key, required this.builder});

  @override
  State<ErrorBuilder> createState() => _ErrorBuilderState();
}

class _ErrorBuilderState extends State<ErrorBuilder> {
  List<String> snackBarTexts = [];

  void _handleError(DataSourceError e) {
    var type = e.type;
    if (e.type == ErrorType.unknown && e.data != null) {
      if (e.data is FirebaseAuthException) {
        type = ErrorType.authentication;
      } else if (e is SocketException) {
        type = ErrorType.socket;
      } else if (e is TimeoutException) {
        type = ErrorType.timeout;
      }
    }
    if (snackbarKey.currentContext == null) return;
    var text =
        AppLocalizations.of(snackbarKey.currentContext!)!.error_no_connection;
    var duration = const Duration(milliseconds: 4000);

    switch (type) {
      case ErrorType.responseCode:
        text = AppLocalizations.of(snackbarKey.currentContext!)!.error_general;
        break;
      case ErrorType.timeout:
      case ErrorType.socket:
        text = AppLocalizations.of(snackbarKey.currentContext!)!
            .error_no_connection;
        break;
      case ErrorType.unknown:
        text = AppLocalizations.of(snackbarKey.currentContext!)!
            .error_authentication_internal;
        break;
      case ErrorType.authentication:
        if (e.data != null && e.data is String) {
          text =
              AppLocalizations.of(snackbarKey.currentContext!)!.error_general;
          break;
        }
        var error = e.data as FirebaseAuthException;

        if (error.code == "network-request-failed") {
          text = AppLocalizations.of(snackbarKey.currentContext!)!
              .error_no_connection;
        } else if (error.code == "user-disabled") {
          text = AppLocalizations.of(snackbarKey.currentContext!)!
              .error_authentication_disabled;
          duration = const Duration(milliseconds: 8000);
        } else {
          text = AppLocalizations.of(snackbarKey.currentContext!)!
              .error_authentication_internal;
        }
    }

    setState(() {
      if (!snackBarTexts.contains(text)) {
        snackbarKey.currentState
            ?.showSnackBar(SnackBar(
              content: Text(text),
              duration: duration,
            ))
            .closed
            .then((value) => snackBarTexts = snackBarTexts..remove(text));
        snackBarTexts = snackBarTexts..add(text);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _handleError);
  }
}
