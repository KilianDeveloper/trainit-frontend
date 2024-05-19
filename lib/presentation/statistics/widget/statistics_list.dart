import 'package:flutter/material.dart';
import 'package:trainit/data/model/account.dart';
import 'package:trainit/data/model/dto/body_value_collection.dart';
import 'package:trainit/data/model/dto/statistic_body_value_collection.dart';
import 'package:trainit/data/model/goal.dart';
import 'package:trainit/data/model/goal_type.dart';
import 'package:trainit/data/model/personal_record.dart';
import 'package:trainit/presentation/statistics/widget/body_value_card.dart';
import 'package:trainit/presentation/statistics/widget/empty_goal_list.dart';
import 'package:trainit/presentation/statistics/widget/empty_personal_records.dart';
import 'package:trainit/presentation/statistics/widget/goal_card.dart';
import 'package:trainit/presentation/statistics/widget/personal_record_card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class StatisticsList extends StatelessWidget {
  final List<PersonalRecord> personalRecords;
  final void Function(String, bool) onFavoriteUpdate;
  final Account account;
  final List<Goal> goals;
  final StatisticBodyValueCollection statisticBodyValues;
  final BodyValueCollection bodyValues;

  final Function(int) changeDuration;
  final Function(PersonalRecord) updatePersonalRecord;
  final Function(PersonalRecord) deletePersonalRecord;
  final Function() createBodyValue;
  final Function() createGoal;

  const StatisticsList({
    super.key,
    required this.personalRecords,
    required this.account,
    required this.onFavoriteUpdate,
    required this.statisticBodyValues,
    required this.bodyValues,
    required this.updatePersonalRecord,
    required this.deletePersonalRecord,
    required this.goals,
    required this.createGoal,
    required this.createBodyValue,
    required this.changeDuration,
  });

  @override
  Widget build(BuildContext context) {
    final itemCount = personalRecords.isEmpty ? 7 : personalRecords.length + 6;
    final canPersonalRecordBecomeFavorite =
        personalRecords.where((element) => element.isFavorite).length <
            PersonalRecord.maxFavoriteCount;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: ListView.builder(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
            itemBuilder: (context, index) {
              switch (index) {
                case 0:
                  return Text(
                    AppLocalizations.of(context)!.your_goals_label,
                    style: Theme.of(context).textTheme.titleSmall,
                  );
                case 1:
                  return _buildGoals(context);
                case 2:
                  return Text(
                    AppLocalizations.of(context)!.your_body_stats_label,
                    style: Theme.of(context).textTheme.titleSmall,
                  );
                case 3:
                  return _buildBodyValues(context);
                case 4:
                  return Text(
                    AppLocalizations.of(context)!.your_personal_records_label,
                    style: Theme.of(context).textTheme.titleSmall,
                  );

                default:
                  if (index == itemCount - 1) {
                    return const SizedBox(height: 100);
                  }
                  return personalRecords.isNotEmpty
                      ? _buildPersonalRecord(
                          context,
                          personalRecords,
                          index - 5,
                          canPersonalRecordBecomeFavorite,
                        )
                      : const EmptyPersonalRecordList();
              }
            },
            itemCount: itemCount,
          ),
        ),
      ],
    );
  }

  Widget _buildGoals(BuildContext context) {
    if (goals.isEmpty) {
      return Column(
        children: [
          EmptyGoalsList(onAddGoalClick: createGoal),
          const SizedBox(height: 32),
          const Divider(),
          const SizedBox(height: 8),
        ],
      );
    }
    return LayoutBuilder(builder: (context, constraints) {
      const itemSpacing = 24.0;
      final maxWidth = constraints.maxWidth;
      var itemWidth = (maxWidth - itemSpacing) / 2;
      if (itemWidth > 200 || itemWidth < 100) {
        itemWidth = 150;
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: itemSpacing,
            children: goals
                .map(
                  (goal) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: SizedBox(
                      width: itemWidth,
                      height: itemWidth,
                      child: _buildGoalCard(goal),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 16),
        ],
      );
    });
  }

  Widget _buildBodyValues(BuildContext context) {
    return Column(
      children: [
        BodyValueCard(
          value: statisticBodyValues,
          account: account,
          onCreateClick: createBodyValue,
          onDurationChange: changeDuration,
        ),
        const SizedBox(height: 16),
        const Divider(),
        const SizedBox(height: 16),
      ],
    );
  }

  GoalCard _buildGoalCard(Goal goal) {
    double? currentValue;
    if (goal.type == GoalType.bodyValue) {
      if (goal.name == "Body Weight" && bodyValues.weight.isNotEmpty) {
        currentValue = bodyValues.weight.last.value;
      } else if (goal.name == "Body Fat" && bodyValues.fat.isNotEmpty) {
        currentValue = bodyValues.fat.last.value;
      }
    } else if (goal.type == GoalType.personalRecord &&
        personalRecords.any((element) => element.name == goal.name)) {
      currentValue = personalRecords
          .firstWhere((element) => element.name == goal.name)
          .value;
    }
    return GoalCard(
      goal: goal,
      currentValue: currentValue,
    );
  }

  Widget _buildPersonalRecord(
    BuildContext context,
    List<PersonalRecord> list,
    int index,
    bool canItemBecomeFavorite,
  ) {
    return PersonalRecordCard(
      personalRecord: list[index],
      canBecomeFavorite: canItemBecomeFavorite,
      displayWeightUnit: account.weightUnit,
      onFavoriteUpdate: onFavoriteUpdate,
      onUpdateClick: () => updatePersonalRecord(list[index]),
      onDeleteClick: () => deletePersonalRecord(list[index]),
    );
  }
}
