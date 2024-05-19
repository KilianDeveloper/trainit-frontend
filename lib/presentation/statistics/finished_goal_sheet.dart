import 'package:flutter/material.dart';
import 'package:trainit/data/model/body_value.dart';
import 'package:trainit/data/model/dto/finished_goal.dart';
import 'package:trainit/presentation/shared/export/bottom_sheet_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:trainit/presentation/statistics/widget/goal_finished_widget.dart';

Future<BodyValue?> showGoalFinishedSheet(
  BuildContext givenContext,
  FinishedGoal goal,
  Function() onShareClick,
) async {
  return await showModalBottomSheet<BodyValue?>(
    context: givenContext,
    useRootNavigator: true,
    isDismissible: false,
    isScrollControlled: true,
    constraints: BoxConstraints(
      maxHeight: MediaQuery.of(givenContext).size.height - 60,
    ),
    builder: (context) {
      return BottomSheetPage(
        title: AppLocalizations.of(context)!.goal_finished_title,
        child: GoalFinishedWidget(
          goal: goal,
          onCollapseClick: () => Navigator.pop(context, null),
          onShareClick: onShareClick,
        ),
      );
    },
  );
}
