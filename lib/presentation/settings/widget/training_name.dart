import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:trainit/presentation/shared/export/validators.dart';

class TrainingNameField extends StatelessWidget {
  final String initialValue;
  final Function(String?) onSaved;
  const TrainingNameField({
    super.key,
    required this.initialValue,
    required this.onSaved,
  });

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        AppLocalizations.of(context)!.name_label,
        style: Theme.of(context).textTheme.labelMedium,
      ),
      TextFormField(
        decoration: InputDecoration(
          filled: true,
          fillColor: Theme.of(context).colorScheme.surfaceVariant,
          floatingLabelBehavior: FloatingLabelBehavior.never,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(12.0),
            ),
            borderSide: BorderSide.none,
          ),
          hintText: AppLocalizations.of(context)!.name_placeholder,
          hintStyle: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(color: Theme.of(context).colorScheme.onSurface),
        ),
        initialValue: initialValue,
        onSaved: onSaved,
        validator: (value) => Validators.validateName(value, context),
      ),
    ]);
  }
}
