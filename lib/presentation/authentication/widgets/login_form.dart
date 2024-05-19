import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:trainit/presentation/authentication/widgets/email_field.dart';
import 'package:trainit/presentation/authentication/widgets/password_field.dart';
import 'package:trainit/presentation/authentication/widgets/submit_button.dart';
import 'package:trainit/presentation/shared/export/field_label.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../shared/export/svg.dart';

class LoginForm extends StatefulWidget {
  final void Function(String, String) onLoginClick;
  final void Function() onGoogleSignInClick;

  final void Function() onGoToRegisterClick;
  const LoginForm({
    Key? key,
    required this.onLoginClick,
    required this.onGoToRegisterClick,
    required this.onGoogleSignInClick,
  }) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  bool _passwordVisible = false;
  String? email = "";
  String? password = "";

  void _handleSubmitClick() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      widget.onLoginClick(email!, password!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _buildBackgroundImage(context),
        Column(
          children: [
            const Spacer(),
            Expanded(
              flex: 2,
              child: _buildForm(context),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBackgroundImage(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 24),
        Expanded(
          child: Stack(
            children: [
              const CenterSvg(path: "assets/sport.svg"),
              Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Theme.of(context).colorScheme.surface.withOpacity(0.0),
                      Theme.of(context).colorScheme.surface,
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.login_title,
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                      Text(
                        AppLocalizations.of(context)!.login_title_label,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        const Expanded(
          flex: 3,
          child: SizedBox(),
        )
      ],
    );
  }

  Widget _buildForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          FieldLabel(AppLocalizations.of(context)!.email_label),
          EmailField(
            onSave: (newValue) => email = newValue,
          ),
          const SizedBox(height: 16),
          FieldLabel(AppLocalizations.of(context)!.password_label),
          PasswordField(
            passwordVisible: _passwordVisible,
            onSave: (newValue) => password = newValue,
            togglePasswordVisible: () => setState(() {
              _passwordVisible = !_passwordVisible;
            }),
          ),
          const SizedBox(height: 56),
          SubmitButton(
            value: AppLocalizations.of(context)!.sign_in,
            onClick: _handleSubmitClick,
          ),
          const SizedBox(height: 4),
          Align(
            alignment: Alignment.topCenter,
            child: TextButton(
              onPressed: widget.onGoToRegisterClick,
              style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.primary),
              child: Text(AppLocalizations.of(context)!.go_to_register),
            ),
          ),
          Center(
            child: Column(
              children: [
                Text(
                  AppLocalizations.of(context)!.or,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 8),
                SignInButton(
                  Buttons.Google,
                  onPressed: widget.onGoogleSignInClick,
                ),
                /*
                SignInButton(
                  Buttons.Apple,
                  onPressed: () {},
                )*/ //TODO add apple sign in when joined apple developer
              ],
            ),
          ),
        ],
      ),
    );
  }
}
