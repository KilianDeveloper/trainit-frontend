import 'package:flutter/material.dart';
import 'package:trainit/presentation/authentication/widgets/login_form.dart';
import 'package:trainit/presentation/shared/export/page.dart';

class LoginScreen extends StatelessWidget {
  final Function() onGoToRegisterClick;
  final void Function(String, String) onLoginClick;
  final void Function() onGoogleSignInClick;

  const LoginScreen({
    super.key,
    required this.onGoToRegisterClick,
    required this.onLoginClick,
    required this.onGoogleSignInClick,
  });

  @override
  Widget build(BuildContext context) {
    return ContentPage(
      content: LoginForm(
        onLoginClick: onLoginClick,
        onGoToRegisterClick: onGoToRegisterClick,
        onGoogleSignInClick: onGoogleSignInClick,
      ),
    );
  }
}
