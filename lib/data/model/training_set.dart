class TrainingSet {
  final int repetitions;
  TrainingSet({required this.repetitions});
  bool get isDropset => repetitions == -1;
  int get visibleRepetitions => repetitions == -1 ? 0 : repetitions;

  factory TrainingSet.fromJson(Map<String, dynamic> json) {
    return TrainingSet(
      repetitions: json["repetitions"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'repetitions': repetitions,
    };
  }
}
