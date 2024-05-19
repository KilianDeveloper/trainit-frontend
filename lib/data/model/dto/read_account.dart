import 'package:trainit/data/model/account.dart';
import 'package:trainit/data/model/body_value.dart';
import 'package:trainit/data/model/body_value_type.dart';
import 'package:trainit/data/model/calendar_training.dart';
import 'package:trainit/data/model/dto/body_value_collection.dart';
import 'package:trainit/data/model/friendship.dart';
import 'package:trainit/data/model/goal.dart';
import 'package:trainit/data/model/personal_record.dart';
import 'package:trainit/data/model/training_plan.dart';

class ReadAccountDto {
  final Account? account;
  final List<TrainingPlan>? trainingPlans;
  final bool alreadyUpToDate;
  final List<CalendarTraining>? calendarTrainings;
  final List<PersonalRecord>? personalRecords;
  final List<Goal>? goals;
  final List<Friendship>? friendships;
  final BodyValueCollection? bodyValues;

  ReadAccountDto({
    this.account,
    this.trainingPlans,
    required this.alreadyUpToDate,
    this.calendarTrainings,
    this.personalRecords,
    this.bodyValues,
    this.friendships,
    this.goals,
  });

  ReadAccountDto.error({
    this.account,
    this.trainingPlans,
    this.calendarTrainings,
    this.personalRecords,
    this.bodyValues,
    this.goals,
    this.friendships,
  }) : alreadyUpToDate = true;

  factory ReadAccountDto.fromJson(Map<String, dynamic> json) {
    final account =
        json["account"] != null ? Account.fromJson(json["account"]) : null;
    final trainingPlans = json["trainingPlans"] != null
        ? (json["trainingPlans"] as List<dynamic>)
            .map<TrainingPlan>((e) => TrainingPlan.fromJson(e))
            .toList()
        : null;
    final personalRecords = json["account"] != null
        ? (json["account"]["personalRecords"] as List<dynamic>)
            .map<PersonalRecord>((e) => PersonalRecord.fromJson(e))
            .toList()
        : null;
    final calendarTrainings = json["account"] != null
        ? (json["account"]["calendarTrainings"] as List<dynamic>)
            .map<CalendarTraining>((e) => CalendarTraining.fromJson(e))
            .toList()
        : null;
    final goals = json["account"] != null
        ? (json["account"]["goals"] as List<dynamic>)
            .map<Goal>((e) => Goal.fromJson(e))
            .toList()
        : null;
    final bodyFat = json["account"] != null
        ? (json["account"]["bodyFat"] as List<dynamic>)
            .map<BodyValue>((e) => BodyValue.fromJson(BodyValueType.fat, e))
            .toList()
        : null;
    final bodyWeight = json["account"] != null
        ? (json["account"]["bodyWeight"] as List<dynamic>)
            .map<BodyValue>((e) => BodyValue.fromJson(BodyValueType.weight, e))
            .toList()
        : null;

    final friendships = json["friendships"] != null
        ? (json["friendships"] as List<dynamic>)
            .map<Friendship>((e) => Friendship.fromJson(e))
            .toList()
        : null;
    return ReadAccountDto(
      account: account,
      trainingPlans: trainingPlans,
      alreadyUpToDate: json["alreadyUpToDate"],
      calendarTrainings: calendarTrainings,
      personalRecords: personalRecords,
      goals: goals,
      friendships: friendships,
      bodyValues: BodyValueCollection(
        weightValue: bodyWeight ?? [],
        fatValue: bodyFat ?? [],
      ),
    );
  }
}
