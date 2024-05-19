import 'package:trainit/data/model/body_value.dart';
import 'package:trainit/data/model/body_value_type.dart';

class PutBodyValues {
  final BodyValue value;

  PutBodyValues({
    required this.value,
  });

  Map<String, dynamic> toJson() {
    return {
      ...value.toJson(),
      "type": value.type.toJson(),
    };
  }
}
