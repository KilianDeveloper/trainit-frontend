import 'package:flutter/material.dart';
import 'package:trainit/data/model/body_value_type.dart';
import 'package:trainit/data/model/dto/body_value_collection.dart';
import 'package:trainit/data/model/dto/exercise_list_value.dart';
import 'package:trainit/data/model/goal_type.dart';
import 'package:trainit/data/model/personal_record.dart';
import 'package:trainit/data/model/training_days.dart';
import 'package:trainit/data/model/units.dart';
import 'package:trainit/helper/string.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Validators {
  static String? validateTrainingDays(
      TrainingDays value, BuildContext context) {
    final List<String> wrongTrainings = [];
    for (var i = 0; i < 6; i++) {
      wrongTrainings.addAll(value
          .atIndex(i)
          .where((t) => !(t.name.isValidName &&
              !t.exercises.any((element) => !element.name.isValidName)))
          .map((e) => e.name));
    }
    if (wrongTrainings.isEmpty) return null;
    return "${AppLocalizations.of(context)!.invalid_trainings} ${wrongTrainings.join(", ")}";
  }

  static String? validateDuration(String? value, BuildContext context) {
    if (value == null || value.isEmpty) {
      return AppLocalizations.of(context)!.enter_integer;
    }
    final parsed = int.tryParse(value);
    if (parsed != null && parsed <= 0) {
      return AppLocalizations.of(context)!.enter_above_zero;
    }
    return null;
  }

  static String? validatePersonalRecordLength(
      int length, BuildContext context) {
    if (length >= 10) {
      return AppLocalizations.of(context)!.error_too_many_personal_records;
    }
    return null;
  }

  static String? validateEmail(String? value, BuildContext context) {
    return value?.isValidEmail ?? false
        ? null
        : AppLocalizations.of(context)!.enter_valid_email;
  }

  static String? validatePassword(String? value, BuildContext context) {
    return value?.isValidPassword ?? false
        ? null
        : AppLocalizations.of(context)!.password_requirements;
  }

  static String? validateUsername(String? value, BuildContext context) {
    return value?.isValidUsername ?? false
        ? null
        : AppLocalizations.of(context)!.username_requirements;
  }

  static String? validateWeightUnit(WeightUnit? value, BuildContext context) {
    return null;
  }

  static String? validateGoalType(GoalType? value, BuildContext context) {
    return null;
  }

  static String? validateBodyValue(BodyValueType? value,
      BodyValueCollection bodyValues, BuildContext context) {
    final isInvalidFat = value == BodyValueType.fat && bodyValues.fat.isEmpty;
    final isInvalidWeight =
        value == BodyValueType.weight && bodyValues.weight.isEmpty;
    if (isInvalidFat) {
      return AppLocalizations.of(context)!.error_no_body_fat_values;
    } else if (isInvalidWeight) {
      return AppLocalizations.of(context)!.error_no_body_weight_values;
    }
    return null;
  }

  static String? validateBodyValueType(
      BodyValueType? value, BuildContext context) {
    return null;
  }

  static String? validatePersonalRecordBase(
      PersonalRecord? value, BuildContext context) {
    if (value == null) {
      return AppLocalizations.of(context)!.error_no_personal_record_selected;
    }
    return null;
  }

  static String? validateTheme(ThemeMode? value, BuildContext context) {
    return null;
  }

  static String? validateExerciseList(
      ExerciseList? value, BuildContext context) {
    if (value?.exercises.any((element) => !element.name.isValidName) ?? false) {
      return "${value?.exercises.indexWhere((element) => !element.name.isValidName)}DATA${AppLocalizations.of(context)!.enter_text}";
    }
    return null;
  }

  static String? validateName(String? value, BuildContext context) {
    if (value == null || value.isEmpty) {
      return AppLocalizations.of(context)!.enter_name;
    } else if (!value.isValidName) {
      return AppLocalizations.of(context)!.value_between(1, 50);
    }
    return null;
  }

  static String? validatePersonalRecordValue(
      String? value, BuildContext context) {
    if (value == null || value.isEmpty) {
      return AppLocalizations.of(context)!.enter_text;
    } else if (double.parse(value.replaceAll(",", ".")) < 0 ||
        double.parse(value.replaceAll(",", ".")) > 100000) {
      return AppLocalizations.of(context)!.value_between(0, 100000);
    }
    return null;
  }
}
