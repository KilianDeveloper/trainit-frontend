enum GoalType {
  personalRecord,
  bodyValue;
}

class GoalTypeHelpers {
  static Map<String, GoalType> jsonMap = {
    "p": GoalType.personalRecord,
    "b": GoalType.bodyValue,
  };

  static GoalType goalTypeFromJson(String json) {
    final value = jsonMap[json];
    if (value == null) throw "Json not supported";
    return value;
  }
}

extension GoalTypeX on GoalType {
  String toJson() {
    return GoalTypeHelpers.jsonMap.keys.firstWhere(
      (element) => GoalTypeHelpers.jsonMap[element] == this,
      orElse: () => throw "GoalType not supported",
    );
  }
}
