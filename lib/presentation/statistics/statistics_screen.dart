import 'package:flutter/material.dart';
import 'package:trainit/data/model/account.dart';
import 'package:trainit/data/model/dto/body_value_collection.dart';
import 'package:trainit/data/model/dto/statistic_body_value_collection.dart';
import 'package:trainit/data/model/goal.dart';
import 'package:trainit/data/model/personal_record.dart';
import 'package:trainit/presentation/shared/export/expandable_fab.dart';
import 'package:trainit/presentation/shared/export/page.dart';
import 'package:trainit/presentation/shared/export/validators.dart';
import 'package:trainit/presentation/statistics/widget/statistics_help.dart';
import 'package:trainit/presentation/statistics/widget/statistics_list.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class StatisticsScreen extends StatelessWidget {
  final List<PersonalRecord> personalRecords;
  final List<Goal> goals;
  final Account account;
  final StatisticBodyValueCollection statisticBodyValues;
  final BodyValueCollection bodyValues;

  final Function(PersonalRecord?) updateOrCreatePersonalRecord;
  final Function(PersonalRecord) deletePersonalRecord;
  final Function() createGoal;
  final Function() createBodyValue;
  final Function(int) changeDuration;

  final void Function(String, bool) onFavoriteUpdate;

  const StatisticsScreen({
    Key? key,
    required this.onFavoriteUpdate,
    required this.personalRecords,
    required this.account,
    required this.goals,
    required this.updateOrCreatePersonalRecord,
    required this.deletePersonalRecord,
    required this.createGoal,
    required this.createBodyValue,
    required this.bodyValues,
    required this.statisticBodyValues,
    required this.changeDuration,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final buttonTheme = FilledButton.styleFrom(
      foregroundColor: Theme.of(context).colorScheme.onSecondary,
      backgroundColor: Theme.of(context).colorScheme.secondary,
    );
    return ContentPage(
      title: AppLocalizations.of(context)!.statistics_title,
      content: StatisticsList(
        account: account,
        createGoal: createGoal,
        goals: goals,
        bodyValues: bodyValues,
        statisticBodyValues: statisticBodyValues,
        personalRecords: personalRecords,
        onFavoriteUpdate: onFavoriteUpdate,
        updatePersonalRecord: updateOrCreatePersonalRecord,
        deletePersonalRecord: deletePersonalRecord,
        createBodyValue: createBodyValue,
        changeDuration: changeDuration,
      ),
      appBarActions: [
        IconButton(
          icon: const Icon(Icons.help_rounded),
          onPressed: () async => await showStatisticsHelp(context),
        )
      ],
      floatingActionButton: ExpandableFab(
        children: [
          FilledButton(
            onPressed: createBodyValue,
            style: buttonTheme,
            child: const Text("Add Body Value"),
          ),
          FilledButton(
            onPressed: Validators.validatePersonalRecordLength(
                        personalRecords.length, context) ==
                    null
                ? () => updateOrCreatePersonalRecord(null)
                : null,
            style: buttonTheme,
            child: const Text("Add Personal Record"),
          ),
          FilledButton(
            onPressed: goals.isEmpty ? createGoal : null,
            style: buttonTheme,
            child: const Text("Add Goal"),
          ),
        ],
      ),
    );
  }
}
