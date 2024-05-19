import 'package:flutter/material.dart';
import 'package:trainit/data/model/dto/body_value_collection.dart';
import 'package:trainit/data/model/dto/goal_creation.dart';
import 'package:trainit/data/model/personal_record.dart';
import 'package:trainit/presentation/shared/export/bottom_sheet_page.dart';
import 'package:trainit/presentation/statistics/widget/goal_form.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future<GoalCreation?> showGoalSheet(
  BuildContext givenContext,
  BodyValueCollection bodyValues,
  List<PersonalRecord> personalRecords,
) async {
  return await showModalBottomSheet<GoalCreation?>(
    context: givenContext,
    useRootNavigator: true,
    isDismissible: false,
    isScrollControlled: true,
    constraints: BoxConstraints(
      maxHeight: MediaQuery.of(givenContext).size.height - 60,
    ),
    builder: (context) {
      return BottomSheetPage(
        title: AppLocalizations.of(context)!.create_goal_title,
        child: GoalForm(
          personalRecords: personalRecords,
          bodyValues: bodyValues,
          onCreateClick: (type, bodyValueType, basePersonalRecord, value) {
            Navigator.pop(
              context,
              GoalCreation(
                type: type,
                basePersonalRecord: basePersonalRecord,
                bodyValueType: bodyValueType,
                value: value,
              ),
            );
          },
        ),
      );
    },
  );
}
