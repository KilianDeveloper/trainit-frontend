import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trainit/data/model/goal.dart';
import 'package:trainit/data/model/goal_type.dart';
import 'package:trainit/data/model/personal_record.dart';
import 'package:trainit/data/model/profile.dart';
import 'package:trainit/data/model/training.dart';
import 'package:trainit/presentation/shared/export/strings.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:trainit/presentation/social/widget/profile_training_day_card.dart';

class ProfileBody extends StatelessWidget {
  final Profile profile;
  final Function(Training) onTrainingClick;
  const ProfileBody({
    super.key,
    required this.profile,
    required this.onTrainingClick,
  });

  @override
  Widget build(BuildContext context) {
    if (profile.isPublicProfile) {
      return _buildPublicProfile(context);
    } else {
      return _buildPrivateProfile(context);
    }
  }

  Widget _buildPrivateProfile(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Icon(
            Icons.lock_rounded,
            size: 32,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          AppLocalizations.of(context)!.private_profile,
          style: Theme.of(context)
              .textTheme
              .titleSmall
              ?.copyWith(color: Theme.of(context).colorScheme.primary),
        ),
      ],
    );
  }

  Widget _buildPublicProfile(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ..._buildGoal(context),
        const Divider(),
        const SizedBox(height: 8),
        ..._buildPersonalRecords(context),
        const Divider(),
        const SizedBox(height: 8),
        ..._buildTrainingPlan(context),
        const SizedBox(height: 40),
      ],
    );
  }

  List<Widget> _buildGoal(BuildContext context) {
    Goal? goal;
    final filteredGoals =
        profile.goals?.where((element) => element.isDone == false) ?? [];
    if (filteredGoals.isNotEmpty) {
      goal = filteredGoals.first;
    }

    if (goal != null) {
      final isIncreasing = goal.to > goal.from;
      IconData icon = Icons.emoji_events_rounded;
      if (goal.type == GoalType.bodyValue) {
        icon = isIncreasing ? Icons.trending_up : Icons.trending_down;
      }
      return [
        Text(AppLocalizations.of(context)!.goal),
        const SizedBox(width: double.infinity),
        Card(
          margin: const EdgeInsets.fromLTRB(0, 4, 0, 8),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 36,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isIncreasing
                          ? AppLocalizations.of(context)!
                              .increase_value(goal.name ?? "unknown")
                          : AppLocalizations.of(context)!
                              .decrease_value(goal.name ?? "unknown"),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(AppLocalizations.of(context)!.started_at(
                        DateFormat("dd.MM.yyyy").format(goal.createdOn)))
                  ],
                ),
                const SizedBox(width: 20),
              ],
            ),
          ),
        ),
      ];
    } else {
      return [
        Text(AppLocalizations.of(context)!.goal),
        const SizedBox(width: double.infinity),
      ];
    }
  }

  List<Widget> _buildPersonalRecords(BuildContext context) {
    final personalRecordWidgets = profile.personalRecords
            ?.map((e) => _buildPersonalRecord(context, e))
            .expand((element) => [element, const SizedBox(width: 16)])
            .toList() ??
        [];
    return [
      Text(AppLocalizations.of(context)!.featured_personal_records),
      const SizedBox(
        width: double.infinity,
        height: 4,
      ),
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: personalRecordWidgets,
        ),
      )
    ];
  }

  Widget _buildPersonalRecord(
      BuildContext context, PersonalRecord personalRecord) {
    return Card(
      margin: const EdgeInsets.fromLTRB(0, 8, 0, 8),
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 20, 40, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${personalRecord.value} ${EnumStringProvider.getUnitName(personalRecord.unit, context)}",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.primary),
            ),
            const SizedBox(height: 8),
            Text(
              personalRecord.name,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(DateFormat("dd.MM.yyyy").format(personalRecord.date))
          ],
        ),
      ),
    );
  }

  List<Widget> _buildTrainingPlan(BuildContext context) {
    return [
      Text(AppLocalizations.of(context)!.training_plan_label),
      const SizedBox(
        width: double.infinity,
        height: 4,
      ),
      if (profile.trainingPlan != null)
        Card(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 20, 4, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  profile.trainingPlan!.name,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                if (profile.trainingPlan!.days.count > 0)
                  SizedBox(
                    height: 140,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      separatorBuilder: (context, index) => SizedBox(
                          width: profile.trainingPlan!.days.isIndexActive(index)
                              ? 20
                              : 0),
                      itemBuilder: (context, index) => ProfileTrainingDayCard(
                        trainingPlan: profile.trainingPlan!,
                        index: index,
                        onClick: onTrainingClick,
                      ),
                      itemCount: 7,
                    ),
                  )
                else
                  Text(AppLocalizations.of(context)!.empty_training_plan)
              ],
            ),
          ),
        ),
    ];
  }
}
