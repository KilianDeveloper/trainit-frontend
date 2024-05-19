import 'package:flutter/material.dart';
import 'package:trainit/data/model/exercise.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ImmutableExerciseCard extends StatelessWidget {
  final Exercise exercise;
  final int index;
  const ImmutableExerciseCard(
      {super.key, required this.exercise, required this.index});

  @override
  Widget build(BuildContext context) {
    final sets = <Widget>[];
    for (var e in exercise.sets) {
      sets.add(
        Chip(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          label: Text(
            e.isDropset
                ? AppLocalizations.of(context)!.dropset
                : e.repetitions.toString(),
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: Theme.of(context).colorScheme.onSecondary),
          ),
          elevation: 6.0,
        ),
      );
      sets.add(const SizedBox(width: 8));
    }
    return Card(
      margin: const EdgeInsets.fromLTRB(0, 8, 0, 8),
      child: Container(
        padding: const EdgeInsets.all(20),
        width: double.infinity,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: Text(
                  index.toString(),
                  style: TextStyle(
                      fontSize: 80,
                      color: Theme.of(context)
                          .colorScheme
                          .secondaryContainer
                          .withAlpha(100)),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  exercise.name,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(AppLocalizations.of(context)!.sets_label),
                const SizedBox(height: 4),
                Wrap(
                  children: sets,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
