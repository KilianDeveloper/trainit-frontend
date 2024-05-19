import 'package:flutter/material.dart';
import 'package:trainit/data/model/account.dart';
import 'package:trainit/data/model/training.dart';
import 'package:trainit/data/model/training_days.dart';
import 'package:trainit/data/model/training_plan.dart';
import 'package:trainit/presentation/settings/edit_trainingplan_help_sheet.dart';
import 'package:trainit/presentation/settings/widget/training_plan_form.dart';
import 'package:trainit/presentation/shared/export/page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EditTrainingPlanScreen extends StatelessWidget {
  final TrainingPlan trainingPlan;
  final Account account;
  final Function(Training) selectTraining;
  final Function(String, TrainingDays) save;

  const EditTrainingPlanScreen({
    super.key,
    required this.trainingPlan,
    required this.account,
    required this.selectTraining,
    required this.save,
  });

  @override
  Widget build(BuildContext context) {
    return ContentPage(
      title: AppLocalizations.of(context)!.edit_training_plan_title,
      content: TrainingPlanForm(
        trainingPlan: trainingPlan,
        account: account,
        onTrainingEditClick: selectTraining,
        onSaveClick: save,
      ),
      appBarActions: [
        IconButton(
          icon: const Icon(Icons.help_rounded),
          onPressed: () async => await showEditTrainingPlanHelpSheet(context),
        )
      ],
    );
  }
}
