import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trainit/bloc/tutorial/bloc.dart';
import 'package:trainit/bloc/tutorial/event.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum TutorialStatus { initial, pending, ended, error }

extension TutorialStatusX on TutorialStatus {
  bool get isInitial => this == TutorialStatus.initial;
  bool get isPending => this == TutorialStatus.pending;
  bool get isError => this == TutorialStatus.error;
  bool get isEnded => this == TutorialStatus.ended;
}

class TutorialItem {
  final String id;
  final String Function(BuildContext context) title;
  final String Function(BuildContext context) content;
  final bool isPositioned;
  final bool hasSkipOnClick;
  final Widget Function(BuildContext context)? primaryButton;
  final Widget Function(BuildContext context)? secondaryButton;

  const TutorialItem({
    required this.id,
    required this.title,
    required this.content,
    this.hasSkipOnClick = true,
    this.isPositioned = true,
    this.primaryButton,
    this.secondaryButton,
  });
}

final List<TutorialItem?> baseTutorialStack = [
  TutorialItem(
    id: "end",
    title: (context) => AppLocalizations.of(context)!.tutorial_end_title,
    content: (context) => AppLocalizations.of(context)!.tutorial_end_message,
    isPositioned: false,
  ),
  TutorialItem(
    id: "edit_personal_record",
    title: (context) =>
        AppLocalizations.of(context)!.tutorial_edit_personal_record_title,
    content: (context) =>
        AppLocalizations.of(context)!.tutorial_edit_personal_record_message,
    isPositioned: false,
  ),
  null,
  TutorialItem(
    id: "create_personal_record",
    title: (context) =>
        AppLocalizations.of(context)!.tutorial_create_personal_record_title,
    content: (context) =>
        AppLocalizations.of(context)!.tutorial_create_personal_record_message,
    isPositioned: false,
  ),
  null,
  TutorialItem(
    id: "click_new_personal_record",
    title: (context) =>
        AppLocalizations.of(context)!.tutorial_click_new_personal_record_title,
    content: (context) => AppLocalizations.of(context)!
        .tutorial_click_new_personal_record_message,
    isPositioned: false,
  ),
  TutorialItem(
    id: "statistics_overview",
    title: (context) =>
        AppLocalizations.of(context)!.tutorial_statistics_overview_title,
    content: (context) =>
        AppLocalizations.of(context)!.tutorial_statistics_overview_message,
    isPositioned: false,
  ),
  null,
  TutorialItem(
    id: "navigate_statistics",
    title: (context) =>
        AppLocalizations.of(context)!.tutorial_navigate_statistics_title,
    content: (context) =>
        AppLocalizations.of(context)!.tutorial_navigate_statistics_message,
    isPositioned: false,
  ),
  TutorialItem(
    id: "calendar_training",
    title: (context) =>
        AppLocalizations.of(context)!.tutorial_calendar_training_title,
    content: (context) =>
        AppLocalizations.of(context)!.tutorial_calendar_training_message,
    isPositioned: false,
  ),
  null,
  TutorialItem(
    id: "click_calendar_training",
    title: (context) =>
        AppLocalizations.of(context)!.tutorial_click_calendar_training_title,
    content: (context) =>
        AppLocalizations.of(context)!.tutorial_click_calendar_training_message,
    isPositioned: false,
  ),
  null,
  TutorialItem(
    id: "navigate_calendar",
    title: (context) =>
        AppLocalizations.of(context)!.tutorial_navigate_calendar_title,
    content: (context) =>
        AppLocalizations.of(context)!.tutorial_navigate_calendar_message,
    isPositioned: false,
  ),
  null,
  TutorialItem(
    id: "save_training_and_plan",
    title: (context) =>
        AppLocalizations.of(context)!.tutorial_save_training_and_plan_title,
    content: (context) =>
        AppLocalizations.of(context)!.tutorial_save_training_and_plan_message,
    isPositioned: false,
  ),
  null,
  TutorialItem(
    id: "add_exercise",
    title: (context) =>
        AppLocalizations.of(context)!.tutorial_add_exercise_title,
    content: (context) =>
        AppLocalizations.of(context)!.tutorial_add_exercise_message,
    isPositioned: false,
  ),
  TutorialItem(
    id: "training_plan_overview",
    title: (context) =>
        AppLocalizations.of(context)!.tutorial_training_plan_overview_title,
    content: (context) =>
        AppLocalizations.of(context)!.tutorial_training_plan_overview_message,
    isPositioned: false,
  ),
  null,
  TutorialItem(
    id: "training_plan_click_training",
    title: (context) => AppLocalizations.of(context)!
        .tutorial_training_plan_click_training_title,
    content: (context) => AppLocalizations.of(context)!
        .tutorial_training_plan_click_training_message,
    isPositioned: false,
  ),
  null,
  TutorialItem(
    id: "training_plan_create_training",
    title: (context) => AppLocalizations.of(context)!
        .tutorial_training_plan_create_training_title,
    content: (context) => AppLocalizations.of(context)!
        .tutorial_training_plan_create_training_message,
    isPositioned: false,
  ),
  TutorialItem(
    id: "training_plan_edit_page",
    title: (context) =>
        AppLocalizations.of(context)!.tutorial_training_plan_edit_page_title,
    content: (context) =>
        AppLocalizations.of(context)!.tutorial_training_plan_edit_page_message,
    isPositioned: false,
  ),
  null,
  TutorialItem(
    id: "edit_training_plan",
    title: (context) => AppLocalizations.of(context)!.tutorial_account_title,
    content: (context) =>
        AppLocalizations.of(context)!.tutorial_account_message,
    isPositioned: false,
  ),
  null,
  TutorialItem(
    id: "navigate_account",
    title: (context) => AppLocalizations.of(context)!.tutorial_navigation_title,
    content: (context) =>
        AppLocalizations.of(context)!.tutorial_navigation_message,
  ),
  TutorialItem(
    id: "calendar",
    title: (context) => AppLocalizations.of(context)!.tutorial_calendar_title,
    content: (context) =>
        AppLocalizations.of(context)!.tutorial_calendar_message,
    isPositioned: false,
  ),
  TutorialItem(
    id: "start",
    title: (context) => AppLocalizations.of(context)!.tutorial_welcome_title,
    content: (context) =>
        AppLocalizations.of(context)!.tutorial_welcome_message,
    isPositioned: false,
    hasSkipOnClick: false,
    secondaryButton: (context) => TextButton(
        onPressed: () {
          context.read<TutorialBloc>().add(StopTutorial());
        },
        child: Text(AppLocalizations.of(context)!.skip_tutorial)),
    primaryButton: (context) => FilledButton(
      onPressed: () {
        context.read<TutorialBloc>().add(NextTutorial());
      },
      child: Text(AppLocalizations.of(context)!.start),
    ),
  ),
];

class TutorialState {
  TutorialState({
    this.status = TutorialStatus.ended,
    this.tutorialElementPointers = const {},
    List<TutorialItem?>? tutorialStack,
  }) : tutorialStack = tutorialStack ?? baseTutorialStack;

  final List<TutorialItem?> tutorialStack;
  final Map<String, Point> tutorialElementPointers;

  final TutorialStatus status;

  List<Object?> get props => [tutorialStack, status];

  TutorialState copyWith({
    List<TutorialItem?>? tutorialStack,
    TutorialStatus? status,
    Map<String, Point>? tutorialElementPointers,
  }) {
    return TutorialState(
      status: status ?? this.status,
      tutorialStack: tutorialStack ?? this.tutorialStack,
      tutorialElementPointers:
          tutorialElementPointers ?? this.tutorialElementPointers,
    );
  }

  TutorialState copyWithReset({
    TutorialStatus? status,
    Map<String, Point>? tutorialElementPointers,
  }) {
    return TutorialState(
      status: status ?? this.status,
      tutorialStack: baseTutorialStack,
      tutorialElementPointers:
          tutorialElementPointers ?? this.tutorialElementPointers,
    );
  }
}
