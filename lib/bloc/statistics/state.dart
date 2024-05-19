import 'package:flutter/material.dart';
import 'package:trainit/data/model/account.dart';
import 'package:trainit/data/model/dto/body_value_collection.dart';
import 'package:trainit/data/model/dto/finished_goal.dart';
import 'package:trainit/data/model/dto/statistic_body_value_collection.dart';
import 'package:trainit/data/model/goal.dart';
import 'package:trainit/data/model/personal_record.dart';
import 'package:trainit/data/model/units.dart';
import 'package:uuid/uuid.dart';

enum StatisticsStatus { initial, success, error, loading, update }

extension PersonalRecordStatusX on StatisticsStatus {
  bool get isInitial => this == StatisticsStatus.initial;
  bool get isSuccess => this == StatisticsStatus.success;
  bool get isError => this == StatisticsStatus.error;
  bool get isLoading => this == StatisticsStatus.loading;
  bool get isUpdateScreen => this == StatisticsStatus.update;
}

class StatisticsState {
  StatisticsState({
    this.status = StatisticsStatus.initial,
    List<PersonalRecord>? personalRecords,
    this.selected,
    this.goals = const [],
    this.unshownFinishedGoals = const [],
    this.injectedScreens = const [],
    StatisticBodyValueCollection? statisticBodyValues,
    BodyValueCollection? bodyValues,
    Account? account,
  })  : personalRecords = personalRecords ?? [],
        account = account ??
            Account(
                id: "id",
                username: "StativJovo",
                weightUnit: WeightUnit.kg,
                isPublicProfile: false,
                trainingPlanId: const Uuid().v4(),
                lastModified: DateTime.now()),
        statisticBodyValues = statisticBodyValues ??
            StatisticBodyValueCollection(
              weight: [],
              fat: [],
              xAxisValues: [],
              forDuration: -1,
              mostRecentFat: null,
              mostRecentWeight: null,
            ),
        bodyValues =
            bodyValues ?? BodyValueCollection(fatValue: [], weightValue: []);

  final List<PersonalRecord> personalRecords;
  final Account account;
  final PersonalRecord? selected;
  final StatisticsStatus status;
  final List<Goal> goals;
  final List<FinishedGoal> unshownFinishedGoals;
  final StatisticBodyValueCollection statisticBodyValues;
  final BodyValueCollection bodyValues;
  final List<Widget Function()> injectedScreens;

  List<Object?> get props => [
        personalRecords,
        account,
        status,
        selected,
        goals,
        statisticBodyValues,
        unshownFinishedGoals
      ];

  StatisticsState copyWith({
    List<PersonalRecord>? personalRecords,
    StatisticsStatus? status,
    Account? account,
    List<Goal>? goals,
    List<FinishedGoal>? unshownFinishedGoals,
    StatisticBodyValueCollection? statisticBodyValues,
    BodyValueCollection? bodyValues,
  }) {
    return StatisticsState(
      personalRecords: personalRecords ?? this.personalRecords,
      status: status ?? this.status,
      account: account ?? this.account,
      selected: selected,
      goals: goals ?? this.goals,
      statisticBodyValues: statisticBodyValues ?? this.statisticBodyValues,
      bodyValues: bodyValues ?? this.bodyValues,
      unshownFinishedGoals: unshownFinishedGoals ?? this.unshownFinishedGoals,
      injectedScreens: injectedScreens,
    );
  }

  StatisticsState copyWithSelection(
      {PersonalRecord? value, StatisticsStatus? status}) {
    return StatisticsState(
      personalRecords: personalRecords,
      selected: value,
      status: status ?? this.status,
      goals: goals,
      account: account,
      statisticBodyValues: statisticBodyValues,
      bodyValues: bodyValues,
      unshownFinishedGoals: unshownFinishedGoals,
      injectedScreens: injectedScreens,
    );
  }

  StatisticsState copyWithInjected(
      {required List<Widget Function()> injectedScreens}) {
    return StatisticsState(
      personalRecords: personalRecords,
      selected: selected,
      status: status,
      goals: goals,
      account: account,
      statisticBodyValues: statisticBodyValues,
      bodyValues: bodyValues,
      unshownFinishedGoals: unshownFinishedGoals,
      injectedScreens: injectedScreens,
    );
  }
}
