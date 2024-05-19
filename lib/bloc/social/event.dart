import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:trainit/data/model/profile.dart';
import 'package:trainit/data/model/training.dart';

class SocialEvent {
  List<Object?> get props => [];
}

class LoadLocalData extends SocialEvent {
  final Function()? onFinish;
  LoadLocalData({this.onFinish});
  @override
  List<Object?> get props => [];
}

class SearchProfile extends SocialEvent {
  SearchProfile({
    required this.email,
  });

  final String email;

  @override
  List<Object?> get props => [];
}

class NavigateProfile extends SocialEvent {
  NavigateProfile({
    required this.userId,
  });

  final String userId;

  @override
  List<Object?> get props => [];
}

class NavigateProfileWithData extends SocialEvent {
  NavigateProfileWithData({
    required this.profile,
    required this.profilePhoto,
  });

  final Profile profile;
  final Uint8List profilePhoto;

  @override
  List<Object?> get props => [];
}

class UpdateFriendship extends SocialEvent {
  UpdateFriendship({
    required this.friendshipState,
    required this.userId,
  });

  final FriendshipState friendshipState;
  final String userId;

  @override
  List<Object?> get props => [];
}

class ResetProfileSearch extends SocialEvent {
  ResetProfileSearch();

  @override
  List<Object?> get props => [];
}

class NavigateTraining extends SocialEvent {
  NavigateTraining({
    required this.training,
  });

  final Training training;

  @override
  List<Object?> get props => [];
}

class PushScreen extends SocialEvent {
  final Widget Function() widget;
  PushScreen({required this.widget});
  @override
  List<Object?> get props => [];
}

class PopScreen extends SocialEvent {
  PopScreen();
  @override
  List<Object?> get props => [];
}
