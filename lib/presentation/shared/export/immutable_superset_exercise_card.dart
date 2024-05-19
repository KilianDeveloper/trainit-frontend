import 'package:flutter/material.dart';
import 'package:trainit/data/model/exercise.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ImmutableSupersetExerciseCard extends StatelessWidget {
  final Exercise first;
  final Exercise second;
  final int startIndex;
  const ImmutableSupersetExerciseCard({
    super.key,
    required this.first,
    required this.second,
    required this.startIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.fromLTRB(0, 8, 0, 8),
      child: Column(
        children: [
          _buildExercise(
            context: context,
            exercise: first,
            index: startIndex,
          ),
          _buildDivider(context),
          _buildExercise(
            context: context,
            exercise: second,
            index: startIndex + 1,
          ),
        ],
      ),
    );
  }

  Widget _buildExercise({
    required BuildContext context,
    required Exercise exercise,
    required int index,
  }) {
    final number = index + 1;
    final sets = <Widget>[];
    for (var e in exercise.sets) {
      sets.add(
        Chip(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          label: Text(
            e.repetitions == -1
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
    return Container(
      padding: const EdgeInsets.all(20),
      width: double.infinity,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: Text(
                number.toString(),
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
    );
  }

  Widget _buildDivider(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            const SizedBox(height: 18),
            Container(
              height: 3,
              width: double.infinity,
              color: Theme.of(context).colorScheme.surface,
            ),
          ],
        ),
        Center(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Theme.of(context).colorScheme.secondaryContainer,
            ),
            padding: const EdgeInsets.only(
              left: 16,
              right: 20,
              top: 8,
              bottom: 8,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.link_rounded),
                const SizedBox(width: 8),
                Text(AppLocalizations.of(context)!.superset),
              ],
            ),
          ),
        )
      ],
    );
  }
}
