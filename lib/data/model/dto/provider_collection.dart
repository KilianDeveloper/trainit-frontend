import 'package:trainit/data/data_provider/local_account_provider.dart';
import 'package:trainit/data/data_provider/local_body_value_provider.dart';
import 'package:trainit/data/data_provider/local_calendar_provider.dart';
import 'package:trainit/data/data_provider/local_data_provider.dart';
import 'package:trainit/data/data_provider/local_friendship_provider.dart';
import 'package:trainit/data/data_provider/local_goal_provider.dart';
import 'package:trainit/data/data_provider/local_personalrecord_provider.dart';
import 'package:trainit/data/data_provider/local_trainingplan_provider.dart';
import 'package:trainit/data/data_provider/local_tutorial_provider.dart';
import 'package:trainit/data/data_provider/remote_account_provider.dart';
import 'package:trainit/data/data_provider/remote_authentication_provider.dart';
import 'package:trainit/data/data_provider/remote_body_value_provider.dart';
import 'package:trainit/data/data_provider/remote_calendar_provider.dart';
import 'package:trainit/data/data_provider/remote_friendship_provider.dart';
import 'package:trainit/data/data_provider/remote_goal_provider.dart';
import 'package:trainit/data/data_provider/remote_personalrecord_provider.dart';
import 'package:trainit/data/data_provider/remote_trainingplan_provider.dart';

class ProviderCollection {
  final LocalAccountProvider localAccountProvider;
  final LocalCalendarProvider localCalendarProvider;
  final LocalDataProvider localDataProvider;
  final LocalPersonalRecordProvider localPersonalRecordProvider;
  final LocalTrainingPlanProvider localTrainingPlanProvider;
  final LocalTutorialProvider localTutorialProvider;
  final LocalGoalProvider localGoalProvider;
  final LocalFriendshipProvider localFriendshipProvider;
  final LocalBodyValueProvider localBodyValueProvider;
  final RemoteAccountProvider remoteAccountProvider;
  final RemoteAuthenticationProvider remoteAuthenticationProvider;
  final RemoteCalendarProvider remoteCalendarProvider;
  final RemotePersonalRecordProvider remotePersonalRecordProvider;
  final RemoteTrainingPlanProvider remoteTrainingPlanProvider;
  final RemoteGoalProvider remoteGoalProvider;
  final RemoteBodyValueProvider remoteBodyValueProvider;
  final RemoteFriendshipProvider remoteFriendshipProvider;

  ProviderCollection({
    required this.localAccountProvider,
    required this.localCalendarProvider,
    required this.localDataProvider,
    required this.localPersonalRecordProvider,
    required this.localTrainingPlanProvider,
    required this.localTutorialProvider,
    required this.remoteAccountProvider,
    required this.remoteAuthenticationProvider,
    required this.remoteCalendarProvider,
    required this.remotePersonalRecordProvider,
    required this.remoteTrainingPlanProvider,
    required this.localGoalProvider,
    required this.remoteGoalProvider,
    required this.localBodyValueProvider,
    required this.remoteBodyValueProvider,
    required this.localFriendshipProvider,
    required this.remoteFriendshipProvider,
  });
}
