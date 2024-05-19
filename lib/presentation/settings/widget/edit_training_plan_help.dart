import 'package:flutter/material.dart';
import 'package:trainit/presentation/shared/export/help_page.dart';
import 'package:trainit/presentation/shared/export/help_page_manager.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EditTrainingPlanHelp extends StatefulWidget {
  const EditTrainingPlanHelp({super.key});

  @override
  State<EditTrainingPlanHelp> createState() => _EditTrainingPlanHelpState();
}

class _EditTrainingPlanHelpState extends State<EditTrainingPlanHelp> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return HelpPageManager(title: AppLocalizations.of(context)!.help, pages: [
      HelpPage(
        name: AppLocalizations.of(context)!.edit_training_plan_help_1_title,
        content:
            AppLocalizations.of(context)!.edit_training_plan_help_1_message,
      ),
      HelpPage(
        name: AppLocalizations.of(context)!.edit_training_plan_help_2_title,
        content:
            AppLocalizations.of(context)!.edit_training_plan_help_2_message,
      ),
      HelpPage(
        name: AppLocalizations.of(context)!.edit_training_plan_help_3_title,
        content:
            AppLocalizations.of(context)!.edit_training_plan_help_3_message,
      ),
      HelpPage(
        name: AppLocalizations.of(context)!.edit_training_plan_help_4_title,
        content:
            AppLocalizations.of(context)!.edit_training_plan_help_4_message,
      ),
    ]);
  }
}
