import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trainit/bloc/authentication/bloc.dart';
import 'package:trainit/bloc/calendar/bloc.dart';
import 'package:trainit/bloc/data/cubit.dart';
import 'package:trainit/bloc/navigation/bloc.dart';
import 'package:trainit/bloc/settings/bloc.dart';
import 'package:trainit/bloc/social/bloc.dart';
import 'package:trainit/bloc/statistics/bloc.dart';
import 'package:trainit/bloc/tutorial/bloc.dart';
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
import 'package:trainit/data/model/dto/error.dart';
import 'package:trainit/data/model/dto/provider_collection.dart';
import 'package:trainit/data/repository/account_repository.dart';
import 'package:trainit/data/repository/authentication_repository.dart';
import 'package:trainit/data/repository/body_value_repository.dart';
import 'package:trainit/data/repository/calendar_repository.dart';
import 'package:trainit/data/repository/friendship_repository.dart';
import 'package:trainit/data/repository/goal_repository.dart';
import 'package:trainit/data/repository/local_data_repository.dart';
import 'package:trainit/data/repository/personalrecord_repository.dart';
import 'package:trainit/data/repository/trainingplan_repository.dart';
import 'package:trainit/data/repository/tutorial_repository.dart';

class BaseBlocProvider extends StatefulWidget {
  final Widget child;
  final Function(DataSourceError)? onError;
  const BaseBlocProvider({
    super.key,
    required this.child,
    this.onError,
  });

  @override
  State<BaseBlocProvider> createState() => _BaseBlocProviderState();
}

class _BaseBlocProviderState extends State<BaseBlocProvider> {
  ProviderCollection? providers;
  final List<RepositoryProvider> _repositories = [];

  @override
  void initState() {
    setState(() {
      providers = ProviderCollection(
        localAccountProvider: LocalAccountProvider(),
        localCalendarProvider: LocalCalendarProvider(),
        localDataProvider: LocalDataProvider(),
        localPersonalRecordProvider: LocalPersonalRecordProvider(),
        localTrainingPlanProvider: LocalTrainingPlanProvider(),
        localTutorialProvider: LocalTutorialProvider(),
        localGoalProvider: LocalGoalProvider(),
        localBodyValueProvider: LocalBodyValueProvider(),
        localFriendshipProvider: LocalFriendshipProvider(),
        remoteAccountProvider: RemoteAccountProvider(onError: widget.onError),
        remoteAuthenticationProvider:
            RemoteAuthenticationProvider(onError: widget.onError),
        remoteCalendarProvider: RemoteCalendarProvider(onError: widget.onError),
        remotePersonalRecordProvider:
            RemotePersonalRecordProvider(onError: widget.onError),
        remoteTrainingPlanProvider:
            RemoteTrainingPlanProvider(onError: widget.onError),
        remoteGoalProvider: RemoteGoalProvider(onError: widget.onError),
        remoteBodyValueProvider:
            RemoteBodyValueProvider(onError: widget.onError),
        remoteFriendshipProvider: RemoteFriendshipProvider(),
      );
      _repositories.addAll([
        RepositoryProvider<AuthenticationRepository>(
          create: (context) => AuthenticationRepository(
            provider: providers!.remoteAuthenticationProvider,
          ),
        ),
        RepositoryProvider<GoalRepository>(
          create: (context) => GoalRepository(
            authProvider: providers!.remoteAuthenticationProvider,
            localProvider: providers!.localGoalProvider,
            remoteProvider: providers!.remoteGoalProvider,
          ),
        ),
        RepositoryProvider<FriendshipRepository>(
          create: (context) => FriendshipRepository(
            authProvider: providers!.remoteAuthenticationProvider,
            localProvider: providers!.localFriendshipProvider,
            remoteProvider: providers!.remoteFriendshipProvider,
          ),
        ),
        RepositoryProvider<AccountRepository>(
          create: (context) => AccountRepository(
            authProvider: providers!.remoteAuthenticationProvider,
            localProvider: providers!.localAccountProvider,
            remoteProvider: providers!.remoteAccountProvider,
          ),
        ),
        RepositoryProvider<CalendarRepository>(
          create: (context) => CalendarRepository(
            authProvider: providers!.remoteAuthenticationProvider,
            localProvider: providers!.localCalendarProvider,
            remoteProvider: providers!.remoteCalendarProvider,
          ),
        ),
        RepositoryProvider<LocalDataRepository>(
          create: (context) => LocalDataRepository(
            provider: providers!.localDataProvider,
          ),
        ),
        RepositoryProvider<PersonalRecordRepository>(
          create: (context) => PersonalRecordRepository(
            authProvider: providers!.remoteAuthenticationProvider,
            localProvider: providers!.localPersonalRecordProvider,
            remoteProvider: providers!.remotePersonalRecordProvider,
          ),
        ),
        RepositoryProvider<TrainingPlanRepository>(
          create: (context) => TrainingPlanRepository(
            authProvider: providers!.remoteAuthenticationProvider,
            localProvider: providers!.localTrainingPlanProvider,
            remoteProvider: providers!.remoteTrainingPlanProvider,
          ),
        ),
        RepositoryProvider<BodyValueRepository>(
          create: (context) => BodyValueRepository(
            authProvider: providers!.remoteAuthenticationProvider,
            localProvider: providers!.localBodyValueProvider,
            remoteProvider: providers!.remoteBodyValueProvider,
          ),
        ),
        RepositoryProvider<TutorialRepository>(
          create: (context) => TutorialRepository(
            provider: providers!.localTutorialProvider,
          ),
        ),
      ]);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildRepositories(context: context);
  }

  Widget _buildBloc({
    required BuildContext context,
  }) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthenticationBloc(
            authenticationRepository: context.read<AuthenticationRepository>(),
          ),
        ),
        BlocProvider(
          create: (context) => NavigationBloc(),
        ),
        BlocProvider(
          create: (context) => DataCubit(
            accountRepository: context.read<AccountRepository>(),
            calendarRepository: context.read<CalendarRepository>(),
            personalRecordRepository: context.read<PersonalRecordRepository>(),
            trainingPlanRepository: context.read<TrainingPlanRepository>(),
            authenticationRepository: context.read<AuthenticationRepository>(),
            goalRepository: context.read<GoalRepository>(),
            bodyValueRepository: context.read<BodyValueRepository>(),
            friendshipRepository: context.read<FriendshipRepository>(),
          ),
        )
      ],
      child: widget.child,
    );
  }

  Widget _buildRepositories({
    required BuildContext context,
  }) {
    return MultiRepositoryProvider(
      providers: _repositories,
      child: _buildBloc(
        context: context,
      ),
    );
  }
}

class AuthenticatedBlocProvider extends StatelessWidget {
  final Widget child;
  const AuthenticatedBlocProvider({super.key, required this.child});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => StatisticsBloc(
            accountRepository: context.read<AccountRepository>(),
            personalRecordRepository: context.read<PersonalRecordRepository>(),
            goalRepository: context.read<GoalRepository>(),
            bodyValueRepository: context.read<BodyValueRepository>(),
          ),
        ),
        BlocProvider<CalendarBloc>(
          create: (context) => CalendarBloc(
            calendarRepository: context.read<CalendarRepository>(),
            accountRepository: context.read<AccountRepository>(),
          ),
        ),
        BlocProvider(
          create: (context) => SocialBloc(
            accountRepository: context.read<AccountRepository>(),
            friendshipRepository: context.read<FriendshipRepository>(),
            authenticationRepository: context.read<AuthenticationRepository>(),
          ),
        ),
        BlocProvider(
          create: (context) => SettingsBloc(
            authenticationRepository: context.read<AuthenticationRepository>(),
            accountRepository: context.read<AccountRepository>(),
            trainingPlanRepository: context.read<TrainingPlanRepository>(),
          ),
        ),
        BlocProvider<TutorialBloc>(
          create: (c) => TutorialBloc(
            tutorialRepository: context.read<TutorialRepository>(),
          ),
        ),
      ],
      child: child,
    );
  }
}
