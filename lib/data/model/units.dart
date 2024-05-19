//Weight
enum WeightUnit {
  lbs,
  kg;
}

extension WeightX on WeightUnit {
  double valueToBaseUnit(double value) {
    if (this == WeightUnit.kg) {
      return value;
    } else {
      return value / 2.205;
    }
  }

  String valueToString() {
    return this == WeightUnit.kg ? "kg" : "lbs";
  }
}

double convertBaseUnitTo(double value, WeightUnit weightUnit) {
  if (weightUnit == WeightUnit.kg) {
    return value;
  } else {
    return double.parse((value * 2.205).toStringAsFixed(2));
  }
}

WeightUnit weightUnitFromJson(String value) {
  return value == "kg" ? WeightUnit.kg : WeightUnit.lbs;
}

String weightUnitToJson(WeightUnit value) {
  return value == WeightUnit.kg ? "kg" : "lbs";
}
