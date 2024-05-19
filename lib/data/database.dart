import 'package:trainit/data/datasource.dart';
import 'package:trainit/data/model/account.dart';
import 'package:trainit/data/model/body_value.dart';
import 'package:trainit/data/model/calendar.dart';
import 'package:trainit/data/model/friendship.dart';
import 'package:trainit/data/model/goal.dart';
import 'package:trainit/data/model/personal_record.dart';
import 'package:trainit/data/model/training_plan.dart';
import 'package:trainit/objectbox.g.dart';

class LocalDatabase extends LocalDataSource {
  // ignore: unused_field
  late Store? _store;

  late Box<Account>? _accountBox;
  late Box<WeekCalendar>? _calendarBox;
  late Box<TrainingPlan>? _trainingPlanBox;
  late Box<PersonalRecord>? _personalRecordBox;
  late Box<Goal>? _goalBox;
  late Box<BodyValue>? _bodyValueBox;
  late Box<Friendship>? _friendshipBox;

  Box<Account> get accountBox {
    while (!_synched) {}
    return _accountBox!;
  }

  Box<WeekCalendar> get calendarBox {
    while (!_synched) {}
    return _calendarBox!;
  }

  Box<TrainingPlan> get trainingPlanBox {
    while (!_synched) {}
    return _trainingPlanBox!;
  }

  Box<PersonalRecord> get personalRecordBox {
    while (!_synched) {}
    return _personalRecordBox!;
  }

  Box<Goal> get goalBox {
    while (!_synched) {}
    return _goalBox!;
  }

  Box<BodyValue> get bodyValueBox {
    while (!_synched) {}
    return _bodyValueBox!;
  }

  Box<Friendship> get friendshipBox {
    while (!_synched) {}
    return _friendshipBox!;
  }

  bool _synched = false;

  LocalDatabase._create() {
    openStore().then((value) {
      _store = value;
      _accountBox = Box<Account>(value);
      _calendarBox = Box<WeekCalendar>(value);
      _trainingPlanBox = Box<TrainingPlan>(value);
      _personalRecordBox = Box<PersonalRecord>(value);
      _goalBox = Box<Goal>(value);
      _bodyValueBox = Box<BodyValue>(value);
      _friendshipBox = Box<Friendship>(value);

      _synched = true;
    });
  }

  static LocalDatabase? _instance;

  static LocalDatabase get instance {
    _instance ??= LocalDatabase._create();
    return _instance!;
  }

  static void recreateInstance() {
    _instance ??= LocalDatabase._create();
  }

  @override
  Future<void> deleteAll() async {
    await _accountBox?.removeAllAsync();
    await _calendarBox?.removeAllAsync();
    await _trainingPlanBox?.removeAllAsync();
    await _personalRecordBox?.removeAllAsync();
    await _bodyValueBox?.removeAllAsync();
    await _goalBox?.removeAllAsync();
    await _friendshipBox?.removeAllAsync();
  }
}
