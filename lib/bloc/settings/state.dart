import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:trainit/data/model/account.dart';
import 'package:trainit/data/model/dto/authentication_user.dart';
import 'package:trainit/data/model/static_data.dart';
import 'package:trainit/data/model/training.dart';
import 'package:trainit/data/model/training_days.dart';
import 'package:trainit/data/model/training_plan.dart';
import 'package:trainit/data/model/units.dart';
import 'package:trainit/main.dart';
import 'package:uuid/uuid.dart';

enum SettingsStatus {
  initial,
  success,
  error,
  appSettings,
  editTrainingPlan,
}

extension SettingsStatusX on SettingsStatus {
  bool get isInitial => this == SettingsStatus.initial;
  bool get isSuccess => this == SettingsStatus.success;
  bool get isError => this == SettingsStatus.error;
  bool get isAppSettingsScreen => this == SettingsStatus.appSettings;
  bool get isEditTrainingPlan => this == SettingsStatus.editTrainingPlan;
}

final _uuid = const Uuid().v4();

class SettingsState {
  SettingsState({
    this.status = SettingsStatus.initial,
    Account? account,
    TrainingPlan? currentTrainingPlan,
    this.selectedTrainingPlan,
    this.profilePhoto,
    this.isLoading = false,
    this.version = "unknown",
    this.theme = ThemeMode.system,
    this.injectedScreens = const [],
    AuthenticationUser? authenticationUser,
    List<TrainingPlan>? allTrainingPlans,
  })  : staticInformation = staticData,
        account = account ??
            Account(
                id: "id",
                username: "StativJovo",
                weightUnit: WeightUnit.kg,
                isPublicProfile: false,
                trainingPlanId: const Uuid().v4(),
                lastModified: DateTime.now()),
        currentTrainingPlan = currentTrainingPlan ??
            TrainingPlan(
                accountId: "asdsadd",
                name: "My Plan",
                days: const TrainingDays.empty(),
                createdOn: DateTime.now(),
                id: _uuid),
        allTrainingPlans = allTrainingPlans ?? [],
        authenticationUser = authenticationUser ??
            AuthenticationUser(
              id: "id",
              email: "email",
              displayName: "name",
            );

  final bool isLoading;
  final List<Widget Function()> injectedScreens;
  final Account account;
  final SettingsStatus status;
  final TrainingPlan currentTrainingPlan;
  final TrainingPlan? selectedTrainingPlan;
  final List<TrainingPlan> allTrainingPlans;
  final Uint8List? profilePhoto;
  final String version;
  final StaticData staticInformation;
  final ThemeMode theme;
  final AuthenticationUser authenticationUser;

  List<Object?> get props => [
        account,
        status,
        currentTrainingPlan,
        selectedTrainingPlan,
        allTrainingPlans
      ];

  bool isEditTrainingPlanScreen() {
    return (status.isEditTrainingPlan) && selectedTrainingPlan != null;
  }

  SettingsState copyWith({
    SettingsStatus? status,
    Account? account,
    TrainingPlan? currentTrainingPlan,
    TrainingPlan? selectedTrainingPlan,
    List<TrainingPlan>? allTrainingPlans,
    Uint8List? profilePhoto,
    bool? isLoading,
    String? version,
    Training? selectedTraining,
    ThemeMode? theme,
    AuthenticationUser? authenticationUser,
  }) {
    return SettingsState(
      status: status ?? this.status,
      account: account ?? this.account,
      isLoading: isLoading ?? this.isLoading,
      profilePhoto: profilePhoto ?? this.profilePhoto,
      currentTrainingPlan: currentTrainingPlan ?? this.currentTrainingPlan,
      selectedTrainingPlan: selectedTrainingPlan ?? this.selectedTrainingPlan,
      allTrainingPlans: allTrainingPlans ?? this.allTrainingPlans,
      version: version ?? this.version,
      theme: theme ?? this.theme,
      injectedScreens: injectedScreens,
      authenticationUser: authenticationUser ?? this.authenticationUser,
    );
  }

  SettingsState copyWithProfilePhoto({
    Uint8List? profilePhoto,
    SettingsStatus? status,
    Account? account,
    TrainingPlan? currentTrainingPlan,
    TrainingPlan? selectedTrainingPlan,
    List<TrainingPlan>? allTrainingPlans,
    bool? isLoading,
    String? version,
    Training? selectedTraining,
    ThemeMode? theme,
    AuthenticationUser? authenticationUser,
  }) {
    return SettingsState(
      status: status ?? this.status,
      account: account ?? this.account,
      isLoading: isLoading ?? this.isLoading,
      profilePhoto: profilePhoto,
      currentTrainingPlan: currentTrainingPlan ?? this.currentTrainingPlan,
      selectedTrainingPlan: selectedTrainingPlan ?? this.selectedTrainingPlan,
      allTrainingPlans: allTrainingPlans ?? this.allTrainingPlans,
      version: version ?? this.version,
      theme: theme ?? this.theme,
      injectedScreens: injectedScreens,
      authenticationUser: authenticationUser ?? this.authenticationUser,
    );
  }

  SettingsState copyWithSelection(
      {SettingsStatus? status, required TrainingPlan? selection}) {
    return SettingsState(
      status: status ?? this.status,
      account: account,
      currentTrainingPlan: currentTrainingPlan,
      selectedTrainingPlan: selection,
      allTrainingPlans: allTrainingPlans,
      version: version,
      isLoading: isLoading,
      profilePhoto: profilePhoto,
      theme: theme,
      injectedScreens: injectedScreens,
      authenticationUser: authenticationUser,
    );
  }

  SettingsState copyWithTrainingSelection(
      {SettingsStatus? status, required Training? selection}) {
    return SettingsState(
      status: status ?? this.status,
      account: account,
      currentTrainingPlan: currentTrainingPlan,
      selectedTrainingPlan: selectedTrainingPlan,
      version: version,
      allTrainingPlans: allTrainingPlans,
      isLoading: isLoading,
      profilePhoto: profilePhoto,
      theme: theme,
      injectedScreens: injectedScreens,
      authenticationUser: authenticationUser,
    );
  }

  SettingsState copyWithInjected(
      {required List<Widget Function()> injectedScreens}) {
    return SettingsState(
      injectedScreens: injectedScreens,
      status: status,
      account: account,
      isLoading: isLoading,
      profilePhoto: profilePhoto,
      currentTrainingPlan: currentTrainingPlan,
      selectedTrainingPlan: selectedTrainingPlan,
      allTrainingPlans: allTrainingPlans,
      version: version,
      theme: theme,
      authenticationUser: authenticationUser,
    );
  }
}
