import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trainit/bloc/data/state.dart';
import 'package:trainit/data/database.dart';
import 'package:trainit/data/model/calendar.dart';
import 'package:trainit/data/model/calendar_training.dart';
import 'package:trainit/data/model/training_plan.dart';
import 'package:trainit/data/remote.dart';
import 'package:trainit/data/repository/authentication_repository.dart';
import 'package:trainit/data/repository/body_value_repository.dart';
import 'package:trainit/data/repository/calendar_repository.dart';
import 'package:trainit/data/repository/account_repository.dart';
import 'package:trainit/data/repository/friendship_repository.dart';
import 'package:trainit/data/repository/goal_repository.dart';
import 'package:trainit/data/repository/personalrecord_repository.dart';
import 'package:trainit/data/repository/trainingplan_repository.dart';
import 'package:trainit/helper/date.dart';
import 'package:trainit/main.dart';
import 'package:uuid/uuid.dart';

class CalendarGenerationResult {
  final bool changed;
  final WeekCalendar calendar;
  CalendarGenerationResult({required this.calendar, required this.changed});
}

class DataCubit extends Cubit<DataState> {
  final AuthenticationRepository authenticationRepository;
  final AccountRepository accountRepository;
  final TrainingPlanRepository trainingPlanRepository;
  final PersonalRecordRepository personalRecordRepository;
  final CalendarRepository calendarRepository;
  final GoalRepository goalRepository;
  final BodyValueRepository bodyValueRepository;
  final FriendshipRepository friendshipRepository;

  DataCubit({
    required this.accountRepository,
    required this.authenticationRepository,
    required this.calendarRepository,
    required this.personalRecordRepository,
    required this.trainingPlanRepository,
    required this.bodyValueRepository,
    required this.goalRepository,
    required this.friendshipRepository,
  }) : super(DataState());

  Future<void> reloadData() async {
    emit(state.copyWith(
      status: DataStatus.loading,
      statusText: "Synching data",
    ));

    final token = await authenticationRepository.getToken();
    if (token != null) Remote.instance.executeCache(token, null);

    LocalDatabase.recreateInstance();

    final currentAccount = await accountRepository.readLocalAuthenticated();
    final data =
        await accountRepository.readAllRemote(currentAccount?.lastModified);
    if (data.alreadyUpToDate ||
        data.account == null ||
        data.calendarTrainings == null ||
        data.trainingPlans == null ||
        data.personalRecords == null ||
        data.goals == null ||
        data.bodyValues == null) {
      final changed = await generateCalendar();

      emit(state.copyWith(
        status: DataStatus.success,
        statusText: null,
      ));
      dataChangeBus.fire(changed);
      return;
    }

    await personalRecordRepository.writeAllLocal(data.personalRecords!);

    await trainingPlanRepository.writeAllLocal(data.trainingPlans!);

    await goalRepository.writeAllLocal(data.goals!);

    await friendshipRepository.writeAllLocal(data.friendships!);

    await bodyValueRepository.writeAllLocal([
      ...data.bodyValues!.fat,
      ...data.bodyValues!.weight,
    ]);

    await accountRepository.writeLocalAuthenticated(data.account!);
    await calendarRepository.writeLocal(
        WeekCalendar.ofCalendarTrainingList(data.calendarTrainings!));

    await accountRepository.downloadProfilePhoto();
    await generateCalendar();
    emit(state.copyWith(
      status: DataStatus.success,
      statusText: null,
    ));
    dataChangeBus.fire(true);
  }

  Future<bool> generateCalendar() async {
    final account = await accountRepository.readLocalAuthenticated();
    if (account == null) {
      return false;
    }
    final trainingPlan =
        await trainingPlanRepository.readByIdLocal(account.trainingPlanId);
    if (trainingPlan == null) {
      throw "Trainingplan does not exist";
    }

    final localCalendar =
        await calendarRepository.readLocal() ?? WeekCalendar();

    final result = await generateCalendarBy(trainingPlan, localCalendar);
    if (result.changed) {
      await calendarRepository.writeLocal(result.calendar);
      await calendarRepository.uploadLocalCalendarToRemote();
    }

    return result.changed;
  }

  Future<CalendarGenerationResult> generateCalendarBy(
      TrainingPlan trainingPlan, WeekCalendar localCalendar) async {
    bool changed = false;
    localCalendar.deleteIncorrectDates(DateTime.now());

    for (int i = 0; i < 7; i++) {
      final trainingDay = trainingPlan.days.atIndex(i);

      for (var training in trainingDay) {
        final childCalendarTraining =
            localCalendar.getElementWithBaseId(training.id);

        if (childCalendarTraining == null) {
          final nextDate = DateTime.now().next(i);
          final calendarIndex =
              DateTime.now().asDate().difference(nextDate).inDays.abs();

          final calendarTraining = CalendarTraining(
              id: const Uuid().v4(),
              name: training.name,
              exercises: training.exercises,
              baseTrainingId: training.id,
              date: nextDate,
              supersetIndexes: training.supersetIndexes);
          localCalendar.insertAt(
            index: calendarIndex,
            value: calendarTraining,
          );

          changed = true;
        } else if (childCalendarTraining.hash != training.hash) {
          localCalendar.replace(
            childCalendarTraining.id,
            CalendarTraining(
              id: childCalendarTraining.id,
              name: training.name,
              baseTrainingId: training.id,
              exercises: training.exercises,
              date: childCalendarTraining.date,
              supersetIndexes: training.supersetIndexes,
            ),
          );

          changed = true;
        }
      }
    }
    return CalendarGenerationResult(calendar: localCalendar, changed: changed);
  }
}
