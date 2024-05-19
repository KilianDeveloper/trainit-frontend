import 'package:intl/intl.dart';
import 'package:trainit/data/model/exercise.dart';

class CalendarTraining {
  final String id;
  final String name;
  final List<Exercise> exercises;
  final String? baseTrainingId;
  final List<int> supersetIndexes;

  final DateTime date;

  const CalendarTraining(
      {required this.id,
      required this.name,
      required this.exercises,
      this.baseTrainingId,
      required this.supersetIndexes,
      required this.date});

  int getAverageTime(int setDuration, int setRestDuration) {
    final numOfSets = exercises.fold(0, (a, b) => a + b.sets.length);
    final numberOfRests = numOfSets > 0 ? numOfSets - 1 : 0;
    return numOfSets * setDuration + numberOfRests * setRestDuration;
  }

  String get hash {
    return exercises
            .map((e) =>
                e.id + e.name + e.sets.map((s) => s.repetitions).join(""))
            .join("") +
        name;
  }

  factory CalendarTraining.fromJson(Map<String, dynamic> json) {
    final List c = json["supersetIndexes"] ?? [];
    return CalendarTraining(
      id: json["id"],
      name: json["name"],
      exercises: (json["exercises"] as List<dynamic>)
          .map<Exercise>((e) => Exercise.fromJson(e))
          .toList(),
      date: DateFormat("yyyy-MM-dd").parse(json["date"]),
      baseTrainingId: json["baseTrainingId"],
      supersetIndexes: c.cast<int>().toList(),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "exercises": exercises.map((e) => e.toJson()).toList(),
      "date": DateFormat("yyyy-MM-dd").format(date),
      "baseTrainingId": baseTrainingId,
      "supersetIndexes": supersetIndexes,
    };
  }
}
