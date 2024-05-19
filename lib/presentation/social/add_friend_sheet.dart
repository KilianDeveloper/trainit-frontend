import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trainit/bloc/social/bloc.dart';
import 'package:trainit/bloc/social/state.dart';
import 'package:trainit/data/model/profile.dart';
import 'package:trainit/presentation/shared/export/bottom_sheet_page.dart';
import 'package:trainit/presentation/social/widget/add_friend_form.dart';

Future<void> showAddFriendSheet({
  required BuildContext context,
  required Function(String) searchEmail,
  required SocialBloc bloc,
  required Function(Profile, Uint8List) loadProfile,
  required Function() resetSearch,
}) async {
  return showModalBottomSheet(
    context: context,
    useRootNavigator: true,
    isDismissible: true,
    isScrollControlled: true,
    constraints: BoxConstraints(
      maxHeight: MediaQuery.of(context).size.height - 60,
      minWidth: MediaQuery.of(context).size.width,
    ),
    builder: (context) {
      return BlocBuilder<SocialBloc, SocialState>(
          bloc: bloc,
          builder: (context, state) {
            return BottomSheetPage(
              title: "Add friends",
              child: AddFriendForm(
                authenticationUser: state.authenticatedUser,
                onSearchEmailClick: searchEmail,
                searchedProfile: state.searchedProfile,
                onProfileClick: (profile, profilePhoto) {
                  loadProfile(profile, profilePhoto);
                  Navigator.pop(context);
                  resetSearch();
                },
                onHideClick: () => Navigator.pop(context),
                onResetSearchClick: resetSearch,
              ),
            );
          });
    },
  );
}
