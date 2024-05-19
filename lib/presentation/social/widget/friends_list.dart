import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:trainit/data/model/account.dart';
import 'package:trainit/data/model/dto/friendship_with_notifications.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:trainit/presentation/social/widget/friendship_item.dart';

class FriendsList extends StatefulWidget {
  final Account account;
  final List<FriendshipWithNotifications> friendships;
  final Function(String) onSelectFriendClick;
  final Function() onAddFriendClick;
  final Function(FriendshipWithNotifications) onAcceptRequestClick;

  final Map<String, Uint8List> profilePhotos;

  const FriendsList({
    super.key,
    required this.account,
    required this.friendships,
    required this.onSelectFriendClick,
    required this.profilePhotos,
    required this.onAcceptRequestClick,
    required this.onAddFriendClick,
  });

  @override
  State<FriendsList> createState() => _FriendsListState();
}

class _FriendsListState extends State<FriendsList> {
  List<FriendshipWithNotifications> get friendships => widget.friendships;
  @override
  Widget build(BuildContext context) {
    final followers =
        friendships.where((e) => e.friendship.isFriendFollowingMe).toList();
    final requesting = friendships
        .where((e) =>
            e.friendship.isFriendFollowingMeDate != null &&
            !e.friendship.isFriendFollowingMeAccepted)
        .toList();
    final following =
        friendships.where((e) => e.friendship.isMeFollowingFriend).toList();

    return DefaultTabController(
        length: 2,
        child: Column(
          children: [
            TabBar(
              dividerColor: Colors.transparent,
              tabs: [
                Tab(
                  text: AppLocalizations.of(context)!
                      .following_number(following.length),
                ),
                Tab(
                  text: AppLocalizations.of(context)!
                      .follower_number(followers.length),
                )
              ],
            ),
            Expanded(
              child: TabBarView(children: [
                _buildItems(context: context, friendships: following),
                Column(
                  children: [
                    _buildItems(
                        context: context,
                        friendships: requesting,
                        title: AppLocalizations.of(context)!
                            .requested_friends_label),
                    _buildItems(
                      context: context,
                      friendships: followers,
                      title: AppLocalizations.of(context)!.followers,
                    ),
                  ],
                ),
              ]),
            )
          ],
        ));
  }

  Widget _buildItems({
    required BuildContext context,
    String? title,
    required List<FriendshipWithNotifications> friendships,
  }) {
    if (friendships.isEmpty) {
      return const SizedBox();
    }
    final friends = friendships
        .map((e) => _buildFriendshipItem(context, e))
        .expand((element) => [element, const Divider()])
        .toList();
    friends.removeLast();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) Text(title),
        const SizedBox(height: 4),
        Card(
          margin: const EdgeInsets.fromLTRB(0, 8, 0, 8),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            child: Column(
              children: friends,
            ),
          ),
        ),
        const SizedBox(
          height: 16,
          width: double.infinity,
        ),
      ],
    );
  }

  Widget _buildFriendshipItem(
      BuildContext context, FriendshipWithNotifications friendship) {
    return FriendshipItem(
      context: context,
      friendship: friendship,
      onAcceptClick: () => widget.onAcceptRequestClick(friendship),
      profilePhoto:
          widget.profilePhotos.containsKey(friendship.friendship.userId)
              ? widget.profilePhotos[friendship.friendship.userId]
              : null,
      onSelectClick: () =>
          widget.onSelectFriendClick(friendship.friendship.userId),
    );
  }
}
