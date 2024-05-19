import 'package:flutter/material.dart';
import 'package:trainit/presentation/authentication/widgets/email_field.dart';
import 'package:trainit/presentation/authentication/widgets/password_field.dart';
import 'package:trainit/presentation/authentication/widgets/submit_button.dart';
import 'package:trainit/presentation/authentication/widgets/username_field.dart';
import 'package:trainit/presentation/shared/export/field_label.dart';
import 'package:trainit/presentation/shared/export/svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

class RegisterForm extends StatefulWidget {
  final void Function(String, String, String) onRegisterClick;
  const RegisterForm({Key? key, required this.onRegisterClick})
      : super(key: key);

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  String? email = "";
  String? username = "";
  String? password = "";
  bool _passwordVisible = false;

  void _handleSubmitClick() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      widget.onRegisterClick(email!, username!, password!);
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
              flex: 5,
              child: _buildForm(context),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBackgroundImage(BuildContext context) {
    return KeyboardVisibilityBuilder(builder: (context, visible) {
      return Column(
        children: [
          const SizedBox(height: 24),
          Expanded(
            child: Stack(
              children: [
                const CenterSvg(path: "assets/activity_tracker.svg"),
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
                AnimatedAlign(
                  alignment: visible ? Alignment.topLeft : Alignment.bottomLeft,
                  duration: const Duration(milliseconds: 100),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.register_title,
                          style: Theme.of(context).textTheme.headlineLarge,
                        ),
                        Text(
                          AppLocalizations.of(context)!.register_title_label,
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
    });
  }

  Form _buildForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 24),
          FieldLabel(AppLocalizations.of(context)!.email_label),
          EmailField(
            onSave: (newValue) => email = newValue,
          ),
          const SizedBox(height: 16),
          FieldLabel(AppLocalizations.of(context)!.username_label),
          UsernameField(onSave: (newValue) => username = newValue),
          const SizedBox(height: 16),
          FieldLabel(AppLocalizations.of(context)!.password_label),
          PasswordField(
            passwordVisible: _passwordVisible,
            togglePasswordVisible: () => setState(() {
              _passwordVisible = !_passwordVisible;
            }),
            onSave: (newValue) => password = newValue,
          ),
          const SizedBox(height: 56),
          SubmitButton(
            value: AppLocalizations.of(context)!.create_account,
            onClick: _handleSubmitClick,
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }
}
