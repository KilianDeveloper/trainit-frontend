import 'package:trainit/data/data_provider/provider.dart';
import 'package:trainit/data/database.dart';
import 'package:trainit/data/model/body_value.dart';
import 'package:trainit/data/model/body_value_type.dart';
import 'package:trainit/data/model/dto/body_value_collection.dart';

class LocalBodyValueProvider extends Provider {
  final LocalDatabase _database = LocalDatabase.instance;

  Future<List<BodyValue>> readBodyWeight() async {
    final bodyValues = await _database.bodyValueBox.getAllAsync();
    return bodyValues
        .where((element) => element.type == BodyValueType.weight)
        .toList();
  }

  Future<List<BodyValue>> readBodyFat() async {
    final bodyValues = await _database.bodyValueBox.getAllAsync();
    return bodyValues
        .where((element) => element.type == BodyValueType.fat)
        .toList();
  }

  Future<BodyValueCollection> readAll() async {
    final all = await _database.bodyValueBox.getAllAsync();
    return BodyValueCollection(
      weightValue:
          all.where((element) => element.type == BodyValueType.weight).toList(),
      fatValue:
          all.where((element) => element.type == BodyValueType.fat).toList(),
    );
  }

  Future<void> add(BodyValue value) async {
    await _database.bodyValueBox.putAsync(value);
  }

  Future<void> addAll(List<BodyValue> value) async {
    await _database.bodyValueBox.putManyAsync(value);
  }

  Future<int> removeAll() async {
    return await _database.bodyValueBox.removeAllAsync();
  }
}
