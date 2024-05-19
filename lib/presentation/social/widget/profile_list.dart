import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:trainit/data/model/account.dart';
import 'package:trainit/data/model/dto/friendship_with_notifications.dart';
import 'package:trainit/data/model/profile.dart';
import 'package:trainit/data/model/training.dart';
import 'package:trainit/presentation/social/widget/profile_body.dart';
import 'package:trainit/presentation/social/widget/profile_header.dart';

class ProfileList extends StatelessWidget {
  final Profile profile;
  final Account account;
  final Function(Training) onTrainingClick;
  final Uint8List? profilePhoto;
  final FriendshipWithNotifications? friendship;
  final Function(String, FriendshipState) updateFriendship;
  final bool isLoadingFriendshipState;

  const ProfileList({
    super.key,
    required this.profile,
    required this.onTrainingClick,
    required this.profilePhoto,
    required this.account,
    required this.friendship,
    required this.updateFriendship,
    required this.isLoadingFriendshipState,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(children: [
        ProfileHeader(
          profile: profile,
          profilePhoto: profilePhoto,
          account: account,
          updateFriendship: updateFriendship,
          friendship: friendship,
          isLoadingFriendshipState: isLoadingFriendshipState,
        ),
        ProfileBody(
          profile: profile,
          onTrainingClick: onTrainingClick,
        ),
      ]),
    );
  }
}
