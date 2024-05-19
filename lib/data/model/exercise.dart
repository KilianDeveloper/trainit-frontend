import 'package:trainit/data/model/training_set.dart';
import 'package:uuid/uuid.dart';

class Exercise {
  final String id;
  final String name;
  final List<TrainingSet> sets;
  Exercise.newEntity()
      : id = const Uuid().v4(),
        name = "My Exercise",
        sets = [TrainingSet(repetitions: 10)];

  Exercise({required this.id, required this.name, required this.sets});

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      id: json["id"],
      name: json["name"],
      sets: (json["sets"] as List<dynamic>)
          .map<TrainingSet>((e) => TrainingSet.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'sets': sets.map((e) => e.toJson()).toList(),
    };
  }
}
