import 'package:trainit/data/model/friendship.dart';

class FollowingStatusResult {
  final bool success;
  final Friendship? friendship;
  FollowingStatusResult({
    required this.success,
    required this.friendship,
  });

  factory FollowingStatusResult.fromJson(Map<String, dynamic> json) {
    return FollowingStatusResult(
      success: json['success'],
      friendship: json["friendship"] == null
          ? null
          : Friendship.fromJson(json["friendship"]),
    );
  }
}
