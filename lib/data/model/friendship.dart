import 'package:instant/instant.dart';
import 'package:intl/intl.dart';
import 'package:objectbox/objectbox.dart';
import 'package:trainit/data/model/profile.dart';

@Entity()
class Friendship {
  @Id(assignable: true)
  int localId = 0;

  final String userId;
  final String username;

  final bool isMeFollowingFriendAccepted;
  final bool isFriendFollowingMeAccepted;

  @Transient()
  FriendshipState get state {
    if (isMeFollowingFriend && isFriendFollowingMe) {
      return FriendshipState.full;
    } else if (!isMeFollowingFriendAccepted &&
        isMeFollowingFriendDate != null) {
      return FriendshipState.requested;
    } else if (!isFriendFollowingMeAccepted &&
        isFriendFollowingMeDate != null) {
      return FriendshipState.requestedMe;
    } else {
      return FriendshipState.none;
    }
  }

  @Transient()
  DateTime? _isFriendFollowingMeDate;

  @Property(type: PropertyType.date)
  DateTime? get isFriendFollowingMeDate {
    return _isFriendFollowingMeDate;
  }

  @Property(type: PropertyType.date)
  set isFriendFollowingMeDate(DateTime? value) {
    _isFriendFollowingMeDate =
        value == null ? null : dateTimeToZone(zone: 'UTC', datetime: value);
  }

  @Transient()
  DateTime? _isMeFollowingFriendDate;

  @Property(type: PropertyType.date)
  DateTime? get isMeFollowingFriendDate {
    return _isMeFollowingFriendDate;
  }

  @Property(type: PropertyType.date)
  set isMeFollowingFriendDate(DateTime? value) {
    _isMeFollowingFriendDate =
        value == null ? null : dateTimeToZone(zone: 'UTC', datetime: value);
  }

  @Transient()
  bool get isFriendFollowingMe {
    return isFriendFollowingMeDate != null && isFriendFollowingMeAccepted;
  }

  @Transient()
  bool get isMeFollowingFriend {
    return isMeFollowingFriendDate != null && isMeFollowingFriendAccepted;
  }

  Friendship({
    this.localId = 0,
    required this.userId,
    required this.username,
    required DateTime? isMeFollowingFriendDate,
    required DateTime? isFriendFollowingMeDate,
    required this.isFriendFollowingMeAccepted,
    required this.isMeFollowingFriendAccepted,
  })  : _isMeFollowingFriendDate = isMeFollowingFriendDate == null
            ? null
            : dateTimeToZone(zone: 'UTC', datetime: isMeFollowingFriendDate),
        _isFriendFollowingMeDate = isFriendFollowingMeDate == null
            ? null
            : dateTimeToZone(zone: 'UTC', datetime: isFriendFollowingMeDate);

  factory Friendship.fromJson(Map<String, dynamic> json) {
    final followingSince = json["followingSince"];
    final friendIsFollowerSince = json["friendIsFollowerSince"];
    return Friendship(
      userId: json["friendId"],
      username: json["username"],
      isMeFollowingFriendAccepted: json["followingAccepted"],
      isFriendFollowingMeAccepted: json["friendIsFollowerAccepted"],
      isMeFollowingFriendDate: followingSince == null
          ? null
          : DateTime.parse(json["followingSince"]),
      isFriendFollowingMeDate: friendIsFollowerSince == null
          ? null
          : DateTime.parse(json["friendIsFollowerSince"]),
    );
  }

  DateTime? get mostRecentDate {
    if (isMeFollowingFriendDate == null) {
      return isFriendFollowingMeDate;
    } else if (isFriendFollowingMeDate == null) {
      return isMeFollowingFriendDate;
    }
    final isBefore =
        isFriendFollowingMeDate?.isBefore(isMeFollowingFriendDate!);
    return isBefore ?? false
        ? isMeFollowingFriendDate
        : isFriendFollowingMeDate;
  }

  Map<String, dynamic> toJson() {
    final dateFormat = DateFormat("yyyy-MM-ddTHH:mm:ss");
    return {
      'friendId': userId,
      'username': username,
      'followingSince': isMeFollowingFriendDate == null
          ? null
          : dateFormat.format(isMeFollowingFriendDate!),
      'friendIsFollowerSince': isFriendFollowingMeDate == null
          ? null
          : dateFormat.format(isFriendFollowingMeDate!),
      'followingAccepted': isMeFollowingFriendAccepted,
      'friendIsFollowerAccepted': isFriendFollowingMeAccepted,
    };
  }
}

class ProfileFriendship {
  final String userId;
  final String username;
  final bool isFriendFollowing;
  final bool isFollowingFriend;

  ProfileFriendship({
    required this.userId,
    required this.username,
    required this.isFriendFollowing,
    required this.isFollowingFriend,
  });

  factory ProfileFriendship.fromJson(Map<String, dynamic> json) {
    return ProfileFriendship(
      userId: json["id"],
      username: json["name"],
      isFollowingFriend: json["following"],
      isFriendFollowing: json["isFriendFollower"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': userId,
      'name': username,
      'following': isFollowingFriend,
      'isFriendFollower': isFriendFollowing,
    };
  }
}
