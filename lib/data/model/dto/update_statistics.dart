import 'package:trainit/data/model/goal.dart';
import 'package:trainit/data/model/personal_record.dart';

class UpdateStatistics {
  final List<PersonalRecord>? personalRecords;
  final List<Goal>? goals;

  UpdateStatistics({
    this.goals,
    this.personalRecords,
  });

  Map<String, dynamic> toJson() {
    return {
      'personalRecords': personalRecords?.map<Map>((e) => e.toJson()).toList(),
      'goals': goals?.map<Map>((e) => e.toJson()).toList(),
    };
  }
}
