import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';
import 'package:trainit/bloc/statistics/bloc.dart';
import 'package:trainit/bloc/statistics/event.dart';
import 'package:trainit/bloc/statistics/state.dart';
import 'package:trainit/data/model/account.dart';
import 'package:trainit/data/model/dto/body_value_collection.dart';
import 'package:trainit/data/model/dto/statistic_body_value_collection.dart';
import 'package:trainit/data/model/goal.dart';
import 'package:trainit/data/model/personal_record.dart';
import 'package:trainit/presentation/statistics/add_body_value_sheet.dart';
import 'package:trainit/presentation/statistics/add_goal_sheet.dart';
import 'package:trainit/presentation/statistics/edit_personal_record_sheet.dart';
import 'package:trainit/presentation/statistics/finished_goal_sheet.dart';
import 'package:trainit/presentation/statistics/statistics_screen.dart';

GlobalKey<NavigatorState> statisticsNavigatorKey = GlobalKey<NavigatorState>();

class MainStatisticsScreen extends StatefulWidget {
  const MainStatisticsScreen({super.key});

  @override
  State<MainStatisticsScreen> createState() => _MainStatisticsScreenState();
}

class _MainStatisticsScreenState extends State<MainStatisticsScreen> {
  @override
  void initState() {
    context.read<StatisticsBloc>().add(ResetScreenStatus());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StatisticsBloc, StatisticsState>(
      listenWhen: (previous, current) =>
          current.unshownFinishedGoals.isNotEmpty &&
          current.unshownFinishedGoals != previous.unshownFinishedGoals,
      listener: (context, state) async {
        for (var goal in state.unshownFinishedGoals) {
          await showGoalFinishedSheet(context, goal, () {
            Share.shareXFiles([
              XFile.fromData(
                goal.imageBytes,
                mimeType: "image/png",
                name:
                    "goal_${goal.goal.name?.replaceAll(" ", "").toLowerCase()}.png",
              ),
            ]);
          });
        }
      },
      builder: (c, state) {
        final injectedScreens =
            state.injectedScreens.map((e) => MaterialPage(child: e()));
        return Navigator(
          key: statisticsNavigatorKey,
          pages: [
            MaterialPage(
              child: _buildStatisticsScreen(
                context,
                personalRecords: state.personalRecords,
                account: state.account,
                bodyValues: state.bodyValues,
                statisticBodyValues: state.statisticBodyValues,
                goals: state.goals,
              ),
            ),
            ...injectedScreens
          ],
          onPopPage: (route, result) {
            context.read<StatisticsBloc>().add(LeaveUpdatePersonalRecord());
            return false;
          },
        );
      },
    );
  }

  Widget _buildStatisticsScreen(
    BuildContext context, {
    required List<PersonalRecord> personalRecords,
    required List<Goal> goals,
    required StatisticBodyValueCollection statisticBodyValues,
    required BodyValueCollection bodyValues,
    required Account account,
  }) {
    return StatisticsScreen(
      bodyValues: bodyValues,
      statisticBodyValues: statisticBodyValues,
      personalRecords: personalRecords,
      account: account,
      goals: goals,
      createBodyValue: () async {
        final result = await showBodyValueSheet(context, bodyValues);
        if (result == null) {
          return;
        }
        if (context.mounted) {
          context.read<StatisticsBloc>().add(CreateBodyValue(result));
        }
      },
      createGoal: () async {
        final result = await showGoalSheet(
          context,
          bodyValues,
          personalRecords,
        );
        if (result == null) {
          return;
        }
        if (context.mounted) {
          context
              .read<StatisticsBloc>()
              .add(CreateGoal.fromDto(result, bodyValues));
        }
      },
      changeDuration: (p0) => context
          .read<StatisticsBloc>()
          .add(SetBodyValueStatisticDuration(duration: p0)),
      updateOrCreatePersonalRecord: (pr) async {
        final result = await showPersonalRecordSheet(context, pr);
        if (result == null) {
          return;
        }
        if (context.mounted) {
          context
              .read<StatisticsBloc>()
              .add(CreateOrUpdatePersonalRecord.fromDto(result));
        }
      },
      deletePersonalRecord: (pr) =>
          context.read<StatisticsBloc>().add(DeletePersonalRecord(pr)),
      onFavoriteUpdate: (name, isFavorite) {
        context.read<StatisticsBloc>().add(
              UpdatePersonalRecordFavorite(
                name: name,
                newIsFavorite: isFavorite,
              ),
            );
      },
    );
  }
}
