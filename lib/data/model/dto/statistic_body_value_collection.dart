import 'package:trainit/data/model/body_value.dart';

class StatisticBodyValueCollection {
  final List<BodyValue?> weight;
  final List<BodyValue?> fat;
  final BodyValue? mostRecentFat;
  final BodyValue? mostRecentWeight;
  final List<String?> xAxisValues;
  final int forDuration;

  StatisticBodyValueCollection({
    required this.weight,
    required this.fat,
    required this.mostRecentFat,
    required this.mostRecentWeight,
    required this.forDuration,
    required this.xAxisValues,
  });
}
