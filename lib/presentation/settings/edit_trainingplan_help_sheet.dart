import 'package:flutter/material.dart';
import 'package:trainit/presentation/settings/widget/edit_training_plan_help.dart';
import 'package:trainit/presentation/shared/export/bottom_sheet_page.dart';

Future<void> showEditTrainingPlanHelpSheet(BuildContext context) async {
  return showModalBottomSheet(
    context: context,
    useRootNavigator: true,
    isDismissible: true,
    isScrollControlled: true,
    constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height - 60,
        minWidth: MediaQuery.of(context).size.width),
    builder: (context) {
      return const BottomSheetPage(
        child: EditTrainingPlanHelp(),
      );
    },
  );
}
