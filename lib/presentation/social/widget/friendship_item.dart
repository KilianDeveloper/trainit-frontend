import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:trainit/data/model/dto/friendship_with_notifications.dart';
import 'package:trainit/data/model/profile.dart';
import 'package:trainit/helper/date.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FriendshipItem extends StatelessWidget {
  final BuildContext context;
  final Function()? onSelectClick;
  final Uint8List? profilePhoto;
  final Function()? onAcceptClick;

  final FriendshipWithNotifications friendship;

  const FriendshipItem({
    super.key,
    required this.context,
    required this.friendship,
    required this.profilePhoto,
    this.onAcceptClick,
    this.onSelectClick,
  });

  @override
  Widget build(BuildContext context) {
    Widget? action = onSelectClick != null
        ? IconButton(
            onPressed: onSelectClick,
            icon: const Icon(Icons.chevron_right_rounded),
          )
        : null;

    if (friendship.friendship.state == FriendshipState.requestedMe) {
      action = FilledButton(
        onPressed: onAcceptClick,
        child: Text(AppLocalizations.of(context)!.accept),
      );
    }
    final image = profilePhoto != null
        ? Image.memory(
            profilePhoto!,
            width: 32,
            height: 32,
            fit: BoxFit.cover,
          )
        : Image.asset(
            "assets/profile.png",
            width: 32,
            height: 32,
            fit: BoxFit.cover,
          );
    final date = friendship.friendship.mostRecentDate!;
    final dateDifference =
        date.asDate().difference(DateTime.now().asDate()).inDays.abs();
    return InkWell(
      onTap: onSelectClick,
      borderRadius: BorderRadius.circular(12),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: image,
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                friendship.friendship.username,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              if (friendship.friendship.state == FriendshipState.full)
                Text(
                  AppLocalizations.of(context)!.following_text(dateDifference),
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge
                      ?.copyWith(fontWeight: FontWeight.normal),
                )
            ],
          ),
          const Spacer(),
          if (friendship.friendship.state == FriendshipState.full)
            SizedBox(
              height: 24,
              width: 24,
              child: Stack(
                children: [
                  Icon(
                    Icons.notifications_rounded,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      height: 12,
                      width: 12,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        color: Theme.of(context).colorScheme.background,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Center(
                        child: Text(
                          friendship.notifications.length.toString(),
                          style: TextStyle(
                            fontSize: 7.5,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          if (action != null) action,
        ],
      ),
    );
  }
}
