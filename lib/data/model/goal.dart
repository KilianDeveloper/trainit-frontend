import 'package:intl/intl.dart';
import 'package:objectbox/objectbox.dart';
import 'package:trainit/data/model/goal_type.dart';
import 'package:trainit/data/model/personal_record_type.dart';

@Entity()
class Goal {
  @Id()
  int localId = 0;
  @Index()
  String id;

  @Transient()
  GoalType type;

  String? name;

  @Property(type: PropertyType.date)
  DateTime createdOn;

  double from;
  double to;

  bool isDone;

  @Transient()
  Unit unit;

  String get dbType {
    return type.toJson();
  }

  set dbType(String value) {
    type = GoalTypeHelpers.goalTypeFromJson(value);
  }

  String get dbUnit {
    return unit.toJson();
  }

  set dbUnit(String value) {
    unit = UnitHelpers.unitFromJson(value);
  }

  factory Goal.fromJson(Map<String, dynamic> json) {
    return Goal(
      id: json["id"],
      name: json["name"],
      isDone: json["isDone"],
      createdOn: DateTime.parse(json['createdOn']),
      from: json["from"].toDouble(),
      to: json["to"].toDouble(),
      type: GoalTypeHelpers.goalTypeFromJson(json['type']),
      unit: UnitHelpers.unitFromJson(json['unit']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type.toJson(),
      'createdOn': DateFormat("yyyy-MM-ddTHH:mm:ss").format(createdOn),
      'from': from,
      'to': to,
      'isDone': isDone,
      'unit': unit.toJson(),
    };
  }

  Goal({
    this.localId = 0,
    required this.id,
    required this.name,
    required this.isDone,
    required this.createdOn,
    required this.from,
    required this.to,
    this.type = GoalType.personalRecord,
    this.unit = Unit.kilograms,
  });
}
