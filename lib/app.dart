import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trainit/bloc/authentication/bloc.dart';
import 'package:trainit/bloc/authentication/state.dart';
import 'package:trainit/bloc/data/cubit.dart';
import 'package:trainit/bloc/data/state.dart';
import 'package:trainit/bloc/navigation/bloc.dart';
import 'package:trainit/bloc/navigation/event.dart';
import 'package:trainit/bloc/navigation/state.dart';
import 'package:trainit/data/repository/account_repository.dart';
import 'package:trainit/main.dart';
import 'package:trainit/presentation/authentication/main.dart';
import 'package:trainit/presentation/bloc.dart';
import 'package:trainit/presentation/calendar/main.dart';
import 'package:trainit/presentation/settings/main.dart';
import 'package:trainit/presentation/shared/style.dart';
import 'package:trainit/presentation/shared/export/error.dart';
import 'package:trainit/presentation/shared/export/loading_indicator.dart';
import 'package:trainit/presentation/shared/export/page_stack.dart';
import 'package:trainit/presentation/social/main.dart';
import 'package:trainit/presentation/statistics/main.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

final GlobalKey<ScaffoldMessengerState> snackbarKey =
    GlobalKey<ScaffoldMessengerState>();

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  ThemeMode theme = startTheme;
  List<String> snackBarTexts = [];

  final List<Widget> _widgetOptions = [
    const MainStatisticsScreen(),
    const MainCalendarScreen(),
    const MainSettingsScreen(),
    const MainSocialScreen(),
  ];

  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    statisticsNavigatorKey,
    calendarNavigatorKey,
    settingsNavigatorKey,
    socialNavigatorKey,
  ];

  void _reloadData(BuildContext context, AuthenticationState state) async {
    if (state.screenStatus.isAuthenticated) {
      context.read<DataCubit>().reloadData();
    }
  }

  bool _isReloadRequired(
      AuthenticationState previous, AuthenticationState current) {
    return (previous.screenStatus != current.screenStatus &&
            current.screenStatus == AuthenticationStatus.authenticated) ||
        (current.screenStatus == AuthenticationStatus.authenticated &&
            current.authenticatedInCurrentSession == false);
  }

  @override
  void initState() {
    dataChangeBus.on<ThemeMode>().listen(
      (event) async {
        final newTheme = await AccountRepository().readLocalTheme();
        setState(() {
          theme = newTheme;
          SystemChrome.setSystemUIOverlayStyle(_getSystemStyle(context, theme));
        });
      },
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'trainIt',
      darkTheme: darkTheme,
      themeMode: theme,
      theme: lightTheme,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      scaffoldMessengerKey: snackbarKey,
      home: _build(context),
    );
  }

  Widget _build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(_getSystemStyle(context, theme));
    return Stack(
      children: [
        ErrorBuilder(builder: (context, onError) {
          return BaseBlocProvider(
            onError: onError,
            child: BlocBuilder<DataCubit, DataState>(
              builder: (context, dataState) => Stack(
                children: [
                  BlocConsumer<AuthenticationBloc, AuthenticationState>(
                    listenWhen: _isReloadRequired,
                    listener: _reloadData,
                    builder: (context, authState) {
                      if (authState.screenStatus.isAuthenticated) {
                        return BlocBuilder<NavigationBloc, NavigationState>(
                            builder: (context, state) {
                          return PageStack(
                            selectedModule: state.selectedModule,
                            moduleNavigatorKeys: _navigatorKeys,
                            children: _widgetOptions,
                            navigateModule: (module) {
                              context
                                  .read<NavigationBloc>()
                                  .add(NavigateModule(module));
                            },
                          );
                        });
                      } else {
                        return const MainAuthenticationScreen();
                      }
                    },
                  ),
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: LoadingIndicator(
                        isLoading: dataState.status.isLoading,
                        text: dataState.statusText,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  SystemUiOverlayStyle _getSystemStyle(
      BuildContext context, ThemeMode themeMode) {
    ThemeData theme;
    switch (themeMode) {
      case ThemeMode.dark:
        theme = darkTheme;
        break;
      case ThemeMode.light:
        theme = lightTheme;
        break;
      case ThemeMode.system:
        final deviceBrightness =
            WidgetsBinding.instance.platformDispatcher.platformBrightness;
        theme = deviceBrightness == Brightness.dark ? darkTheme : lightTheme;
        break;
    }

    return SystemUiOverlayStyle(
      systemNavigationBarContrastEnforced: true,
      systemNavigationBarIconBrightness: theme.colorScheme.brightness,
      statusBarBrightness: theme.colorScheme.brightness,
      statusBarColor: theme.colorScheme.surface,
      systemNavigationBarColor: theme.navigationBarTheme.backgroundColor,
    );
  }
}
