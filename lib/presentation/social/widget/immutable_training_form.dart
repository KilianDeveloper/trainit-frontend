import 'package:flutter/material.dart';
import 'package:trainit/data/model/account.dart';
import 'package:trainit/data/model/training.dart';
import 'package:trainit/presentation/shared/export/immutable_exercise_card.dart';
import 'package:trainit/presentation/shared/export/immutable_superset_exercise_card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ImmutableTrainingForm extends StatelessWidget {
  final Training training;
  final Account account;
  const ImmutableTrainingForm(
      {super.key, required this.training, required this.account});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      key: const PageStorageKey("training"),
      itemBuilder: (BuildContext context, int index) {
        if (index == 0) {
          return Text(
            AppLocalizations.of(context)!
                .exercises_label(training.exercises.length),
            style: Theme.of(context).textTheme.labelMedium,
          );
        } else {
          final listIndex = index - 1;
          if (training.supersetIndexes.contains(listIndex) &&
              listIndex <= training.exercises.length - 1) {
            return ImmutableSupersetExerciseCard(
              first: training.exercises[listIndex],
              second: training.exercises[listIndex + 1],
              startIndex: listIndex,
            );
          } else if (training.supersetIndexes.contains(listIndex - 1) &&
              listIndex != 0) {
            return null;
          }
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: ImmutableExerciseCard(
              index: index,
              exercise: training.exercises[listIndex],
            ),
          );
        }
      },
      itemCount: training.exercises.length + 1,
    );
  }
}
