import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:trainit/presentation/shared/export/validators.dart';

class SecondsInput extends StatelessWidget {
  final int initialValue;
  final Function(String) onChanged;
  final Function(String?) onSaved;

  const SecondsInput({
    super.key,
    required this.initialValue,
    required this.onChanged,
    required this.onSaved,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: ValueKey(initialValue),
      initialValue: initialValue.toString(),
      keyboardType: const TextInputType.numberWithOptions(),
      decoration: InputDecoration(
        fillColor: Theme.of(context).colorScheme.surface,
        filled: true,
        border: const UnderlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide.none,
        ),
        suffix: Text(
          AppLocalizations.of(context)!.seconds,
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: Theme.of(context).colorScheme.onSurface),
        ),
      ),
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
      ],
      onChanged: onChanged,
      onSaved: onSaved,
      validator: (v) => Validators.validateDuration(v, context),
    );
  }
}
