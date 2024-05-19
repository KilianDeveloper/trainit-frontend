import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:trainit/data/model/account.dart';
import 'package:trainit/data/model/dto/friendship_with_notifications.dart';
import 'package:trainit/data/model/profile.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfileHeader extends StatelessWidget {
  final Profile profile;
  final Account account;
  final Uint8List? profilePhoto;
  final FriendshipWithNotifications? friendship;
  final Function(String, FriendshipState) updateFriendship;
  final bool isLoadingFriendshipState;

  const ProfileHeader({
    super.key,
    required this.profile,
    required this.account,
    required this.profilePhoto,
    required this.friendship,
    required this.updateFriendship,
    required this.isLoadingFriendshipState,
  });

  bool get isProfileAuthenticatedAccount => account.id == profile.id;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildProfilePhoto(context),
        const SizedBox(height: 16),
        Text(
          profile.username,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        ..._buildFollowers(context),
        const SizedBox(height: 8),
        const Divider(),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildProfilePhoto(BuildContext context) {
    return Row(
      children: [
        const Expanded(flex: 4, child: SizedBox()),
        Expanded(
          flex: 5,
          child: LayoutBuilder(builder: (context, constraint) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(constraint.maxWidth),
              child: profilePhoto != null
                  ? Image.memory(
                      profilePhoto!,
                      width: constraint.maxWidth,
                      height: constraint.maxWidth,
                      fit: BoxFit.cover,
                    )
                  : Image.asset(
                      "assets/profile.png",
                      width: constraint.maxWidth,
                      height: constraint.maxWidth,
                      fit: BoxFit.cover,
                    ),
            );
          }),
        ),
        const Expanded(flex: 4, child: SizedBox()),
      ],
    );
  }

  List<Widget> _buildFollowers(BuildContext context) {
    return [
      const SizedBox(height: 8),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text.rich(TextSpan(children: [
            TextSpan(
              text: "${profile.numOfFollowing} ",
            ),
            TextSpan(
              text: "${AppLocalizations.of(context)!.following}    ",
            ),
            TextSpan(
              text: "${profile.numOfFollowers} ",
            ),
            TextSpan(
              text: AppLocalizations.of(context)!.followers,
            )
          ]))
        ],
      ),
      const SizedBox(height: 24),
      if (!isProfileAuthenticatedAccount) _buildFollowButton(context),
    ];
  }

  Widget _buildFollowButton(BuildContext context) {
    var style = Theme.of(context).filledButtonTheme.style;
    var text = AppLocalizations.of(context)!.friends_status_none;
    var foregroundColor = Theme.of(context).colorScheme.onPrimary;

    if (friendship != null) {
      final state = friendship!.friendship.state;
      if (state == FriendshipState.full) {
        foregroundColor = Theme.of(context).colorScheme.primary;
        style = FilledButton.styleFrom(
          foregroundColor: foregroundColor,
          backgroundColor: Theme.of(context).colorScheme.background,
        );
        text = AppLocalizations.of(context)!.friends_status_full;
      } else if (state == FriendshipState.requested) {
        foregroundColor = Theme.of(context).colorScheme.primary;
        style = FilledButton.styleFrom(
          foregroundColor: foregroundColor,
          backgroundColor: Theme.of(context).colorScheme.background,
        );
        text = AppLocalizations.of(context)!.friends_status_requested;
      } else if (state == FriendshipState.requestedMe) {
        text = AppLocalizations.of(context)!.friends_status_requested_me;
      }
    }
    return FilledButton(
      style: style,
      onPressed: () {
        updateFriendship(
          profile.id,
          friendship == null
              ? FriendshipState.none
              : friendship!.friendship.state,
        );
      },
      child: !isLoadingFriendshipState
          ? Text(text)
          : SizedBox(
              height: 16,
              width: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: foregroundColor,
              ),
            ),
    );
  }
}
