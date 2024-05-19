import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trainit/bloc/social/bloc.dart';
import 'package:trainit/bloc/social/event.dart';
import 'package:trainit/bloc/social/state.dart';
import 'package:trainit/data/model/dto/loading_status.dart';
import 'package:trainit/presentation/shared/export/loading_widget.dart';
import 'package:trainit/presentation/shared/export/page.dart';
import 'package:trainit/presentation/social/export/training_screen.dart';
import 'package:trainit/presentation/social/profile_screen.dart';
import 'package:trainit/presentation/social/widget/profile_loading_error.dart';

class ExportProfileScreen extends StatelessWidget {
  final Function(Widget Function()) pushPage;
  final Function() popPage;

  const ExportProfileScreen({
    super.key,
    required this.pushPage,
    required this.popPage,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SocialBloc, SocialState>(
      builder: (context, state) {
        if (state.profile != null) {
          final friendshipList = state.friendships.where(
              (element) => element.friendship.userId == state.profile!.id);
          return ProfileScreen(
            account: state.account,
            profile: state.profile!,
            isLoadingFriendshipState:
                state.loadingAction == LoadingAction.friendshipState &&
                    state.loadingStatus == LoadingStatus.pending,
            friendship: friendshipList.isNotEmpty ? friendshipList.first : null,
            profilePhoto: state.profilePhotos.containsKey(state.profile!.id)
                ? state.profilePhotos[state.profile!.id]
                : null,
            updateFriendship: (userId, friendshipState) {
              context.read<SocialBloc>().add(UpdateFriendship(
                    friendshipState: friendshipState,
                    userId: userId,
                  ));
            },
            trainingClick: (training) {
              pushPage(
                () {
                  context
                      .read<SocialBloc>()
                      .add(NavigateTraining(training: training));
                  return ExportImmutableTrainingScreen(
                    pushPage: pushPage,
                    popPage: popPage,
                  );
                },
              );
            },
          );
        } else {
          if (state.loadingStatus == LoadingStatus.error) {
            return const ContentPage(
              title: "",
              content: ProfileLoadingError(),
            );
          }
          return const ContentPage(
            title: "",
            content: LoadingWidget(title: "Profile"),
          );
        }
      },
    );
  }
}
