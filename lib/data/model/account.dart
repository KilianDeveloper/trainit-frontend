import 'package:instant/instant.dart';
import 'package:intl/intl.dart';
import 'package:objectbox/objectbox.dart';
import 'package:trainit/data/model/units.dart';

@Entity()
class Account {
  @Id(assignable: true)
  int localId = 0;
  @Index(type: IndexType.value)
  String id;
  String username;
  @Transient()
  WeightUnit weightUnit;

  bool isPublicProfile;
  String trainingPlanId;
  int averageSetDuration;
  int averageSetRestDuration;

  @Transient()
  DateTime _lastModified;

  @Property(type: PropertyType.date)
  DateTime get lastModified {
    return _lastModified;
  }

  @Property(type: PropertyType.date)
  set lastModified(DateTime value) {
    _lastModified = dateTimeToZone(zone: 'UTC', datetime: value);
  }

  String get dbWeightUnit {
    return weightUnit.name;
  }

  set dbWeightUnit(String value) {
    weightUnit = weightUnitFromJson(value);
  }

  Account({
    required this.id,
    required this.username,
    this.weightUnit = WeightUnit.kg,
    required this.isPublicProfile,
    required this.trainingPlanId,
    required DateTime lastModified,
    this.averageSetDuration = 90,
    this.averageSetRestDuration = 90,
  }) : _lastModified = dateTimeToZone(zone: 'UTC', datetime: lastModified);

  Map toJson() {
    return {
      "username": username,
      "id": id,
      "trainingPlanId": trainingPlanId,
      "weightUnit": weightUnitToJson(weightUnit),
      "isPublicProfile": isPublicProfile,
      "averageSetDuration": averageSetDuration,
      "averageSetRestDuration": averageSetRestDuration,
      "lastModified":
          "${DateFormat("yyyy-MM-ddTHH:mm:ss").format(lastModified)}Z",
    };
  }

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      username: json['username'],
      id: json['id'],
      trainingPlanId: json['trainingPlanId'],
      weightUnit: weightUnitFromJson(json['weightUnit']),
      isPublicProfile: json['isPublicProfile'],
      averageSetDuration: json['averageSetDuration'],
      averageSetRestDuration: json['averageSetRestDuration'],
      lastModified: DateTime.parse(json['lastModified']),
    );
  }
}
