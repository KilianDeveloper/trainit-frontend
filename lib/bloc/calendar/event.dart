import 'package:flutter/material.dart';
import 'package:trainit/data/model/calendar_training.dart';

class CalendarEvent {
  List<Object?> get props => [];
}

class SelectCalendarTraining extends CalendarEvent {
  SelectCalendarTraining({
    required this.selected,
  });
  final CalendarTraining? selected;

  @override
  List<Object?> get props => [selected];
}

class ResetScreenStatus extends CalendarEvent {
  ResetScreenStatus();
  @override
  List<Object?> get props => [];
}

class PushScreen extends CalendarEvent {
  final Widget Function() widget;
  PushScreen({required this.widget});
  @override
  List<Object?> get props => [];
}

class PopScreen extends CalendarEvent {
  PopScreen();
  @override
  List<Object?> get props => [];
}

class LoadLocalData extends CalendarEvent {
  LoadLocalData();
  @override
  List<Object?> get props => [];
}
