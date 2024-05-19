import 'package:flutter/material.dart';
import 'package:trainit/data/model/account.dart';
import 'package:trainit/data/model/training.dart';
import 'package:trainit/data/model/training_days.dart';
import 'package:trainit/data/model/training_plan.dart';
import 'package:trainit/presentation/settings/widget/training_name.dart';
import 'package:trainit/presentation/settings/widget/training_plan_week_list.dart';
import 'package:trainit/presentation/shared/export/dialogs.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TrainingPlanForm extends StatefulWidget {
  final TrainingPlan trainingPlan;
  final Account account;
  final Function(Training) onTrainingEditClick;
  final Function(String, TrainingDays) onSaveClick;
  const TrainingPlanForm({
    super.key,
    required this.trainingPlan,
    required this.account,
    required this.onTrainingEditClick,
    required this.onSaveClick,
  });

  @override
  State<TrainingPlanForm> createState() => _TrainingPlanFormFormState();
}

class _TrainingPlanFormFormState extends State<TrainingPlanForm> {
  final _formKey = GlobalKey<FormState>();

  String name = "";
  TrainingDays days = const TrainingDays(
    monday: [],
    tuesday: [],
    wednesday: [],
    thursday: [],
    friday: [],
    saturday: [],
    sunday: [],
  );
  bool hasUnsavedChanges = false;
  int duration = 15;

  @override
  void initState() {
    name = widget.trainingPlan.name;
    days = widget.trainingPlan.days;

    super.initState();
  }

  void onChanged() {
    setState(() {
      hasUnsavedChanges = true;
    });
  }

  Future<bool> shouldPop() async {
    if (hasUnsavedChanges == false) return true;
    final shouldSave = await showSaveChangesDialog(context);
    if (shouldSave == null) return false;
    if (shouldSave == false) return true;

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      widget.onSaveClick(name, days);
      return true;
    } else {
      if (context.mounted) await showInvalidInputDialog(context);
      return false;
    }
  }

  void onRequestSave() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      widget.onSaveClick(name, days);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      onChanged: onChanged,
      onWillPop: shouldPop,
      child: _buildList(context),
    );
  }

  Widget _buildList(BuildContext context) {
    return Stack(
      children: [
        TrainingFormList(
          header: TrainingNameField(
            initialValue: name,
            onSaved: (newValue) {
              name = newValue ?? AppLocalizations.of(context)!.unknown;
            },
          ),
          onSaved: (value) {
            days = value!;
          },
          context: context,
          initialValue: widget.trainingPlan.days,
          account: widget.account,
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
            child: FloatingActionButton(
              onPressed: onRequestSave,
              child: const Icon(Icons.save),
            ),
          ),
        ),
      ],
    );
  }
}
