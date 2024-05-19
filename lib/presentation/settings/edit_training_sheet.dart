import 'package:flutter/material.dart';
import 'package:trainit/data/model/account.dart';
import 'package:trainit/data/model/training.dart';
import 'package:trainit/presentation/settings/widget/training_form.dart';
import 'package:trainit/presentation/shared/style.dart';

Future<dynamic> showEditTrainingSheet({
  required BuildContext context,
  required Training training,
  required Account account,
}) async {
  return await showModalBottomSheet<dynamic>(
    context: context,
    useRootNavigator: true,
    isDismissible: false,
    isScrollControlled: true,
    constraints: BoxConstraints(
      maxHeight: MediaQuery.of(context).size.height - 60,
    ),
    builder: (context) {
      return Padding(
        padding: screenPadding.add(
          EdgeInsets.only(
              top: 12, bottom: MediaQuery.of(context).viewInsets.bottom),
        ),
        child: TrainingForm(
          training: training,
          account: account,
          onSave: (name, exercises) {
            Navigator.pop(
              context,
              Training(
                id: training.id,
                name: name,
                exercises: exercises.exercises,
                supersetIndexes: exercises.supersetIndexes,
              ),
            );
          },
        ),
      );
    },
  );
}
