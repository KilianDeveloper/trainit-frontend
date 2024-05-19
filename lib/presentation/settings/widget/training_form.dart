import 'package:flutter/material.dart';
import 'package:trainit/data/model/account.dart';
import 'package:trainit/data/model/dto/exercise_list_value.dart';
import 'package:trainit/data/model/training.dart';
import 'package:trainit/presentation/settings/widget/exercise_list.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:trainit/presentation/shared/export/bottom_sheet_indicator.dart';
import 'package:trainit/presentation/shared/export/validators.dart';

class TrainingForm extends StatefulWidget {
  final Training training;
  final Account account;
  final Function(String, ExerciseList) onSave;
  const TrainingForm({
    super.key,
    required this.training,
    required this.account,
    required this.onSave,
  });

  @override
  State<TrainingForm> createState() => TrainingFormState();

  static TrainingFormState? of(BuildContext context) =>
      context.findAncestorStateOfType<TrainingFormState>();
}

class TrainingFormState extends State<TrainingForm> {
  final _formKey = GlobalKey<FormState>();
  String? name = "";
  ExerciseList exerciseList =
      const ExerciseList(exercises: [], supersetIndexes: []);

  @override
  void initState() {
    name = widget.training.name;
    exerciseList = ExerciseList(
      exercises: widget.training.exercises,
      supersetIndexes: widget.training.supersetIndexes,
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(key: _formKey, child: _buildList(context));
  }

  Widget _buildList(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            const BottomSheetIndicator(),
            Container(
              padding: const EdgeInsets.all(12),
              width: double.infinity,
              color: Theme.of(context)
                  .bottomSheetTheme
                  .modalBackgroundColor
                  ?.withAlpha(220),
              child: Text(
                AppLocalizations.of(context)!.edit_training_title,
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
                softWrap: false,
              ),
            ),
            const SizedBox(height: 12),
            _buildFirst(context),
            const SizedBox(height: 12),
            ExerciseFormList(
              context: context,
              onSaved: (e) => exerciseList =
                  e ?? const ExerciseList(exercises: [], supersetIndexes: []),
              initialValue: exerciseList,
            ),
            const SizedBox(height: 60),
          ],
        ),
        AnimatedAlign(
          alignment: MediaQuery.of(context).viewInsets.bottom == 0
              ? Alignment.bottomCenter
              : Alignment.bottomRight,
          duration: const Duration(milliseconds: 100),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 32),
            child: FilledButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  if (name != null) {
                    widget.onSave(name!, exerciseList);
                  }
                }
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 4, 24, 4),
                child: Text(AppLocalizations.of(context)!.save),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFirst(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        AppLocalizations.of(context)!.name_label,
        style: Theme.of(context).textTheme.labelMedium,
      ),
      TextFormField(
        decoration: InputDecoration(
          filled: true,
          fillColor: Theme.of(context).colorScheme.surfaceVariant,
          floatingLabelBehavior: FloatingLabelBehavior.never,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12.0)),
            borderSide: BorderSide.none,
          ),
          hintText: AppLocalizations.of(context)!.name_placeholder,
          hintStyle: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(color: Theme.of(context).colorScheme.onSurface),
        ),
        initialValue: name,
        onSaved: (newValue) => name = newValue,
        validator: (value) => Validators.validateName(value, context),
      ),
    ]);
  }
}
