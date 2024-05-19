import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:trainit/data/model/account.dart';
import 'package:trainit/data/model/dto/friendship_with_notifications.dart';
import 'package:trainit/data/model/profile.dart';
import 'package:trainit/data/model/training.dart';
import 'package:trainit/presentation/shared/export/page.dart';
import 'package:trainit/presentation/social/widget/profile_list.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfileScreen extends StatelessWidget {
  final Profile profile;
  final Account account;
  final bool isLoadingFriendshipState;
  final Uint8List? profilePhoto;
  final FriendshipWithNotifications? friendship;
  final Function(Training) trainingClick;
  final Function(String, FriendshipState) updateFriendship;

  const ProfileScreen({
    super.key,
    required this.profile,
    required this.trainingClick,
    required this.profilePhoto,
    required this.account,
    required this.updateFriendship,
    required this.isLoadingFriendshipState,
    required this.friendship,
  });

  @override
  Widget build(BuildContext context) {
    return ContentPage(
      title: AppLocalizations.of(context)!.profile,
      content: ProfileList(
        profile: profile,
        profilePhoto: profilePhoto,
        onTrainingClick: trainingClick,
        isLoadingFriendshipState: isLoadingFriendshipState,
        account: account,
        friendship: friendship,
        updateFriendship: updateFriendship,
      ),
    );
  }
}
