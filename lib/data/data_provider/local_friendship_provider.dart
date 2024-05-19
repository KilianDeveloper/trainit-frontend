import 'package:trainit/data/data_provider/provider.dart';
import 'package:trainit/data/database.dart';
import 'package:trainit/data/model/friendship.dart';
import 'package:trainit/helper/logging.dart';
import 'package:trainit/objectbox.g.dart';

class LocalFriendshipProvider extends Provider {
  final LocalDatabase _database = LocalDatabase.instance;

  Future<void> removeNotContained({required List<String> userIds}) async {
    final list = _database.friendshipBox
        .getAll()
        .where((element) => !userIds.contains(element.userId))
        .map((e) => e.localId)
        .toList();

    final query = _database.friendshipBox
        .query(Friendship_.localId.notOneOf(list))
        .build();

    await query.removeAsync();
  }

  Future<List<Friendship>> readAll() async {
    return _database.friendshipBox.getAllAsync();
  }

  Future<bool> delete(String userId) async {
    try {
      final friendships = await _database.friendshipBox.getAllAsync();
      final existing = friendships.where((element) => element.userId == userId);
      if (existing.isNotEmpty) {
        for (var element in friendships) {
          _database.friendshipBox.remove(element.localId);
        }
      }
      return true;
    } catch (ex) {
      Loggers.appLogger.e(ex);
      return false;
    }
  }

  Future<bool> update(Friendship friendship) async {
    try {
      final friendships = await _database.friendshipBox.getAllAsync();
      final existing =
          friendships.where((element) => element.userId == friendship.userId);
      if (existing.isEmpty) {
        final newFriendship = Friendship(
          localId: 0,
          userId: friendship.userId,
          username: friendship.username,
          isMeFollowingFriendDate: friendship.isMeFollowingFriendDate,
          isFriendFollowingMeDate: friendship.isFriendFollowingMeDate,
          isFriendFollowingMeAccepted: friendship.isFriendFollowingMeAccepted,
          isMeFollowingFriendAccepted: friendship.isMeFollowingFriendAccepted,
        );
        await _database.friendshipBox.putAsync(
          newFriendship,
          mode: PutMode.insert,
        );
      } else {
        final newFriendship = Friendship(
          localId: friendships.first.localId,
          userId: friendship.userId,
          username: friendship.username,
          isMeFollowingFriendDate: friendship.isMeFollowingFriendDate,
          isFriendFollowingMeDate: friendship.isFriendFollowingMeDate,
          isFriendFollowingMeAccepted: friendship.isFriendFollowingMeAccepted,
          isMeFollowingFriendAccepted: friendship.isMeFollowingFriendAccepted,
        );
        await _database.friendshipBox.putAsync(
          newFriendship,
          mode: PutMode.update,
        );
      }
      return true;
    } catch (ex) {
      Loggers.appLogger.e(ex);
      return false;
    }
  }

  Future<bool> writeMany(List<Friendship> friendships) async {
    try {
      _database.friendshipBox.removeAll();
      _database.friendshipBox.putMany(friendships, mode: PutMode.insert);
      return true;
    } catch (ex) {
      Loggers.appLogger.e(ex);
      return false;
    }
  }
}
