import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:trainit/bloc/statistics/event.dart';
import 'package:trainit/bloc/statistics/state.dart';
import 'package:trainit/data/model/body_value.dart';
import 'package:trainit/data/model/body_value_type.dart';
import 'package:trainit/data/model/dto/body_value_collection.dart';
import 'package:trainit/data/model/dto/finished_goal.dart';
import 'package:trainit/data/model/dto/statistic_body_value_collection.dart';
import 'package:trainit/data/model/goal.dart';
import 'package:trainit/data/model/goal_type.dart';
import 'package:trainit/data/model/personal_record.dart';
import 'package:trainit/data/model/personal_record_type.dart';
import 'package:trainit/data/repository/account_repository.dart';
import 'package:trainit/data/repository/body_value_repository.dart';
import 'package:trainit/data/repository/goal_repository.dart';
import 'package:trainit/data/repository/personalrecord_repository.dart';
import 'package:trainit/helper/bool.dart';
import 'package:trainit/helper/date.dart';
import 'package:trainit/main.dart';

class StatisticsBloc extends Bloc<StatisticsEvent, StatisticsState> {
  final PersonalRecordRepository personalRecordRepository;
  final AccountRepository accountRepository;
  final GoalRepository goalRepository;
  final BodyValueRepository bodyValueRepository;

  StatisticsBloc({
    required this.accountRepository,
    required this.personalRecordRepository,
    required this.goalRepository,
    required this.bodyValueRepository,
  }) : super(StatisticsState()) {
    on<SelectPersonalRecord>(_handleSelectCalendarTraining);
    on<LeaveUpdatePersonalRecord>(_handleLeaveUpdatePersonalRecordClick);
    on<CreateOrUpdatePersonalRecord>(_handleCreateOrUpdatePersonalRecord);
    on<UpdatePersonalRecordFavorite>(_handleUpdatePersonalRecordFavorite);
    on<LoadLocalData>(_handleLoadLocalData);
    on<ResetScreenStatus>(_handleResetScreenStatus);
    on<DeletePersonalRecord>(_handleDeletePersonalRecord);
    on<CreateGoal>(_handleCreateGoal);
    on<SetBodyValueStatisticDuration>(_handleSetBodyValueStatisticDuration);
    on<CreateBodyValue>(_handleCreateBodyValue);
    on<PushScreen>(_handlePushScreen);
    on<PopScreen>(_handlePopScreen);

    add(LoadLocalData());

    dataChangeBus.on<bool>().listen((event) {
      if (event == true && !isClosed) add(LoadLocalData());
    });
  }

  void _handleResetScreenStatus(
      ResetScreenStatus event, Emitter<StatisticsState> emit) async {
    emit(state.copyWith(status: StatisticsStatus.initial));
  }

  Future<void> _updatePersonalRecords(
    List<PersonalRecord> personalRecords,
    Emitter<StatisticsState> emit,
  ) async {
    personalRecords.sort((a, b) => a.isFavorite.compareTo(b.isFavorite));

    emit(
      state
          .copyWith(personalRecords: personalRecords)
          .copyWithSelection(value: null, status: StatisticsStatus.initial),
    );
    await personalRecordRepository.writeAllLocal(personalRecords);
    await personalRecordRepository.uploadLocalPersonalRecordsToRemote();
    add(LoadLocalData());
  }

  void _handleLoadLocalData(
      LoadLocalData event, Emitter<StatisticsState> emit) async {
    final authenticatedAccount =
        await accountRepository.readLocalAuthenticated();
    if (authenticatedAccount == null) {
      return;
    }
    var allBodyValues = await bodyValueRepository.readAllLocal();

    final personalRecords = await personalRecordRepository.readAllLocal();
    personalRecords.sort((a, b) => a.isFavorite.compareTo(b.isFavorite));
    var goals = await goalRepository.readAllLocal();
    await _getNewFinishedGoals(
        goals: goals,
        personalRecords: personalRecords,
        bodyValues: allBodyValues,
        callback: (goals, newFinishedGoals) {
          goalRepository.writeAllLocal(goals);
          emit(state.copyWith(
            bodyValues: allBodyValues,
            account: authenticatedAccount,
            personalRecords: personalRecords,
            unshownFinishedGoals: newFinishedGoals,
            goals: goals,
          ));
          add(SetBodyValueStatisticDuration(duration: 8));
        });
  }

  void _handlePushScreen(
      PushScreen event, Emitter<StatisticsState> emit) async {
    emit(
      state.copyWithInjected(
        injectedScreens: state.injectedScreens.toList()..add(event.widget),
      ),
    );
  }

  void _handlePopScreen(PopScreen event, Emitter<StatisticsState> emit) async {
    emit(
      state.copyWithInjected(
        injectedScreens: state.injectedScreens..removeLast(),
      ),
    );
  }

  Future<void> _getNewFinishedGoals({
    required List<Goal> goals,
    required List<PersonalRecord> personalRecords,
    required BodyValueCollection bodyValues,
    required Function(List<Goal>, List<FinishedGoal>) callback,
  }) async {
    final List<FinishedGoal> newFinishedGoals = [];

    for (var goal in goals) {
      final isIncreasingGoal = goal.from < goal.to;

      double? currentValue;
      if (goal.type == GoalType.bodyValue) {
        if (goal.name == "Body Fat") {
          if (bodyValues.fat.isEmpty) continue;
          currentValue = UnitHelpers.valueToUnit(
            bodyValues.fat.last.value,
            Unit.percent,
            goal.unit,
          );
        } else if (goal.name == "Body Weight") {
          if (bodyValues.weight.isEmpty) continue;
          currentValue = UnitHelpers.valueToUnit(
              bodyValues.weight.last.value, Unit.kilograms, goal.unit);
        }
        if (currentValue == null) continue;
      } else if (goal.type == GoalType.personalRecord) {
        final prs =
            personalRecords.where((element) => element.name == goal.name);
        if (prs.isEmpty) continue;
        final personalRecord = prs.first;
        currentValue = UnitHelpers.valueToUnit(
            personalRecord.value, goal.unit, personalRecord.unit);
      }
      if (currentValue == null) continue;
      final isGoalFinished =
          isIncreasingGoal ? currentValue >= goal.to : currentValue <= goal.to;
      if (isGoalFinished && !goal.isDone) {
        final newGoal = Goal(
          id: goal.id,
          name: goal.name,
          isDone: true,
          createdOn: goal.createdOn,
          from: goal.from,
          to: goal.to,
        );
        final bytes = await goalRepository.finishGoalRemote(goal);
        if (bytes == null) continue;
        goals = goals
            .map((e) => e.id == goal.id ? newGoal : e)
            .where((e) => e.id != goal.id)
            .toList();
        newFinishedGoals.add(FinishedGoal(imageBytes: bytes, goal: newGoal));
      }
    }
    callback(goals, newFinishedGoals);
  }

  void _handleSetBodyValueStatisticDuration(
    SetBodyValueStatisticDuration event,
    Emitter<StatisticsState> emit,
  ) async {
    final duration = event.duration;
    final today = DateTime.now();

    var remoteBodyValues =
        await bodyValueRepository.getRemote(duration: duration);
    var allBodyValues = state.bodyValues;

    List<BodyValue> oldFatValues = remoteBodyValues?.fat ?? allBodyValues.fat;
    List<BodyValue> oldWeightValues =
        remoteBodyValues?.weight ?? allBodyValues.weight;
    List<BodyValue?> newFatValues = [];
    List<BodyValue?> newWeightValues = [];
    List<String?> xAxisValues = [];

    const maxItems = 12;

    var deltaDays = 1;
    if (duration.toDouble() / maxItems > 1) {
      deltaDays = (duration.toDouble() / 12.0).ceil();
      if (deltaDays == 31) {
        deltaDays = 30;
      }
    }
    var d = Duration(days: deltaDays);

    var date = today;
    for (int i = duration; i > 0; i -= deltaDays) {
      var fatValue = _getNextBodyValueForDate(
        values: oldFatValues,
        existingValues: newFatValues,
        date: date,
        dateDifference: d,
      );

      var weightValue = _getNextBodyValueForDate(
        values: oldWeightValues,
        existingValues: newWeightValues,
        date: date,
        dateDifference: d,
      );

      int? maxLength;
      var dateFormat = "d.M";
      if (duration == 8) {
        dateFormat = "E";
        maxLength = 2;
      } else if (duration == 366) {
        dateFormat = "MMM";
        maxLength = 3;
      }
      final dateString = DateFormat(dateFormat).format(date);
      xAxisValues.add(
          maxLength != null ? dateString.substring(0, maxLength) : dateString);
      newFatValues.add(fatValue.value != -1 ? fatValue : null);
      newWeightValues.add(weightValue.value != -1 ? weightValue : null);

      date = date.subtract(d);
    }

    emit(state.copyWith(
      bodyValues: allBodyValues,
      statisticBodyValues: StatisticBodyValueCollection(
        weight: newWeightValues.reversed.toList(),
        xAxisValues: xAxisValues.reversed.toList(),
        fat: newFatValues.reversed.toList(),
        mostRecentWeight:
            allBodyValues.weight.isEmpty ? null : allBodyValues.weight.last,
        mostRecentFat:
            allBodyValues.fat.isEmpty ? null : allBodyValues.fat.last,
        forDuration: duration,
      ),
    ));
  }

  BodyValue _getNextBodyValueForDate({
    required List<BodyValue> values,
    required List<BodyValue?> existingValues,
    required DateTime date,
    required Duration dateDifference,
  }) {
    var value = values.lastWhere(
      (element) => element.date.isSameDate(date),
      orElse: () => BodyValue(value: -1, date: date),
    );

    if (value.value == -1) {
      final range = values.where((element) =>
          (element.date.isBefore(date.add(dateDifference))) &&
          (element.date.isAfter(date.subtract(dateDifference))));
      for (var element in range) {
        if (existingValues.contains(element)) {
          continue;
        }
        if (value.value == -1 || element.date.isBetween(value.date, date)) {
          value = element;
        }
      }
    }

    return value;
  }

  void _handleUpdatePersonalRecordFavorite(
      UpdatePersonalRecordFavorite event, Emitter<StatisticsState> emit) async {
    if (!state.personalRecords.any((element) => element.name == event.name)) {
      emit(state.copyWith(status: StatisticsStatus.error));
      return;
    }
    final newValue = state.personalRecords.map((pr) {
      if (pr.name != event.name) {
        return pr;
      } else {
        return PersonalRecord(
          name: pr.name,
          value: pr.value,
          date: pr.date,
          isFavorite: event.newIsFavorite ?? pr.isFavorite,
          unit: pr.unit,
        );
      }
    }).toList();

    await _updatePersonalRecords(newValue, emit);
  }

  void _handleCreateOrUpdatePersonalRecord(
      CreateOrUpdatePersonalRecord event, Emitter<StatisticsState> emit) async {
    final List<PersonalRecord> newValue;
    if (state.personalRecords.any((element) => element.name == event.name)) {
      newValue = state.personalRecords.map((pr) {
        if (pr.name != event.name) {
          return pr;
        } else {
          return PersonalRecord(
            name: pr.name,
            value: event.value,
            date: DateTime.now(),
            isFavorite: pr.isFavorite,
            unit: event.unit,
          );
        }
      }).toList();
    } else {
      if (state.personalRecords.length >= 20) {
        return;
      }
      newValue = state.personalRecords;
      newValue.add(
        PersonalRecord.byInput(
          name: event.name,
          value: event.value,
          unit: event.unit,
        ),
      );
    }
    await _updatePersonalRecords(newValue, emit);
  }

  void _handleDeletePersonalRecord(
      DeletePersonalRecord event, Emitter<StatisticsState> emit) async {
    final newValue = state.personalRecords
        .where((element) => element.name != event.personalRecord.name)
        .toList();
    if (newValue.length < state.personalRecords.length) {
      await _updatePersonalRecords(newValue, emit);
    }
  }

  void _handleLeaveUpdatePersonalRecordClick(
      LeaveUpdatePersonalRecord event, Emitter<StatisticsState> emit) async {
    emit(
      state
          .copyWithSelection(value: null, status: StatisticsStatus.initial)
          .copyWithInjected(injectedScreens: []),
    );
  }

  void _handleSelectCalendarTraining(
      SelectPersonalRecord event, Emitter<StatisticsState> emit) async {
    emit(
      state
          .copyWithSelection(
              value: event.selected, status: StatisticsStatus.update)
          .copyWithInjected(injectedScreens: []),
    );
  }

  void _handleCreateGoal(
      CreateGoal event, Emitter<StatisticsState> emit) async {
    if (event.goal == null) return;
    await goalRepository.addLocal(event.goal!);
    await goalRepository.uploadLocalGoalsToRemote();
    add(LoadLocalData());
  }

  void _handleCreateBodyValue(
      CreateBodyValue event, Emitter<StatisticsState> emit) async {
    final bool isInvalidFatValue = event.value.type == BodyValueType.fat &&
        ((event.value.value < 0 && event.value.value < 0) ||
            state.bodyValues.fat
                .any((element) => element.date.isSameDate(event.value.date)));
    final bool isInvalidWeightValue =
        event.value.type == BodyValueType.weight &&
            state.bodyValues.weight
                .any((element) => element.date.isSameDate(event.value.date));
    if (isInvalidFatValue || isInvalidWeightValue) {
      return;
    }
    final value = await bodyValueRepository.uploadToRemote(event.value);
    if (value) {
      await bodyValueRepository.addLocal(event.value);
    }
    add(LoadLocalData());
  }
}
