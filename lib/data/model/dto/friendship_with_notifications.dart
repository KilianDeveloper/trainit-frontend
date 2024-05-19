import 'package:trainit/data/model/friendship.dart';
import 'package:trainit/data/model/notification.dart';

class FriendshipWithNotifications {
  final Friendship friendship;
  final List<Notification> notifications;

  FriendshipWithNotifications({
    required this.friendship,
    required this.notifications,
  });
}
