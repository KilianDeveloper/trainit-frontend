import 'package:trainit/data/model/body_value_type.dart';
import 'package:trainit/data/model/goal_type.dart';
import 'package:trainit/data/model/personal_record.dart';

class GoalCreation {
  final GoalType type;
  final PersonalRecord? basePersonalRecord;
  final BodyValueType? bodyValueType;
  final double value;

  GoalCreation({
    required this.type,
    required this.basePersonalRecord,
    required this.bodyValueType,
    required this.value,
  });
}
