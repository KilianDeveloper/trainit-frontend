import 'package:trainit/data/model/friendship.dart';
import 'package:trainit/data/model/goal.dart';
import 'package:trainit/data/model/personal_record.dart';
import 'package:trainit/data/model/training_plan.dart';

enum FriendshipState { requested, requestedMe, none, full }

class FriendshipStateHelpers {
  static Map<String, FriendshipState> jsonMap = {
    "r": FriendshipState.requested,
    "m": FriendshipState.requestedMe,
    "n": FriendshipState.none,
    "f": FriendshipState.full,
  };

  static FriendshipState fromJson(String json) {
    final value = jsonMap[json];
    if (value == null) throw "Json not supported";
    return value;
  }
}

extension FriendshipStateX on FriendshipState {
  String toJson() {
    return FriendshipStateHelpers.jsonMap.keys.firstWhere(
      (element) => FriendshipStateHelpers.jsonMap[element] == this,
      orElse: () => throw "BodyValueType not supported",
    );
  }
}

class Profile {
  String id;
  String username;
  bool isPublicProfile;

  List<PersonalRecord>? personalRecords;
  List<Goal>? goals;
  TrainingPlan? trainingPlan;
  List<ProfileFriendship>? friendships;
  FriendshipState friendshipState;
  int numOfFollowers;
  int numOfFollowing;

  int get numberOfFriends =>
      friendships
          ?.where((element) =>
              element.isFollowingFriend && element.isFriendFollowing)
          .length ??
      0;

  Profile({
    required this.id,
    required this.username,
    required this.isPublicProfile,
    required this.friendshipState,
    this.trainingPlan,
    this.goals,
    this.personalRecords,
    this.friendships,
    required this.numOfFollowers,
    required this.numOfFollowing,
  });

  Map toJson() {
    return {
      "username": username,
      "id": id,
      "isPublicProfile": isPublicProfile,
      "personalRecords": personalRecords?.map((e) => e.toJson()).toList(),
      "goals": goals?.map((e) => e.toJson()).toList(),
      "trainingPlan": trainingPlan?.toJson(),
      "friendshipState": friendshipState.toJson(),
      "friendships": friendships?.map((e) => e.toJson()).toList(),
      "numOfFollowers": numOfFollowers,
      "numOfFollowing": numOfFollowing,
    };
  }

  Profile copyWithFriendshipState(FriendshipState state) {
    return Profile(
      id: id,
      username: username,
      isPublicProfile: isPublicProfile,
      friendshipState: state,
      numOfFollowers: numOfFollowers,
      numOfFollowing: numOfFollowing,
    );
  }

  factory Profile.fromJson(Map<String, dynamic> json) {
    final isPublicProfile = json['isPublicProfile'];

    if (isPublicProfile) {
      return Profile(
        username: json['username'],
        id: json['id'],
        numOfFollowers: json['numOfFollowers'],
        numOfFollowing: json['numOfFollowing'],
        isPublicProfile: json['isPublicProfile'],
        personalRecords: (json["personalRecords"] as List<dynamic>)
            .map<PersonalRecord>((e) => PersonalRecord.fromJson(e))
            .toList(),
        goals: (json["goals"] as List<dynamic>)
            .map<Goal>((e) => Goal.fromJson(e))
            .toList(),
        friendshipState:
            FriendshipStateHelpers.fromJson(json["friendshipState"]),
        trainingPlan: TrainingPlan.fromJson(json["trainingPlan"]),
        friendships: (json["friendships"] as List<dynamic>)
            .map<ProfileFriendship>((e) => ProfileFriendship.fromJson(e))
            .toList(),
      );
    }
    return Profile(
      username: json['username'],
      id: json['id'],
      isPublicProfile: json['isPublicProfile'],
      personalRecords: null,
      goals: null,
      friendshipState: FriendshipStateHelpers.fromJson(json["friendshipState"]),
      trainingPlan: null,
      friendships: null,
      numOfFollowers: json['numOfFollowers'],
      numOfFollowing: json['numOfFollowing'],
    );
  }
}
