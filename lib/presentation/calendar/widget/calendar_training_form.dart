import 'package:flutter/material.dart';
import 'package:trainit/data/model/account.dart';
import 'package:trainit/data/model/calendar_training.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:trainit/presentation/shared/export/immutable_exercise_card.dart';
import 'package:trainit/presentation/shared/export/immutable_superset_exercise_card.dart';

class CalendarTrainingForm extends StatelessWidget {
  final CalendarTraining calendarTraining;
  final Account account;
  const CalendarTrainingForm(
      {super.key, required this.calendarTraining, required this.account});

  @override
  Widget build(BuildContext context) {
    return SliverList(
      key: const PageStorageKey("calendar"),
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          if (index == 0) {
            return Text(
              AppLocalizations.of(context)!
                  .exercises_label(calendarTraining.exercises.length),
              style: Theme.of(context).textTheme.labelMedium,
            );
          } else {
            final listIndex = index - 1;
            if (calendarTraining.supersetIndexes.contains(listIndex) &&
                listIndex <= calendarTraining.exercises.length - 1) {
              return ImmutableSupersetExerciseCard(
                first: calendarTraining.exercises[listIndex],
                second: calendarTraining.exercises[listIndex + 1],
                startIndex: listIndex,
              );
            } else if (calendarTraining.supersetIndexes
                    .contains(listIndex - 1) &&
                listIndex != 0) {
              return null;
            }
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: ImmutableExerciseCard(
                index: index,
                exercise: calendarTraining.exercises[listIndex],
              ),
            );
          }
        },
        childCount: calendarTraining.exercises.length + 1,
      ),
    );
  }
}
