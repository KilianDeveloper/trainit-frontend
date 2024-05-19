import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:trainit/data/model/account.dart';
import 'package:trainit/data/model/dto/authentication_user.dart';
import 'package:trainit/data/model/dto/friendship_with_notifications.dart';
import 'package:trainit/data/model/dto/loading_status.dart';
import 'package:trainit/data/model/dto/searched_profile.dart';
import 'package:trainit/data/model/profile.dart';
import 'package:trainit/data/model/training.dart';
import 'package:trainit/data/model/units.dart';
import 'package:uuid/uuid.dart';

enum SocialStatus { initial, profile, training }

enum LoadingAction { profile, friendshipState, initial }

extension SocialStatusX on SocialStatus {
  bool get isInitial => this == SocialStatus.initial;
  bool get isTraining => this == SocialStatus.training;

  bool get isProfile => this == SocialStatus.profile;
}

class SocialState {
  SocialState({
    this.screenStatus = SocialStatus.initial,
    this.loadingStatus = LoadingStatus.finished,
    this.loadingAction = LoadingAction.initial,
    this.searchedProfile,
    this.profile,
    this.training,
    this.injectedScreens = const [],
    AuthenticationUser? authenticatedUser,
    Account? account,
    List<FriendshipWithNotifications>? friendships,
    Map<String, Uint8List>? profilePhotos,
  })  : account = account ??
            Account(
              id: "id",
              username: "StativJovo",
              weightUnit: WeightUnit.kg,
              isPublicProfile: false,
              trainingPlanId: const Uuid().v4(),
              lastModified: DateTime.now(),
            ),
        friendships = friendships ?? [],
        profilePhotos = profilePhotos ?? {},
        authenticatedUser = authenticatedUser ??
            AuthenticationUser(
              id: "id",
              email: "email",
              displayName: "name",
            );

  final SocialStatus screenStatus;
  final Profile? profile;
  final List<FriendshipWithNotifications> friendships;
  final Account account;
  final Map<String, Uint8List> profilePhotos;
  final SearchedProfile? searchedProfile;
  final LoadingStatus loadingStatus;
  final LoadingAction loadingAction;
  final AuthenticationUser authenticatedUser;
  final Training? training;
  final List<Widget Function()> injectedScreens;

  List<Object?> get props => [screenStatus];

  bool isProfileScreen() {
    return screenStatus.isProfile && profile != null;
  }

  bool isTrainingScreen() {
    return screenStatus.isTraining && training != null;
  }

  SocialState copyWith({
    SocialStatus? screenStatus,
    Profile? profile,
    LoadingStatus? loadingStatus,
    Map<String, Uint8List>? profilePhotos,
    Account? account,
    Training? training,
    List<FriendshipWithNotifications>? friendships,
    SearchedProfile? searchedProfile,
    AuthenticationUser? authenticatedUser,
    LoadingAction? loadingAction,
  }) {
    return SocialState(
      screenStatus: screenStatus ?? this.screenStatus,
      profile: profile ?? this.profile,
      loadingStatus: loadingStatus ?? this.loadingStatus,
      profilePhotos: profilePhotos ?? this.profilePhotos,
      account: account ?? this.account,
      friendships: friendships ?? this.friendships,
      training: training ?? this.training,
      searchedProfile: searchedProfile ?? this.searchedProfile,
      injectedScreens: injectedScreens,
      authenticatedUser: authenticatedUser ?? this.authenticatedUser,
      loadingAction: loadingAction ?? this.loadingAction,
    );
  }

  SocialState copyWithProfile(Profile? profile) {
    return SocialState(
      screenStatus: screenStatus,
      profile: profile,
      loadingStatus: loadingStatus,
      profilePhotos: profilePhotos,
      account: account,
      friendships: friendships,
      training: training,
      searchedProfile: searchedProfile,
      injectedScreens: injectedScreens,
      authenticatedUser: authenticatedUser,
      loadingAction: loadingAction,
    );
  }

  SocialState copyWithSearchedProfile(SearchedProfile? searchedProfile) {
    return SocialState(
      screenStatus: screenStatus,
      profile: profile,
      searchedProfile: searchedProfile,
      loadingStatus: loadingStatus,
      profilePhotos: profilePhotos,
      account: account,
      friendships: friendships,
      training: training,
      injectedScreens: injectedScreens,
      authenticatedUser: authenticatedUser,
      loadingAction: loadingAction,
    );
  }

  SocialState copyWithTraining(Training? training) {
    return SocialState(
      screenStatus: screenStatus,
      profile: profile,
      loadingStatus: loadingStatus,
      profilePhotos: profilePhotos,
      account: account,
      searchedProfile: searchedProfile,
      friendships: friendships,
      training: training,
      injectedScreens: injectedScreens,
      authenticatedUser: authenticatedUser,
      loadingAction: loadingAction,
    );
  }

  SocialState copyWithLoadingAction(LoadingAction action) {
    return SocialState(
      screenStatus: screenStatus,
      profile: profile,
      loadingStatus: loadingStatus,
      profilePhotos: profilePhotos,
      account: account,
      searchedProfile: searchedProfile,
      friendships: friendships,
      training: training,
      injectedScreens: injectedScreens,
      authenticatedUser: authenticatedUser,
      loadingAction: action,
    );
  }

  SocialState copyWithInjected(List<Widget Function()> injectedScreens) {
    return SocialState(
      screenStatus: screenStatus,
      profile: profile,
      loadingStatus: loadingStatus,
      profilePhotos: profilePhotos,
      account: account,
      searchedProfile: searchedProfile,
      friendships: friendships,
      training: training,
      injectedScreens: injectedScreens,
      authenticatedUser: authenticatedUser,
      loadingAction: loadingAction,
    );
  }
}
