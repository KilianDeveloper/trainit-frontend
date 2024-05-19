import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trainit/data/model/body_value_type.dart';
import 'package:trainit/data/model/dto/body_value_collection.dart';
import 'package:trainit/data/model/goal_type.dart';
import 'package:trainit/data/model/personal_record.dart';
import 'package:trainit/data/model/personal_record_type.dart';
import 'package:trainit/presentation/shared/export/form_components.dart';
import 'package:trainit/presentation/shared/export/strings.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:trainit/presentation/shared/export/validation_error_card.dart';
import 'package:trainit/presentation/shared/export/validators.dart';

class GoalForm extends StatefulWidget {
  final List<PersonalRecord> personalRecords;
  final BodyValueCollection bodyValues;
  final void Function(GoalType, BodyValueType?, PersonalRecord?, double)
      onCreateClick;
  const GoalForm({
    Key? key,
    required this.personalRecords,
    required this.bodyValues,
    required this.onCreateClick,
  }) : super(key: key);

  @override
  State<GoalForm> createState() => _GoalFormState();
}

class _GoalFormState extends State<GoalForm> {
  final _formKey = GlobalKey<FormState>();
  GoalType? type = GoalType.bodyValue;
  BodyValueType? bodyValueType = BodyValueType.weight;
  PersonalRecord? basePersonalRecord;

  String? value = "";
  String? error;

  Unit unit = Unit.kilograms;

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

  bool isValidForm() {
    final validPersonalRecord = type == GoalType.personalRecord &&
        basePersonalRecord != null &&
        unit == basePersonalRecord?.unit &&
        value != "";
    final validBodyValue = type == GoalType.bodyValue && value != "";
    return validBodyValue || validPersonalRecord;
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context)!.type_label,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const Spacer(),
              Expanded(
                flex: 3,
                child: SizedBox(
                  child: DropdownButtonFormField(
                    value: type,
                    decoration: InputDecoration(
                      fillColor: Theme.of(context).colorScheme.background,
                      filled: true,
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
                        type = value!;
                      });
                    },
                    onSaved: (value) {
                      setState(() => type = value!);
                    },
                    validator: (value) {
                      final error = Validators.validateGoalType(value, context);
                      errorText = error ?? this.error;
                      return error;
                    },
                    items: GoalType.values.map((GoalType val) {
                      return DropdownMenuItem(
                        value: val,
                        child: Text(
                          EnumStringProvider.getGoalTypeName(val, context),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 16),
          if (type == GoalType.bodyValue)
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
            )
          else
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocalizations.of(context)!.personal_record_label,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const Spacer(),
                Expanded(flex: 3, child: _buildBasePersonalRecord(context)),
              ],
            ),
          const SizedBox(height: 16),
          FormItem(
            title: AppLocalizations.of(context)!.value_label,
            content: Expanded(child: _buildValue(context)),
          ),
          const SizedBox(height: 16),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: error != null ? ValidationErrorCard(error!) : null,
          ),
          const SizedBox(height: 56),
          Center(
            child: FilledButton(
              onPressed: isValidForm()
                  ? () {
                      errorText = null;
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        var v = double.parse(_toValidNumberString(value!));
                        if (type == GoalType.personalRecord) {
                          final newValue = UnitHelpers.valueToUnit(
                              v, unit, basePersonalRecord!.unit);
                          if (newValue == null) return;
                          v = newValue;
                        } else if (type == GoalType.bodyValue &&
                            bodyValueType == BodyValueType.weight) {
                          final newValue =
                              UnitHelpers.valueToUnit(v, unit, Unit.kilograms);
                          if (newValue == null) return;
                          v = newValue;
                        }

                        if (value != null) {
                          widget.onCreateClick(
                            type!,
                            bodyValueType,
                            basePersonalRecord,
                            v,
                          );
                        }
                      }
                    }
                  : null,
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

  Widget _buildBasePersonalRecord(BuildContext context) {
    return DropdownButtonFormField<PersonalRecord>(
      value: basePersonalRecord,
      decoration: InputDecoration(
        fillColor: Theme.of(context).colorScheme.background,
        filled: true,
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
          if (value != null) {
            basePersonalRecord = value;
            unit = value.unit;
          }
        });
      },
      onSaved: (value) {
        setState(() => basePersonalRecord = value!);
      },
      validator: (value) {
        final error = Validators.validatePersonalRecordBase(value, context);
        errorText = error ?? this.error;
        return error;
      },
      items: widget.personalRecords.map((PersonalRecord val) {
        return DropdownMenuItem(
          value: val,
          child: Text(val.name),
        );
      }).toList()
        ..insert(
            0,
            DropdownMenuItem(
              value: null,
              child: Text(
                "-none-",
                style: TextStyle(
                    color:
                        Theme.of(context).colorScheme.onSurface.withAlpha(100)),
              ),
            )),
    );
  }

  Widget _buildBodyValueType(BuildContext context) {
    return DropdownButtonFormField(
      value: bodyValueType,
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
          bodyValueType = value!;
        });
      },
      onSaved: (value) {
        setState(() => bodyValueType = value!);
      },
      validator: (value) {
        final error =
            Validators.validateBodyValue(value, widget.bodyValues, context);
        errorText = error ?? this.error;
        return error;
      },
      items: BodyValueType.values.map((BodyValueType val) {
        return DropdownMenuItem(
          value: val,
          child: Text(EnumStringProvider.getBodyValueTypeName(val, context)),
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
