import 'package:trainit/data/data_provider/local_friendship_provider.dart';
import 'package:trainit/data/data_provider/remote_authentication_provider.dart';
import 'package:trainit/data/data_provider/remote_friendship_provider.dart';
import 'package:trainit/data/model/friendship.dart';

class FriendshipRepository {
  final LocalFriendshipProvider _localProvider;
  final RemoteFriendshipProvider _remoteProvider;
  final RemoteAuthenticationProvider _authProvider;

  FriendshipRepository({
    RemoteAuthenticationProvider? authProvider,
    LocalFriendshipProvider? localProvider,
    RemoteFriendshipProvider? remoteProvider,
  })  : _authProvider = authProvider ?? RemoteAuthenticationProvider(),
        _localProvider = localProvider ?? LocalFriendshipProvider(),
        _remoteProvider = remoteProvider ?? RemoteFriendshipProvider();

  Future<List<Friendship>> readAllLocal() async {
    return await _localProvider.readAll();
  }

  Future<bool> writeManyLocal(List<Friendship> friendships) async {
    return await _localProvider.writeMany(friendships);
  }

  Future<bool> writeAllLocal(List<Friendship> friendships) async {
    await _localProvider.removeNotContained(
      userIds: friendships.map((e) => e.userId).toList(),
    );
    return await _localProvider.writeMany(friendships);
  }

  Future<bool> follow(String userId) async {
    final authToken = await _authProvider.getUserToken();
    if (authToken == null) return false;
    final result = await _remoteProvider.follow(
      userId: userId,
      authToken: authToken,
    );

    if (result.success && result.friendship != null) {
      await _localProvider.update(result.friendship!);
    } else if (result.success) {
      await _localProvider.delete(userId);
    }

    return result.success;
  }

  Future<bool> acceptFollow(String userId) async {
    final authToken = await _authProvider.getUserToken();
    if (authToken == null) return false;
    final result = await _remoteProvider.acceptFollow(
      userId: userId,
      authToken: authToken,
    );

    if (result.success && result.friendship != null) {
      await _localProvider.update(result.friendship!);
    } else if (result.success) {
      await _localProvider.delete(userId);
    }

    return result.success;
  }

  Future<bool> unfollow(String userId) async {
    final authToken = await _authProvider.getUserToken();
    if (authToken == null) return false;
    final result = await _remoteProvider.unfollow(
      userId: userId,
      authToken: authToken,
    );
    if (result.success && result.friendship != null) {
      await _localProvider.update(result.friendship!);
    } else if (result.success) {
      await _localProvider.delete(userId);
    }

    return result.success;
  }
}
