import 'package:flutter/material.dart';
import 'package:trainit/data/model/body_value.dart';
import 'package:trainit/data/model/body_value_type.dart';
import 'package:trainit/data/model/dto/body_value_collection.dart';
import 'package:trainit/data/model/dto/goal_creation.dart';
import 'package:trainit/data/model/dto/personal_record_creation.dart';
import 'package:trainit/data/model/goal.dart';
import 'package:trainit/data/model/goal_type.dart';
import 'package:trainit/data/model/personal_record.dart';
import 'package:trainit/data/model/personal_record_type.dart';
import 'package:uuid/uuid.dart';

class StatisticsEvent {
  List<Object?> get props => [];
}

class SelectPersonalRecord extends StatisticsEvent {
  SelectPersonalRecord({
    required this.selected,
  });
  final PersonalRecord? selected;

  @override
  List<Object?> get props => [selected];
}

class LeaveUpdatePersonalRecord extends StatisticsEvent {
  LeaveUpdatePersonalRecord();
  @override
  List<Object?> get props => [];
}

class CreateOrUpdatePersonalRecord extends StatisticsEvent {
  CreateOrUpdatePersonalRecord({
    required this.name,
    required this.value,
    required this.unit,
  });

  CreateOrUpdatePersonalRecord.fromDto(PersonalRecordCreation dto)
      : name = dto.name,
        value = dto.value,
        unit = dto.unit;

  final String name;
  final double value;
  final Unit unit;
  @override
  List<Object?> get props => [name, value, unit];
}

class UpdatePersonalRecordFavorite extends StatisticsEvent {
  UpdatePersonalRecordFavorite({
    required this.name,
    required this.newIsFavorite,
  });
  final String name;
  final bool? newIsFavorite;
  @override
  List<Object?> get props => [name, newIsFavorite];
}

class DeletePersonalRecord extends StatisticsEvent {
  DeletePersonalRecord(this.personalRecord);
  final PersonalRecord personalRecord;
  @override
  List<Object?> get props => [personalRecord];
}

class LoadLocalData extends StatisticsEvent {
  LoadLocalData();
  @override
  List<Object?> get props => [];
}

class ResetScreenStatus extends StatisticsEvent {
  ResetScreenStatus();
  @override
  List<Object?> get props => [];
}

class SetBodyValueStatisticDuration extends StatisticsEvent {
  SetBodyValueStatisticDuration({required this.duration});
  final int duration;
  @override
  List<Object?> get props => [];
}

class CreateGoal extends StatisticsEvent {
  CreateGoal(this.goal);
  CreateGoal.fromDto(GoalCreation dto, BodyValueCollection bodyValues) {
    const uuid = Uuid();
    Unit unit = Unit.kilograms;
    String name = "Body Weight";
    double from = 0;
    final lastBodyFatValue =
        bodyValues.fat.isNotEmpty ? bodyValues.fat.last : null;
    final lastBodyWeightValue =
        bodyValues.weight.isNotEmpty ? bodyValues.weight.last : null;

    if (dto.type == GoalType.bodyValue &&
        ((dto.bodyValueType == BodyValueType.weight &&
                lastBodyWeightValue == null) ||
            (dto.bodyValueType == BodyValueType.fat &&
                lastBodyFatValue == null))) {
      goal = null;
      return;
    }

    if (dto.type == GoalType.personalRecord) {
      unit = dto.basePersonalRecord!.unit;
      name = dto.basePersonalRecord!.name;
      from = dto.basePersonalRecord!.value;
    } else if (dto.type == GoalType.bodyValue &&
        dto.bodyValueType == BodyValueType.fat) {
      unit = Unit.percent;
      name = "Body Fat";
      from = lastBodyFatValue!.value;
    } else if (dto.type == GoalType.bodyValue &&
        dto.bodyValueType == BodyValueType.weight) {
      from = lastBodyWeightValue!.value;
    }
    goal = Goal(
      id: uuid.v4(),
      type: dto.type,
      name: name,
      isDone: false,
      createdOn: DateTime.now(),
      from: from,
      to: dto.value,
      unit: unit,
    );
  }

  late final Goal? goal;

  @override
  List<Object?> get props => [];
}

class CreateBodyValue extends StatisticsEvent {
  CreateBodyValue(this.value);

  final BodyValue value;

  @override
  List<Object?> get props => [];
}

class PushScreen extends StatisticsEvent {
  final Widget Function() widget;
  PushScreen({required this.widget});
  @override
  List<Object?> get props => [];
}

class PopScreen extends StatisticsEvent {
  PopScreen();
  @override
  List<Object?> get props => [];
}
