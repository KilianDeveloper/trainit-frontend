import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trainit/data/model/body_value_type.dart';
import 'package:trainit/data/model/dto/body_value_collection.dart';
import 'package:trainit/data/model/personal_record_type.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:trainit/helper/date.dart';
import 'package:trainit/presentation/shared/export/form_components.dart';
import 'package:trainit/presentation/shared/export/strings.dart';
import 'package:trainit/presentation/shared/export/validation_error_card.dart';
import 'package:trainit/presentation/shared/export/validators.dart';

class BodyValueForm extends StatefulWidget {
  final BodyValueType? type;
  final double? value;
  final Unit? unit;
  final BodyValueCollection bodyValues;

  final void Function(BodyValueType, double) onCreateClick;
  const BodyValueForm({
    Key? key,
    this.type,
    this.value,
    this.unit,
    required this.bodyValues,
    required this.onCreateClick,
  }) : super(key: key);

  @override
  State<BodyValueForm> createState() => _BodyValueFormState();
}

class _BodyValueFormState extends State<BodyValueForm> {
  final _formKey = GlobalKey<FormState>();
  BodyValueType? type = BodyValueType.weight;
  String? value = "";
  String? error;
  bool newWeightValueAllowed = true;
  bool newFatValueAllowed = true;

  Unit unit = Unit.kilograms;

  @override
  void initState() {
    unit = widget.unit ?? Unit.kilograms;
    type = widget.type ?? BodyValueType.weight;
    newFatValueAllowed =
        !widget.bodyValues.fat.any((e) => e.date.isSameDate(DateTime.now()));
    newWeightValueAllowed =
        !widget.bodyValues.weight.any((e) => e.date.isSameDate(DateTime.now()));

    super.initState();
  }

  void switchUnit() {
    setState(() {
      unit = unit.nextUnit();
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

  void _onSaveClick() {
    errorText = null;
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      var v = double.parse(_toValidNumberString(value!));
      if (type == BodyValueType.weight) {
        final newValue = UnitHelpers.valueToUnit(v, unit, Unit.kilograms);
        if (newValue == null) return;
        v = newValue;
      }

      if (value != null) widget.onCreateClick(type!, v);
    }
  }

  bool isValidBodyValue(BodyValueType? t) {
    return (t == BodyValueType.weight && newWeightValueAllowed) ||
        (t == BodyValueType.fat && newFatValueAllowed);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context)!.value_name_label,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const Spacer(),
              Expanded(flex: 3, child: _buildBodyValueType(context)),
            ],
          ),
          const SizedBox(height: 16),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: error != null ? ValidationErrorCard(error!) : null,
          ),
          FormItem(
            title: AppLocalizations.of(context)!.value_label,
            content: Expanded(child: _buildValue(context)),
          ),
          const SizedBox(height: 56),
          Center(
            child: FilledButton(
              onPressed: isValidBodyValue(type) ? _onSaveClick : null,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 4, 24, 4),
                child: Text(AppLocalizations.of(context)!.save),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildBodyValueType(BuildContext context) {
    return DropdownButtonFormField(
      value: type,
      decoration: InputDecoration(
        fillColor: Theme.of(context).colorScheme.background,
        filled: true,
        errorMaxLines: 1,
        errorText: '',
        errorStyle: const TextStyle(
          color: Colors.transparent,
          fontSize: 0,
        ),
        border: const UnderlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            borderSide: BorderSide.none),
      ),
      style: Theme.of(context).textTheme.bodyLarge,
      isExpanded: true,
      itemHeight: 50,
      borderRadius: const BorderRadius.all(Radius.circular(16)),
      onChanged: (value) {
        setState(() {
          if (value == BodyValueType.fat) {
            unit = Unit.percent;
          } else if (value == BodyValueType.weight) {
            unit = Unit.kilograms;
          }
          type = value!;
        });
      },
      onSaved: (value) {
        setState(() => type = value!);
      },
      validator: (value) {
        final error = Validators.validateBodyValueType(value, context);
        errorText = error ?? this.error;
        return error;
      },
      items: BodyValueType.values.map((BodyValueType val) {
        return DropdownMenuItem(
          enabled: isValidBodyValue(val),
          value: val,
          child: Text(
            EnumStringProvider.getBodyValueTypeName(val, context),
            style: TextStyle(
                color: Theme.of(context)
                    .colorScheme
                    .onBackground
                    .withAlpha(isValidBodyValue(val) ? 255 : 100)),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildValue(BuildContext context) {
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
        suffixIcon: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            height: 10,
            width: 52,
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
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d+[.,]?\d*$'))
      ],
      onSaved: (newValue) => value = newValue,
      onChanged: (value) {
        errorText = Validators.validatePersonalRecordValue(value, context);
        this.value = value;
      },
      validator: (value) {
        final error = Validators.validatePersonalRecordValue(value, context);
        errorText = error ?? this.error;
        return error;
      },
    );
  }
}
