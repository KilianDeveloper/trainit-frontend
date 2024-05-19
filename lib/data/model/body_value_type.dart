enum BodyValueType { weight, fat }

class BodyValueTypeHelpers {
  static Map<String, BodyValueType> jsonMap = {
    "w": BodyValueType.weight,
    "f": BodyValueType.fat,
  };

  static BodyValueType fromJson(String json) {
    final value = jsonMap[json];
    if (value == null) throw "Json not supported";
    return value;
  }
}

extension BodyValueTypeX on BodyValueType {
  String toJson() {
    return BodyValueTypeHelpers.jsonMap.keys.firstWhere(
      (element) => BodyValueTypeHelpers.jsonMap[element] == this,
      orElse: () => throw "BodyValueType not supported",
    );
  }
}
