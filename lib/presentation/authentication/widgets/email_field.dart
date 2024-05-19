import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:trainit/presentation/shared/export/validators.dart';

class EmailField extends StatelessWidget {
  final Function(String?) onSave;
  const EmailField({
    super.key,
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
        hintText: AppLocalizations.of(context)!.enter_email,
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
      keyboardType: TextInputType.emailAddress,
      onSaved: onSave,
      validator: (value) => Validators.validateEmail(value, context),
    );
  }
}
