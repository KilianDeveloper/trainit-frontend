import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trainit/bloc/social/bloc.dart';
import 'package:trainit/bloc/social/event.dart';
import 'package:trainit/presentation/social/add_friend_sheet.dart';

Future<void> showExportAddFriendSheet({
  required BuildContext context,
  required Function() loadProfileScreen,
}) async {
  return showAddFriendSheet(
    bloc: context.read<SocialBloc>(),
    context: context,
    searchEmail: (email) {
      context.read<SocialBloc>().add(SearchProfile(email: email));
    },
    resetSearch: () => context.read<SocialBloc>().add(ResetProfileSearch()),
    loadProfile: (profile, profilePhoto) {
      context.read<SocialBloc>().add(NavigateProfileWithData(
            profile: profile,
            profilePhoto: profilePhoto,
          ));
      loadProfileScreen();
    },
  );
}
