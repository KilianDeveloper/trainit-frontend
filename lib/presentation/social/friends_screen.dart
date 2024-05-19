import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:trainit/data/model/account.dart';
import 'package:trainit/data/model/dto/friendship_with_notifications.dart';
import 'package:trainit/data/model/friendship.dart';
import 'package:trainit/presentation/shared/export/page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:trainit/presentation/social/widget/friends_list.dart';

class FriendsScreen extends StatelessWidget {
  final Account account;
  final List<FriendshipWithNotifications> friendships;
  final Map<String, Uint8List> profilePhotos;
  final Function(String) selectFriend;
  final Function(Friendship) acceptRequest;
  final Function() addFriend;

  const FriendsScreen({
    super.key,
    required this.account,
    required this.friendships,
    required this.selectFriend,
    required this.profilePhotos,
    required this.acceptRequest,
    required this.addFriend,
  });

  @override
  Widget build(BuildContext context) {
    return ContentPage(
      title: AppLocalizations.of(context)!.friends_title,
      content: FriendsList(
        account: account,
        friendships: friendships,
        profilePhotos: profilePhotos,
        onSelectFriendClick: selectFriend,
        onAcceptRequestClick: (p0) {
          acceptRequest(p0.friendship);
        },
        onAddFriendClick: addFriend,
      ),
    );
  }
}
