import 'package:flutter/material.dart';
import 'package:trainit/data/model/account.dart';
import 'package:trainit/data/model/calendar_training.dart';
import 'package:trainit/helper/date.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CalendarTrainingPreviewHeader extends StatelessWidget {
  const CalendarTrainingPreviewHeader({
    super.key,
    required this.calendarTraining,
    required this.account,
  });

  final CalendarTraining calendarTraining;
  final Account account;

  @override
  Widget build(BuildContext context) {
    final duration = calendarTraining.getAverageTime(
          account.averageSetDuration,
          account.averageSetRestDuration,
        ) ~/
        60;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Chip(
            label: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Icon(
                  Icons.calendar_month_rounded,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
                const SizedBox(width: 8),
                Text(calendarTraining.date.format()),
                const SizedBox(width: 24),
                Icon(
                  Icons.timer_rounded,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
                const SizedBox(width: 8),
                Text(
                  AppLocalizations.of(context)!.minutes_long(duration),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
