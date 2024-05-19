import 'package:flutter/material.dart';
import 'package:trainit/data/model/account.dart';
import 'package:trainit/data/model/calendar_training.dart';
import 'package:trainit/data/model/units.dart';
import 'package:uuid/uuid.dart';

import '../../../data/model/calendar.dart';

enum CalendarStatus { initial, success, error, loading, selected }

extension CalendarStatusX on CalendarStatus {
  bool get isInitial => this == CalendarStatus.initial;
  bool get isSuccess => this == CalendarStatus.success;
  bool get isError => this == CalendarStatus.error;
  bool get isLoading => this == CalendarStatus.loading;
  bool get isSelected => this == CalendarStatus.selected;
}

class CalendarState {
  CalendarState({
    this.status = CalendarStatus.initial,
    WeekCalendar? calendar,
    this.selected,
    this.injectedScreens = const [],
    Account? account,
  })  : calendar = calendar ?? WeekCalendar(),
        account = account ??
            Account(
                id: "id",
                username: "StativJovo",
                weightUnit: WeightUnit.kg,
                isPublicProfile: false,
                trainingPlanId: const Uuid().v4(),
                lastModified: DateTime.now());

  final WeekCalendar calendar;
  final CalendarTraining? selected;
  final Account account;
  final List<Widget Function()> injectedScreens;
  final CalendarStatus status;

  List<Object?> get props => [calendar, selected, account];

  CalendarState copyWith({
    WeekCalendar? calendar,
    CalendarStatus? status,
    CalendarTraining? selected,
    Account? account,
  }) {
    return CalendarState(
      calendar: calendar ?? this.calendar,
      selected: selected ?? this.selected,
      status: status ?? this.status,
      account: account ?? this.account,
      injectedScreens: injectedScreens,
    );
  }

  CalendarState copyWithSelection({CalendarTraining? value}) {
    return CalendarState(
      calendar: calendar,
      selected: value,
      status: status,
      account: account,
      injectedScreens: injectedScreens,
    );
  }

  CalendarState copyWithInjected(
      {required List<Widget Function()> injectedScreens}) {
    return CalendarState(
      calendar: calendar,
      selected: selected,
      status: status,
      account: account,
      injectedScreens: injectedScreens,
    );
  }
}
