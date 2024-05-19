import 'package:flutter/material.dart';
import 'package:trainit/data/model/body_value_type.dart';
import 'package:trainit/data/model/goal_type.dart';
import 'package:trainit/data/model/personal_record_type.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EnumStringProvider {
  static String getUnitName(Unit unit, BuildContext context) {
    switch (unit) {
      case Unit.seconds:
        return AppLocalizations.of(context)!.seconds;
      case Unit.minutes:
        return AppLocalizations.of(context)!.minutes;
      case Unit.meters:
        return AppLocalizations.of(context)!.meters;
      case Unit.centimeters:
        return AppLocalizations.of(context)!.centimeters;
      case Unit.pounds:
        return AppLocalizations.of(context)!.pounds;
      case Unit.kilograms:
        return AppLocalizations.of(context)!.kilograms;
      case Unit.percent:
        return AppLocalizations.of(context)!.percent;
    }
  }

  static String getGoalTypeName(GoalType type, BuildContext context) {
    switch (type) {
      case GoalType.bodyValue:
        return AppLocalizations.of(context)!.body_value;
      case GoalType.personalRecord:
        return AppLocalizations.of(context)!.personal_record;
    }
  }

  static String getBodyValueTypeName(BodyValueType type, BuildContext context) {
    switch (type) {
      case BodyValueType.fat:
        return AppLocalizations.of(context)!.body_fat;
      case BodyValueType.weight:
        return AppLocalizations.of(context)!.body_weight;
    }
  }

  static String getUnitTypeName(Unit unit, BuildContext context) {
    switch (unit) {
      case Unit.seconds:
      case Unit.minutes:
        return AppLocalizations.of(context)!.time;
      case Unit.meters:
      case Unit.centimeters:
        return AppLocalizations.of(context)!.distance;
      case Unit.percent:
        return AppLocalizations.of(context)!.other;
      default:
        return AppLocalizations.of(context)!.weight;
    }
  }
}
