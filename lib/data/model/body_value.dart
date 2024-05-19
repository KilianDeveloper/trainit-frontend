import 'package:intl/intl.dart';
import 'package:objectbox/objectbox.dart';
import 'package:trainit/data/model/body_value_type.dart';

@Entity()
class BodyValue {
  @Id()
  int localId = 0;

  @Transient()
  BodyValueType type;

  double value;

  @Index()
  @Property(type: PropertyType.date)
  DateTime date;

  @Transient()
  int get index {
    return int.parse(DateFormat("yyyyMMdd").format(date));
  }

  String get dbType {
    return type.toJson();
  }

  set dbType(String value) {
    type = BodyValueTypeHelpers.fromJson(value);
  }

  factory BodyValue.fromJson(BodyValueType type, Map<String, dynamic> json) {
    return BodyValue(
      value: json["value"].toDouble(),
      date: DateTime.parse(json['date']),
      type: type,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'value': value,
      'date': DateFormat("yyyy-MM-dd").format(date),
    };
  }

  BodyValue({
    this.localId = 0,
    required this.value,
    required this.date,
    this.type = BodyValueType.weight,
  });
}
