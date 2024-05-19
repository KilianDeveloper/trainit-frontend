import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trainit/data/model/personal_record_type.dart';
import 'package:trainit/presentation/shared/export/strings.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:trainit/presentation/shared/export/validation_error_card.dart';
import 'package:trainit/presentation/shared/export/validators.dart';

class PersonalRecordForm extends StatefulWidget {
  final String? name;
  final Unit? unit;
  final double? value;

  final void Function(String, double, Unit) onCreateClick;
  const PersonalRecordForm({
    Key? key,
    this.name,
    this.unit,
    this.value,
    required this.onCreateClick,
  }) : super(key: key);

  @override
  State<PersonalRecordForm> createState() => _PersonalRecordFormState();
}

class _PersonalRecordFormState extends State<PersonalRecordForm> {
  final _formKey = GlobalKey<FormState>();
  String? name = "";
  String? value = "";
  String? error;

  Unit unit = Unit.kilograms;

  @override
  void initState() {
    unit = widget.unit ?? Unit.kilograms;
    super.initState();
  }

  void switchUnit() {
    setState(() {
      unit = unit.nextUnit();
    });
  }

  void _switchType() {
    setState(() {
      unit = unit.nextType();
    });
  }

  set errorText(String? value) {
    setState(() {
      error = value;
    });
  }

  String _toValidNumberString(String input) {
    return input.replaceAll(",", ".");
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.name_label,
            style: Theme.of(context).textTheme.labelMedium,
          ),
          TextFormField(
            decoration: InputDecoration(
              filled: true,
              enabled: widget.name == null,
              fillColor: widget.name == null
                  ? Theme.of(context).colorScheme.background
                  : Colors.transparent,
              floatingLabelBehavior: FloatingLabelBehavior.never,
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(12.0),
                ),
                borderSide: BorderSide.none,
              ),
              hintText: AppLocalizations.of(context)!.name_placeholder,
              hintStyle:
                  TextStyle(color: Theme.of(context).colorScheme.onBackground),
            ),
            initialValue: widget.name ?? "",
            onSaved: (newValue) => name = newValue,
            validator: (value) =>
                errorText = Validators.validateName(value, context),
            onChanged: (value) =>
                errorText = Validators.validateName(value, context),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                flex: 4,
                child: _buildType(context),
              ),
              const Expanded(
                flex: 1,
                child: SizedBox(),
              ),
              Expanded(
                flex: 4,
                child: _buildValue(context),
              ),
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: error != null ? ValidationErrorCard(error!) : null,
          ),
          const SizedBox(
            height: 56,
          ),
          Center(
            child: FilledButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  if (name != null && value != null) {
                    widget.onCreateClick(name!,
                        double.parse(_toValidNumberString(value!)), unit);
                  }
                }
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 4, 24, 4),
                child: Text(AppLocalizations.of(context)!.save),
              ),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
        ],
      ),
    );
  }

  Column _buildType(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.type_label,
          style: Theme.of(context).textTheme.labelMedium,
        ),
        SizedBox(
          height: 60,
          width: double.infinity,
          child: FilledButton.icon(
            style: FilledButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.onSecondary,
              backgroundColor: Theme.of(context).colorScheme.secondary,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(12),
                ),
              ),
            ),
            icon: Icon(
              unit.toIcon(),
              size: 24,
            ),
            label: Text(
              EnumStringProvider.getUnitTypeName(unit, context),
              style: Theme.of(context).textTheme.titleSmall,
            ),
            onPressed: widget.name != null ? null : _switchType,
          ),
        ),
      ],
    );
  }

  Column _buildValue(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.value_label,
          style: Theme.of(context).textTheme.labelMedium,
        ),
        TextFormField(
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
            suffixIcon: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 10,
                width: 56,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.onSecondary,
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    textStyle: Theme.of(context).textTheme.labelMedium,
                    padding: const EdgeInsets.symmetric(
                      vertical: 4,
                      horizontal: 12,
                    ),
                  ),
                  onPressed: () => switchUnit(),
                  child: Text(EnumStringProvider.getUnitName(unit, context)),
                ),
              ),
            ),
          ),
          initialValue: widget.value?.toString() ?? "",
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d+[.,]?\d*$'))
          ],
          onSaved: (newValue) => value = newValue,
          onChanged: (value) => errorText =
              Validators.validatePersonalRecordValue(value, context),
          validator: (value) => errorText =
              Validators.validatePersonalRecordValue(value, context),
        ),
      ],
    );
  }
}
