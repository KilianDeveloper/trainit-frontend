import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:trainit/data/model/training.dart';
import 'package:trainit/data/model/training_days.dart';
import 'package:trainit/data/model/training_plan.dart';
import 'package:trainit/data/model/units.dart';

class SettingsEvent {
  List<Object?> get props => [];
}

class NavigateAppSettings extends SettingsEvent {
  NavigateAppSettings();
  @override
  List<Object?> get props => [];
}

class NavigateBack extends SettingsEvent {
  NavigateBack();
  @override
  List<Object?> get props => [];
}

class SelectTrainingPlan extends SettingsEvent {
  SelectTrainingPlan({
    required this.selected,
  });
  final TrainingPlan? selected;

  @override
  List<Object?> get props => [selected];
}

class SelectTraining extends SettingsEvent {
  SelectTraining({
    required this.selected,
  });
  final Training? selected;

  @override
  List<Object?> get props => [selected];
}

class SaveSelectedTrainingPlan extends SettingsEvent {
  SaveSelectedTrainingPlan({
    required this.name,
    required this.days,
    this.onFinish,
  });
  final Function()? onFinish;
  final String name;
  final TrainingDays days;

  @override
  List<Object?> get props => [name, days];
}

class SaveAccount extends SettingsEvent {
  SaveAccount({
    required this.weightUnit,
    required this.setDuration,
    required this.restDuration,
  });
  final WeightUnit weightUnit;
  final int setDuration;
  final int restDuration;

  @override
  List<Object?> get props => [weightUnit];
}

class LoadLocalData extends SettingsEvent {
  final Function()? onFinish;
  LoadLocalData({this.onFinish});
  @override
  List<Object?> get props => [];
}

class PushScreen extends SettingsEvent {
  final Widget Function() widget;
  PushScreen({required this.widget});
  @override
  List<Object?> get props => [];
}

class PopScreen extends SettingsEvent {
  PopScreen();
  @override
  List<Object?> get props => [];
}

class SaveProfilePhoto extends SettingsEvent {
  SaveProfilePhoto({required this.data});
  final Uint8List? data;

  @override
  List<Object?> get props => [data];
}

class SaveTheme extends SettingsEvent {
  SaveTheme({required this.theme});
  final ThemeMode theme;

  @override
  List<Object?> get props => [theme];
}

class ResetScreenStatus extends SettingsEvent {
  ResetScreenStatus();
  @override
  List<Object?> get props => [];
}
