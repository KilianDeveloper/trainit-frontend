import 'dart:convert';

import 'package:trainit/data/model/training.dart';

class TrainingDays {
  final List<Training> monday;
  final List<Training> tuesday;
  final List<Training> wednesday;
  final List<Training> thursday;
  final List<Training> friday;
  final List<Training> saturday;
  final List<Training> sunday;

  const TrainingDays({
    required this.monday,
    required this.tuesday,
    required this.wednesday,
    required this.thursday,
    required this.friday,
    required this.saturday,
    required this.sunday,
  });

  const TrainingDays.empty()
      : monday = const [],
        tuesday = const [],
        wednesday = const [],
        thursday = const [],
        friday = const [],
        saturday = const [],
        sunday = const [];

  //Helper
  List<Map> _encodeList(List<Training> list) {
    return list.map<Map>((e) => e.toJson()).toList();
  }

  Training _mapById(
      String requiredId, String foundId, Training newValue, Training oldValue) {
    if (requiredId == foundId) {
      return newValue;
    } else {
      return oldValue;
    }
  }

  List<Training> _replaceElementIfExists(
    List<Training> list,
    String searchedId,
    Training value,
  ) {
    return list.map((e) => _mapById(searchedId, e.id, value, e)).toList();
  }

  List<Training> _deleteElementIfExists(
    List<Training> list,
    String searchedId,
  ) {
    return list.where((e) => e.id != searchedId).toList();
  }

  //En/Decoding
  factory TrainingDays.fromJson(Map<String, dynamic> json) {
    parse(array) => array
        .map<Training>(
            (e) => Training.fromJson(e is String ? jsonDecode(e) : e))
        .toList();

    return TrainingDays(
      monday: parse(json['monday']),
      tuesday: parse(json['tuesday']),
      wednesday: parse(json['wednesday']),
      thursday: parse(json['thursday']),
      friday: parse(json['friday']),
      saturday: parse(json['saturday']),
      sunday: parse(json['sunday']),
    );
  }

  Map toJson() {
    return {
      'monday': _encodeList(monday),
      'tuesday': _encodeList(tuesday),
      'wednesday': _encodeList(wednesday),
      'thursday': _encodeList(thursday),
      'friday': _encodeList(friday),
      'saturday': _encodeList(saturday),
      'sunday': _encodeList(sunday),
    };
  }

  //Data Conversion
  Map<String, bool> get activeDays {
    return {
      "M": monday.isNotEmpty,
      "Tu": tuesday.isNotEmpty,
      "W": wednesday.isNotEmpty,
      "Th": thursday.isNotEmpty,
      "F": friday.isNotEmpty,
      "Sa": saturday.isNotEmpty,
      "Su": sunday.isNotEmpty,
    };
  }

  List<Training> atIndex(int index) {
    switch (index) {
      case 0:
        return monday;
      case 1:
        return tuesday;
      case 2:
        return wednesday;
      case 3:
        return thursday;
      case 4:
        return friday;
      case 5:
        return saturday;
      case 6:
        return sunday;
      default:
        throw "Only index 0-6 is allowed";
    }
  }

  bool isIndexActive(int index) {
    switch (index) {
      case 0:
        return monday.isNotEmpty;
      case 1:
        return tuesday.isNotEmpty;
      case 2:
        return wednesday.isNotEmpty;
      case 3:
        return thursday.isNotEmpty;
      case 4:
        return friday.isNotEmpty;
      case 5:
        return saturday.isNotEmpty;
      case 6:
        return sunday.isNotEmpty;
      default:
        throw "Only index 0-6 is allowed";
    }
  }

  int get count {
    return monday.length +
        tuesday.length +
        wednesday.length +
        thursday.length +
        friday.length +
        saturday.length +
        sunday.length;
  }

  List<Training?> combineWithPlaceHolder() {
    return [
      null,
      ...monday,
      null,
      ...tuesday,
      null,
      ...wednesday,
      null,
      ...thursday,
      null,
      ...friday,
      null,
      ...saturday,
      null,
      ...sunday,
    ];
  }

  TrainingDays copyWithReplaced({required String id, required Training value}) {
    return TrainingDays(
      monday: _replaceElementIfExists(monday, id, value),
      tuesday: _replaceElementIfExists(tuesday, id, value),
      wednesday: _replaceElementIfExists(wednesday, id, value),
      thursday: _replaceElementIfExists(thursday, id, value),
      friday: _replaceElementIfExists(friday, id, value),
      saturday: _replaceElementIfExists(saturday, id, value),
      sunday: _replaceElementIfExists(sunday, id, value),
    );
  }

  TrainingDays copyWithDeleted({required String id}) {
    return TrainingDays(
      monday: _deleteElementIfExists(monday, id),
      tuesday: _deleteElementIfExists(tuesday, id),
      wednesday: _deleteElementIfExists(wednesday, id),
      thursday: _deleteElementIfExists(thursday, id),
      friday: _deleteElementIfExists(friday, id),
      saturday: _deleteElementIfExists(saturday, id),
      sunday: _deleteElementIfExists(sunday, id),
    );
  }

  //Data Changing
  TrainingDays copyWithMoved(
      {required Training training, required int toIndex}) {
    final nMonday = monday.toList();
    final nTuesday = tuesday.toList();
    final nWednesday = wednesday.toList();
    final nThursday = thursday.toList();
    final nFriday = friday.toList();
    final nSaturday = saturday.toList();
    final nSunday = sunday.toList();

    nMonday.removeWhere((element) => element.id == training.id);
    nTuesday.removeWhere((element) => element.id == training.id);
    nWednesday.removeWhere((element) => element.id == training.id);
    nThursday.removeWhere((element) => element.id == training.id);
    nFriday.removeWhere((element) => element.id == training.id);
    nSaturday.removeWhere((element) => element.id == training.id);
    nSunday.removeWhere((element) => element.id == training.id);

    switch (toIndex) {
      case 0:
        nMonday.add(training);
        break;
      case 1:
        nTuesday.add(training);
        break;
      case 2:
        nWednesday.add(training);
        break;
      case 3:
        nThursday.add(training);
        break;
      case 4:
        nFriday.add(training);
        break;
      case 5:
        nSaturday.add(training);
        break;
      case 6:
        nSunday.add(training);
        break;
      default:
        throw "Index out of bounds";
    }

    return TrainingDays(
      monday: nMonday,
      tuesday: nTuesday,
      wednesday: nWednesday,
      thursday: nThursday,
      friday: nFriday,
      saturday: nSaturday,
      sunday: nSunday,
    );
  }

  TrainingDays copyWithNew(int index, {Training? training}) {
    var nMonday = monday.toList();
    final t = training ?? Training.empty();
    nMonday.add(t);
    return TrainingDays(
      monday: nMonday,
      tuesday: tuesday,
      wednesday: wednesday,
      thursday: thursday,
      friday: friday,
      saturday: saturday,
      sunday: sunday,
    ).copyWithMoved(
      training: t,
      toIndex: index,
    );
  }
}
