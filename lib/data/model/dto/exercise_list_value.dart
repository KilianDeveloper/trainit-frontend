import 'package:trainit/data/model/exercise.dart';

class ExerciseList {
  final List<Exercise> exercises;
  final List<int> supersetIndexes;

  const ExerciseList({
    required this.exercises,
    required this.supersetIndexes,
  });
}
