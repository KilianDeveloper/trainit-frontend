import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trainit/bloc/social/event.dart';
import 'package:trainit/bloc/social/state.dart';
import 'package:trainit/data/model/dto/friendship_with_notifications.dart';
import 'package:trainit/data/model/dto/loading_status.dart';
import 'package:trainit/data/model/profile.dart';
import 'package:trainit/data/repository/account_repository.dart';
import 'package:trainit/data/repository/authentication_repository.dart';
import 'package:trainit/data/repository/friendship_repository.dart';
import 'package:trainit/main.dart';

class SocialBloc extends Bloc<SocialEvent, SocialState> {
  final AccountRepository accountRepository;
  final FriendshipRepository friendshipRepository;
  final AuthenticationRepository authenticationRepository;

  SocialBloc({
    required this.accountRepository,
    required this.friendshipRepository,
    required this.authenticationRepository,
  }) : super(SocialState()) {
    on<NavigateProfile>(_handleNavigateProfile);
    on<LoadLocalData>(_handleLoadLocalData);
    on<NavigateTraining>(_handleNavigateTraining);
    on<PushScreen>(_handlePushScreen);
    on<PopScreen>(_handlePopScreen);
    on<SearchProfile>(_handleSearchProfile);
    on<ResetProfileSearch>(_handleResetProfileSearch);
    on<UpdateFriendship>(_handleUpdateFriendship);

    on<NavigateProfileWithData>(_handleNavigateProfileWithData);
    add(LoadLocalData());

    dataChangeBus.on<bool>().listen((event) {
      if (event == true && !isClosed) add(LoadLocalData());
    });
  }

  void _handleLoadLocalData(
      LoadLocalData event, Emitter<SocialState> emit) async {
    final friendships = (await friendshipRepository.readAllLocal())
        .map((e) =>
            FriendshipWithNotifications(friendship: e, notifications: []))
        .toList(); //TODO load notifications
    final authenticatedAccount =
        await accountRepository.readLocalAuthenticated();
    final authenticatedUser = authenticationRepository.userData;
    emit(state.copyWith(
      friendships: friendships,
      account: authenticatedAccount,
      authenticatedUser: authenticatedUser,
    ));
    final Map<String, Uint8List> profilePhotos = {};

    for (final friendship in friendships) {
      if (profilePhotos.containsKey(friendship.friendship.userId)) continue;
      final photo = await accountRepository.readRemoteProfilePhoto(
          userId: friendship.friendship.userId);
      if (photo == null) continue;
      profilePhotos[friendship.friendship.userId] = photo;
    }

    emit(state.copyWith(
      profilePhotos: profilePhotos,
    ));

    if (state.profile != null) {
      FriendshipState friendshipState = FriendshipState.none;
      final profileFriendships = friendships
          .where((element) => element.friendship.userId == state.profile!.id);
      if (profileFriendships.isNotEmpty) {
        friendshipState = profileFriendships.first.friendship.state;
      }
      final profile = state.profile!.copyWithFriendshipState(friendshipState);
      emit(state.copyWithProfile(profile));
      add(NavigateProfile(userId: state.profile!.id));
    }

    if (event.onFinish != null) {
      event.onFinish!();
    }
  }

  void _handlePushScreen(PushScreen event, Emitter<SocialState> emit) async {
    emit(
      state.copyWithInjected(
        state.injectedScreens.toList()..add(event.widget),
      ),
    );
  }

  void _handlePopScreen(PopScreen event, Emitter<SocialState> emit) async {
    emit(
      state.copyWithInjected(state.injectedScreens..removeLast()),
    );
  }

  void _handleSearchProfile(
      SearchProfile event, Emitter<SocialState> emit) async {
    emit(state.copyWith(loadingStatus: LoadingStatus.pending));
    final profile =
        await accountRepository.readRemoteProfileByEmail(email: event.email);
    emit(state.copyWithInjected([]).copyWithSearchedProfile(profile).copyWith(
          screenStatus: SocialStatus.profile,
          loadingStatus: LoadingStatus.pending,
        ));
  }

  void _handleResetProfileSearch(
      ResetProfileSearch event, Emitter<SocialState> emit) async {
    emit(state.copyWithSearchedProfile(null));
  }

  void _handleNavigateProfile(
      NavigateProfile event, Emitter<SocialState> emit) async {
    emit(state.copyWith(
      loadingAction: LoadingAction.profile,
      loadingStatus: LoadingStatus.pending,
    ));
    emit(state.copyWith(loadingStatus: LoadingStatus.pending));
    final profile =
        await accountRepository.readRemoteProfile(userId: event.userId);
    final profilePhotos = state.profilePhotos;
    if (!profilePhotos.containsKey(event.userId)) {
      final photo =
          await accountRepository.readRemoteProfilePhoto(userId: event.userId);
      if (photo != null) {
        profilePhotos[event.userId] = photo;
      }
    }
    final finishStatus =
        profile == null ? LoadingStatus.error : LoadingStatus.finished;

    emit(state.copyWithInjected([]).copyWithProfile(profile).copyWith(
          screenStatus: SocialStatus.profile,
          profilePhotos: profilePhotos,
          loadingStatus: finishStatus,
          loadingAction: LoadingAction.initial,
        ));
  }

  void _handleNavigateProfileWithData(
      NavigateProfileWithData event, Emitter<SocialState> emit) async {
    final profilePhotos = state.profilePhotos;
    profilePhotos[event.profile.id] = event.profilePhoto;

    emit(state.copyWithInjected([]).copyWithProfile(event.profile).copyWith(
          screenStatus: SocialStatus.profile,
          profilePhotos: profilePhotos,
          loadingStatus: LoadingStatus.finished,
        ));
  }

  void _handleNavigateTraining(
      NavigateTraining event, Emitter<SocialState> emit) async {
    emit(state.copyWithInjected([]).copyWithTraining(event.training).copyWith(
          screenStatus: SocialStatus.profile,
          loadingStatus: LoadingStatus.finished,
        ));
  }

  void _handleUpdateFriendship(
      UpdateFriendship event, Emitter<SocialState> emit) async {
    emit(state.copyWith(
      loadingAction: LoadingAction.friendshipState,
      loadingStatus: LoadingStatus.pending,
    ));
    final friendshipState = event.friendshipState;

    switch (friendshipState) {
      case FriendshipState.none:
        await friendshipRepository.follow(event.userId);
        break;
      case FriendshipState.requestedMe:
        await friendshipRepository.acceptFollow(event.userId);
        break;
      case FriendshipState.full:
      case FriendshipState.requested:
        await friendshipRepository.unfollow(event.userId);
        break;
    }
    add(LoadLocalData());
    emit(state.copyWith(
      loadingAction: LoadingAction.initial,
      loadingStatus: LoadingStatus.finished,
    ));
  }
}
