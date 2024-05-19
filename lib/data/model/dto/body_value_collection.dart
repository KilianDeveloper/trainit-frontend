import 'package:trainit/data/model/body_value.dart';
import 'package:trainit/data/model/body_value_type.dart';
import 'package:trainit/helper/date.dart';

class BodyValueCollection {
  final List<BodyValue> weight;
  final List<BodyValue> fat;

  static const _latestFatKey = "latestFat";
  static const _latestWeightKey = "latestWeight";

  BodyValueCollection({
    required List<BodyValue> weightValue,
    required List<BodyValue> fatValue,
  })  : weight = weightValue..sort((a, b) => a.date.compareTo(b.date)),
        fat = fatValue..sort((a, b) => a.date.compareTo(b.date));

  factory BodyValueCollection.fromJson(Map<String, dynamic> json) {
    final weightValues = (json["weight"] as List<dynamic>)
        .map<BodyValue>((e) => BodyValue.fromJson(BodyValueType.weight, e))
        .toList();
    final fatValues = (json["fat"] as List<dynamic>)
        .map<BodyValue>((e) => BodyValue.fromJson(BodyValueType.fat, e))
        .toList();

    if (json.containsKey(_latestFatKey) && json[_latestFatKey] != null) {
      final fatValue =
          BodyValue.fromJson(BodyValueType.fat, json[_latestFatKey]);
      if (!fatValues.any((e) => e.date.isSameDate(fatValue.date))) {
        fatValues.add(fatValue);
      }
    }
    if (json.containsKey(_latestWeightKey) && json[_latestWeightKey] != null) {
      final weightValue =
          BodyValue.fromJson(BodyValueType.fat, json[_latestWeightKey]);
      if (!weightValues.any((e) => e.date.isSameDate(weightValue.date))) {
        weightValues.add(weightValue);
      }
    }
    return BodyValueCollection(
      weightValue: weightValues,
      fatValue: fatValues,
    );
  }
}
