import 'package:flutter/material.dart';
import 'package:trainit/data/model/account.dart';
import 'package:trainit/data/model/calendar_training.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CalendarTrainingCard extends StatelessWidget {
  final CalendarTraining calendarTraining;
  final Account account;
  final Function() onClick;

  const CalendarTrainingCard(
      {super.key,
      required this.calendarTraining,
      required this.account,
      required this.onClick});

  @override
  Widget build(BuildContext context) {
    final duration = calendarTraining.getAverageTime(
            account.averageSetDuration, account.averageSetRestDuration) ~/
        60;
    return Card(
      color: Theme.of(context).colorScheme.background,
      margin: const EdgeInsets.fromLTRB(0, 8, 0, 8),
      child: InkWell(
        onTapDown: (_) => onClick(),
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(20),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                calendarTraining.name,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Chip(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    label: Text(
                      AppLocalizations.of(context)!
                          .exercises(calendarTraining.exercises.length),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSecondary),
                    ),
                    elevation: 6.0,
                  ),
                  const SizedBox(width: 8),
                  Chip(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    label: Text(
                      AppLocalizations.of(context)!.minutes_short(duration),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSecondary),
                    ),
                    elevation: 6.0,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
