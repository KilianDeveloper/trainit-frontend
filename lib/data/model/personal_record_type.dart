import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

enum Unit {
  kilograms,
  pounds,
  seconds,
  minutes,
  meters,
  centimeters,
  percent;
}

class UnitHelpers {
  static Map<String, Unit> jsonMap = {
    "kg": Unit.kilograms,
    "lbs": Unit.pounds,
    "s": Unit.seconds,
    "min": Unit.minutes,
    "m": Unit.meters,
    "cm": Unit.centimeters,
    "p": Unit.percent,
  };

  static Unit unitFromJson(String json) {
    final value = jsonMap[json];
    if (value == null) throw "Json not supported";
    return value;
  }

  static double? valueToUnit(double v, Unit from, Unit to) {
    if (from == to) {
      return v;
    } else if (from == Unit.kilograms && to == Unit.pounds) {
      return v * 2.205;
    } else if (from == Unit.pounds && to == Unit.kilograms) {
      return v / 2.205;
    } else if (from == Unit.seconds && to == Unit.minutes) {
      return v / 60;
    } else if (from == Unit.minutes && to == Unit.seconds) {
      return v * 60;
    } else if (from == Unit.meters && to == Unit.centimeters) {
      return v * 1000;
    } else if (from == Unit.centimeters && to == Unit.meters) {
      return v / 1000;
    } else {
      return null;
    }
  }
}

extension UnitX on Unit {
  String toJson() {
    return UnitHelpers.jsonMap.keys.firstWhere(
      (element) => UnitHelpers.jsonMap[element] == this,
      orElse: () => throw "Unit not supported",
    );
  }

  IconData toIcon() {
    switch (this) {
      case Unit.kilograms:
      case Unit.pounds:
        return Symbols.weight_rounded;
      case Unit.meters:
      case Unit.centimeters:
        return Symbols.distance_rounded;
      case Unit.seconds:
      case Unit.minutes:
        return Symbols.schedule_rounded;
      case Unit.percent:
        return Symbols.emoji_symbols_rounded;
      default:
        return Symbols.unknown_2_rounded;
    }
  }

  Unit nextUnit() {
    switch (this) {
      case Unit.kilograms:
        return Unit.pounds;
      case Unit.pounds:
        return Unit.kilograms;
      case Unit.meters:
        return Unit.centimeters;
      case Unit.centimeters:
        return Unit.meters;
      case Unit.seconds:
        return Unit.minutes;
      case Unit.minutes:
        return Unit.seconds;
      case Unit.percent:
        return Unit.percent;
      default:
        return Unit.seconds;
    }
  }

  Unit nextType() {
    switch (this) {
      case Unit.kilograms:
      case Unit.pounds:
        return Unit.meters;
      case Unit.meters:
      case Unit.centimeters:
        return Unit.seconds;
      case Unit.seconds:
      case Unit.minutes:
        return Unit.percent;
      default:
        return Unit.kilograms;
    }
  }
}
