import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trainit/bloc/authentication/bloc.dart';
import 'package:trainit/bloc/authentication/event.dart';
import 'package:trainit/bloc/data/cubit.dart';
import 'package:trainit/bloc/settings/bloc.dart';
import 'package:trainit/bloc/settings/event.dart';
import 'package:trainit/bloc/settings/state.dart';
import 'package:trainit/presentation/settings/account_screen.dart';
import 'package:trainit/presentation/settings/app_settings_screen.dart';
import 'package:trainit/presentation/settings/edit_training_plan_screen.dart';
import 'package:trainit/presentation/shared/export/loading_indicator.dart';
import 'package:trainit/presentation/social/export/friends_screen.dart';
import 'package:trainit/presentation/social/export/profile_screen.dart';

GlobalKey<NavigatorState> settingsNavigatorKey = GlobalKey<NavigatorState>();

class MainSettingsScreen extends StatefulWidget {
  const MainSettingsScreen({super.key});

  @override
  State<MainSettingsScreen> createState() => _MainSettingsScreenState();
}

class _MainSettingsScreenState extends State<MainSettingsScreen> {
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
    return BlocBuilder<SettingsBloc, SettingsState>(builder: (c, state) {
      final injectedScreens =
          state.injectedScreens.map((e) => MaterialPage(child: e()));

      return Stack(
        children: [
          Navigator(
            key: settingsNavigatorKey,
            pages: [
              _builAccountScreen(context, state),
              if (state.status.isAppSettingsScreen)
                _builAppSettingsScreen(context, state),
              if (state.isEditTrainingPlanScreen())
                _buildEditTrainingPlanScreen(context, state),
              ...injectedScreens
            ],
            onPopPage: (route, result) {
              context.read<SettingsBloc>().add(NavigateBack());
              return route.didPop(result);
            },
          ),
          Align(
            alignment: Alignment.center,
            child: LoadingIndicator(isLoading: state.isLoading),
          )
        ],
      );
    });
  }

  MaterialPage _buildEditTrainingPlanScreen(
      BuildContext context, SettingsState state) {
    return MaterialPage(
      child: EditTrainingPlanScreen(
        account: state.account,
        trainingPlan: state.selectedTrainingPlan!,
        save: (name, days) =>
            context.read<SettingsBloc>().add(SaveSelectedTrainingPlan(
                  name: name,
                  days: days,
                  onFinish: () => context.read<DataCubit>().reloadData(),
                )),
        selectTraining: (p) =>
            context.read<SettingsBloc>().add(SelectTraining(selected: p)),
      ),
    );
  }

  MaterialPage _builAccountScreen(BuildContext context, SettingsState state) {
    return MaterialPage(
      child: AccountScreen(
        account: state.account,
        trainingPlan: state.currentTrainingPlan,
        profilePhoto: state.profilePhoto,
        signOut: () => context.read<AuthenticationBloc>().add(SignOut()),
        navigateToSettings: () =>
            context.read<SettingsBloc>().add(NavigateAppSettings()),
        selectTrainingPlan: (p0) => context.read<SettingsBloc>().add(
              SelectTrainingPlan(selected: p0),
            ),
        showFriendList: () => context.read<SettingsBloc>().add(
              PushScreen(widget: _buildInjectableFriendsScreen()),
            ),
        saveAccount: (weightUnit, setDuration, restDuration) =>
            context.read<SettingsBloc>().add(
                  SaveAccount(
                    weightUnit: weightUnit,
                    setDuration: setDuration,
                    restDuration: restDuration,
                  ),
                ),
        saveProfilePhoto: (data) => context.read<SettingsBloc>().add(
              SaveProfilePhoto(data: data),
            ),
        loadProfileScreen: () {
          context.read<SettingsBloc>().add(
                PushScreen(widget: _buildInjectableProfileScreen()),
              );
        },
      ),
    );
  }

  MaterialPage _builAppSettingsScreen(
      BuildContext context, SettingsState state) {
    final staticInformation = state.staticInformation;
    final user = state.authenticationUser;
    return MaterialPage(
      child: AppSettingsScreen(
        version: state.version,
        account: state.account,
        privacyPolicyLink: staticInformation.privacyPolicyLink,
        termsOfServiceLink: staticInformation.termsOfServiceLink,
        supportMail: staticInformation.supportMail,
        user: user,
        theme: state.theme,
        changeTheme: (theme) => context.read<SettingsBloc>().add(
              SaveTheme(theme: theme),
            ),
        signOut: () => context.read<AuthenticationBloc>().add(SignOut()),
      ),
    );
  }

  Widget Function() _buildInjectableFriendsScreen() {
    return () {
      return ExportFriendsScreen(
        pushPage: (screen) =>
            context.read<SettingsBloc>().add(PushScreen(widget: screen)),
        popPage: () => context.read<SettingsBloc>().add(PopScreen()),
      );
    };
  }

  Widget Function() _buildInjectableProfileScreen() {
    return () {
      return ExportProfileScreen(
          pushPage: (screen) =>
              context.read<SettingsBloc>().add(PushScreen(widget: screen)),
          popPage: () => context.read<SettingsBloc>().add(PopScreen()));
    };
  }
}
