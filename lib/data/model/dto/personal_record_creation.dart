import 'package:trainit/data/model/personal_record_type.dart';

class PersonalRecordCreation {
  final String name;
  final double value;
  final Unit unit;

  PersonalRecordCreation({
    required this.name,
    required this.unit,
    required this.value,
  });
}
