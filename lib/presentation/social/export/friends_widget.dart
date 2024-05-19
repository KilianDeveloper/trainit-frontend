import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trainit/bloc/social/bloc.dart';
import 'package:trainit/bloc/social/state.dart';
import 'package:trainit/presentation/social/export/add_friend_sheet.dart';
import 'package:trainit/presentation/social/widget/friends_section.dart';

class ExportFriendsWidget extends StatelessWidget {
  final Function() onShowFriendListClick;
  final Function() onLoadProfileClick;

  const ExportFriendsWidget({
    super.key,
    required this.onShowFriendListClick,
    required this.onLoadProfileClick,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SocialBloc, SocialState>(
      builder: (context, state) {
        return FriendsSection(
          friends: state.friendships,
          onShowFriendListClick: onShowFriendListClick,
          onAddFriendClick: () => showExportAddFriendSheet(
            context: context,
            loadProfileScreen: onLoadProfileClick,
          ),
        );
      },
    );
  }
}
