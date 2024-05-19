import 'package:trainit/data/model/exercise.dart';
import 'package:uuid/uuid.dart';

class Training {
  String id;
  String name;
  List<int> supersetIndexes;
  List<Exercise> exercises;

  Training({
    required this.id,
    required this.name,
    required this.exercises,
    required this.supersetIndexes,
  });

  Training.empty()
      : id = (const Uuid()).v4(),
        name = "My Training",
        exercises = [],
        supersetIndexes = [];

  int getAverageTime(int setDuration, int setRestDuration) {
    final numOfSets = exercises.fold(0, (a, b) {
      if (supersetIndexes.contains(exercises.indexOf(b))) {
        return a;
      }
      return a + b.sets.length;
    });
    final numberOfRests = numOfSets > 0 ? numOfSets - 1 : 0;
    return numOfSets * setDuration + numberOfRests * setRestDuration;
  }

  String get hash =>
      exercises
          .map((e) => e.id + e.name + e.sets.map((s) => s.repetitions).join(""))
          .join("") +
      name;

  factory Training.fromJson(Map<String, dynamic> json) {
    final List c = json["supersetIndexes"] ?? [];
    final training = Training(
      id: json["id"],
      name: json["name"],
      supersetIndexes: c.cast<int>().toList(),
      exercises: (json["exercises"] as List<dynamic>)
          .map<Exercise>((e) => Exercise.fromJson(e))
          .toList(),
    );
    return training;
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "exercises": exercises.map((e) => e.toJson()).toList(),
      "supersetIndexes": supersetIndexes,
    };
  }
}
