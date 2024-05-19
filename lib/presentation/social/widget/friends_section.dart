import 'package:flutter/material.dart';
import 'package:trainit/data/model/dto/friendship_with_notifications.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FriendsSection extends StatelessWidget {
  final List<FriendshipWithNotifications> friends;
  final Function() onShowFriendListClick;
  final Function() onAddFriendClick;
  const FriendsSection({
    super.key,
    required this.friends,
    required this.onShowFriendListClick,
    required this.onAddFriendClick,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text.rich(TextSpan(children: [
          TextSpan(
            text:
                "${friends.where((element) => element.friendship.isMeFollowingFriend).length} ",
          ),
          TextSpan(
            text: "${AppLocalizations.of(context)!.following}    ",
          ),
          TextSpan(
            text:
                "${friends.where((element) => element.friendship.isFriendFollowingMe).length} ",
          ),
          TextSpan(
            text: AppLocalizations.of(context)!.followers,
          )
        ])),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _buildBottomButton(context),
        )
      ],
    );
  }

  List<Widget> _buildBottomButton(BuildContext context) {
    return [
      FilledButton(
        onPressed: onShowFriendListClick,
        style: FilledButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.onSecondary,
            backgroundColor: Theme.of(context).colorScheme.secondary),
        child: Text(AppLocalizations.of(context)!.view_friends),
      ),
      const SizedBox(width: 12),
      FilledButton(
        onPressed: onAddFriendClick,
        child: Text(AppLocalizations.of(context)!.add_friends),
      ),
    ];
  }
}
