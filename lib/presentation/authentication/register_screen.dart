import 'package:flutter/material.dart';
import 'package:trainit/presentation/authentication/widgets/register_form.dart';
import 'package:trainit/presentation/shared/export/page.dart';

class RegisterScreen extends StatelessWidget {
  final Function() onGoToRegisterClick;
  final void Function(String, String, String) onLoginClick;

  const RegisterScreen({
    super.key,
    required this.onGoToRegisterClick,
    required this.onLoginClick,
  });

  @override
  Widget build(BuildContext context) {
    return ContentPage(
      content: RegisterForm(
        onRegisterClick: onLoginClick,
      ),
    );
  }
}
