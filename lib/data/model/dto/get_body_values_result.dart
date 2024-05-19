import 'package:trainit/data/model/dto/body_value_collection.dart';

class GetBodyValueResult {
  BodyValueCollection? values;
  bool success;

  GetBodyValueResult({
    required this.success,
    required this.values,
  });

  factory GetBodyValueResult.fromJson(Map<String, dynamic> json) {
    return GetBodyValueResult(
      values: BodyValueCollection.fromJson(json),
      success: json['success'],
    );
  }
}
