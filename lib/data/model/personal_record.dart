import 'package:instant/instant.dart';
import 'package:intl/intl.dart';
import 'package:objectbox/objectbox.dart';
import 'package:trainit/data/model/personal_record_type.dart';

@Entity()
class PersonalRecord {
  static const maxFavoriteCount = 2;

  @Id()
  int localId = 0;
  @Index()
  String name;
  @Property(uid: 3314971149336731331)
  double value;

  @Transient()
  Unit unit;

  String get dbType {
    return unit.toJson();
  }

  set dbType(String value) {
    unit = UnitHelpers.unitFromJson(value);
  }

  @Transient()
  DateTime _date;

  @Property(type: PropertyType.date)
  DateTime get date {
    return _date;
  }

  @Property(type: PropertyType.date)
  set date(DateTime value) {
    _date = dateTimeToZone(zone: 'UTC', datetime: value);
  }

  factory PersonalRecord.fromJson(Map<String, dynamic> json) {
    return PersonalRecord(
      name: json['name'],
      value: json['value'].toDouble(),
      date: DateTime.parse(json['date']),
      isFavorite: json['isFavorite'],
      unit: UnitHelpers.unitFromJson(json["unit"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'value': value,
      'date': DateFormat("yyyy-MM-ddTHH:mm:ss").format(date),
      'isFavorite': isFavorite,
      'unit': unit.toJson()
    };
  }

  bool isFavorite;

  PersonalRecord.byInput({
    required this.name,
    required this.value,
    required this.unit,
  })  : _date = dateTimeToZone(zone: 'UTC', datetime: DateTime.now()),
        isFavorite = false;

  PersonalRecord({
    required this.name,
    required this.value,
    required DateTime date,
    required this.isFavorite,
    this.unit = Unit.kilograms,
  }) : _date = dateTimeToZone(zone: 'UTC', datetime: date);
}
