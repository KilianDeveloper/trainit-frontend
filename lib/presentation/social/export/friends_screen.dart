import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trainit/bloc/social/bloc.dart';
import 'package:trainit/bloc/social/event.dart';
import 'package:trainit/bloc/social/state.dart';
import 'package:trainit/presentation/social/export/add_friend_sheet.dart';
import 'package:trainit/presentation/social/export/profile_screen.dart';
import 'package:trainit/presentation/social/friends_screen.dart';

class ExportFriendsScreen extends StatelessWidget {
  final Function(Widget Function()) pushPage;
  final Function() popPage;

  const ExportFriendsScreen({
    super.key,
    required this.pushPage,
    required this.popPage,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SocialBloc, SocialState>(
      builder: (context, state) {
        return FriendsScreen(
          account: state.account,
          profilePhotos: state.profilePhotos,
          friendships: state.friendships,
          acceptRequest: (friendship) {
            context.read<SocialBloc>().add(UpdateFriendship(
                  userId: friendship.userId,
                  friendshipState: friendship.state,
                ));
          },
          addFriend: () => showExportAddFriendSheet(
            context: context,
            loadProfileScreen: () {
              pushPage(() => ExportProfileScreen(
                    pushPage: pushPage,
                    popPage: popPage,
                  ));
            },
          ),
          selectFriend: (userId) {
            context.read<SocialBloc>().add(NavigateProfile(userId: userId));
            pushPage(() => ExportProfileScreen(
                  pushPage: pushPage,
                  popPage: popPage,
                ));
          },
        );
      },
    );
  }
}
