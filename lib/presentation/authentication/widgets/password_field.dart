import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:trainit/presentation/shared/export/validators.dart';

class PasswordField extends StatelessWidget {
  final bool passwordVisible;
  final Function() togglePasswordVisible;
  final Function(String?) onSave;
  const PasswordField({
    super.key,
    required this.passwordVisible,
    required this.togglePasswordVisible,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        filled: true,
        fillColor: Theme.of(context).colorScheme.background,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(12.0),
          ),
          borderSide: BorderSide.none,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            passwordVisible ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: togglePasswordVisible,
        ),
        hintText: AppLocalizations.of(context)!.enter_password,
        hintStyle: Theme.of(context)
            .textTheme
            .titleMedium
            ?.copyWith(color: Theme.of(context).colorScheme.onSurface),
        errorMaxLines: 2,
      ),
      style: Theme.of(context)
          .textTheme
          .titleMedium
          ?.copyWith(color: Theme.of(context).colorScheme.onSurface),
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.visiblePassword,
      obscureText: !passwordVisible,
      enableSuggestions: false,
      autocorrect: false,
      onSaved: onSave,
      validator: (value) => Validators.validatePassword(value, context),
    );
  }
}
