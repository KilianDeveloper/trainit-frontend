import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trainit/bloc/settings/bloc.dart';
import 'package:trainit/bloc/settings/event.dart';
import 'package:trainit/bloc/social/bloc.dart';
import 'package:trainit/bloc/social/event.dart';
import 'package:trainit/bloc/social/state.dart';
import 'package:trainit/data/model/dto/friendship_with_notifications.dart';
import 'package:trainit/data/model/dto/loading_status.dart';
import 'package:trainit/presentation/shared/export/loading_indicator.dart';
import 'package:trainit/presentation/shared/export/loading_widget.dart';
import 'package:trainit/presentation/shared/export/page.dart';
import 'package:trainit/presentation/social/profile_screen.dart';
import 'package:trainit/presentation/social/training_screen.dart';
import 'package:trainit/presentation/social/widget/profile_loading_error.dart';
import 'package:trainit/presentation/social/widget/training_loading_error.dart';

GlobalKey<NavigatorState> socialNavigatorKey = GlobalKey<NavigatorState>();

class MainSocialScreen extends StatefulWidget {
  const MainSocialScreen({super.key});

  @override
  State<MainSocialScreen> createState() => _MainSettingsScreenState();
}

class _MainSettingsScreenState extends State<MainSocialScreen> {
  @override
  void initState() {
    context.read<SettingsBloc>().add(ResetScreenStatus());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildNavigator(context);
  }

  Widget _buildNavigator(BuildContext context) {
    return BlocBuilder<SocialBloc, SocialState>(
      builder: (c, state) {
        final injectedScreens =
            state.injectedScreens.map((e) => MaterialPage(child: e()));
        return Stack(
          children: [
            Navigator(
              key: socialNavigatorKey,
              pages: [
                if (state.screenStatus.isInitial || !state.isProfileScreen())
                  _buildPlaceholder(context, state),
                if (state.isProfileScreen())
                  _buildProfileScreen(context, state),
                if (state.isTrainingScreen())
                  _buildTrainingScreen(context, state),
                ...injectedScreens
              ],
              onPopPage: (route, result) {
                context.read<SettingsBloc>().add(NavigateBack());
                return route.didPop(result);
              },
            ),
            Align(
              alignment: Alignment.center,
              child: LoadingIndicator(
                  isLoading: state.loadingStatus == LoadingStatus.pending),
            )
          ],
        );
      },
    );
  }

  MaterialPage _buildPlaceholder(BuildContext context, SocialState state) {
    return const MaterialPage(
      child: SizedBox(),
    );
  }

  MaterialPage _buildProfileScreen(BuildContext context, SocialState state) {
    FriendshipWithNotifications? friendship;
    if (state.friendships.any(
      (element) => element.friendship.userId == state.profile!.id,
    )) {
      friendship = state.friendships.firstWhere(
        (element) => element.friendship.userId == state.profile!.id,
      );
    }
    if (state.profile != null) {
      return MaterialPage(
        child: ProfileScreen(
          account: state.account,
          profile: state.profile!,
          friendship: friendship,
          isLoadingFriendshipState:
              state.loadingAction == LoadingAction.friendshipState &&
                  state.loadingStatus == LoadingStatus.pending,
          profilePhoto: state.profilePhotos.containsKey(state.profile!.id)
              ? state.profilePhotos[state.profile!.id]
              : null,
          trainingClick: (training) => context.read<SocialBloc>().add(
                NavigateTraining(training: training),
              ),
          updateFriendship: (userId, friendshipState) {
            context.read<SocialBloc>().add(UpdateFriendship(
                  friendshipState: friendshipState,
                  userId: userId,
                ));
          },
        ),
      );
    } else {
      if (state.loadingStatus == LoadingStatus.error) {
        return const MaterialPage(
            child: ContentPage(
          title: "",
          content: ProfileLoadingError(),
        ));
      }
      return const MaterialPage(
          child: ContentPage(
        title: "",
        content: LoadingWidget(title: "Profile"),
      ));
    }
  }

  MaterialPage _buildTrainingScreen(BuildContext context, SocialState state) {
    if (state.training != null) {
      return MaterialPage(
        child: TrainingScreen(
          account: state.account,
          training: state.training!,
        ),
      );
    } else {
      if (state.loadingStatus == LoadingStatus.error) {
        return const MaterialPage(
            child: ContentPage(
          title: "",
          content: TrainingLoadingError(),
        ));
      }
      return const MaterialPage(
          child: ContentPage(
        title: "",
        content: LoadingWidget(title: "Training"),
      ));
    }
  }
}
