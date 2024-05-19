import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:objectbox/objectbox.dart';
import 'package:trainit/data/model/training_days.dart';

@Entity()
class TrainingPlan {
  @Id()
  int localId = 0;
  @Index()
  String id;
  String name;

  @Transient()
  TrainingDays days;
  @Property(type: PropertyType.date)
  DateTime createdOn;
  String accountId;

  String get dbDays {
    return jsonEncode(days.toJson());
  }

  set dbDays(String value) {
    days = TrainingDays.fromJson(jsonDecode(value));
  }

  TrainingPlan({
    this.localId = 0,
    required this.id,
    required this.name,
    this.days = const TrainingDays.empty(),
    required this.createdOn,
    required this.accountId,
    String? dbDays,
  }) {
    if (dbDays != null) this.dbDays = dbDays;
  }

  Map toJson() {
    return {
      "name": name,
      "id": id,
      "days": days.toJson(),
      "accountId": accountId,
      "createdOn": DateFormat("yyyy-MM-dd").format(createdOn),
    };
  }

  factory TrainingPlan.fromJson(Map<String, dynamic> json) {
    return TrainingPlan(
      name: json['name'],
      id: json['id'],
      days: TrainingDays.fromJson(json['days']),
      accountId: json['accountId'],
      createdOn: DateTime.parse(json['createdOn']),
    );
  }
}
