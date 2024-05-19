import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trainit/bloc/authentication/bloc.dart';
import 'package:trainit/bloc/authentication/event.dart';
import 'package:trainit/bloc/authentication/state.dart';
import 'package:trainit/presentation/authentication/email_verification_screen.dart';
import 'package:trainit/presentation/authentication/login_screen.dart';
import 'package:trainit/presentation/authentication/register_screen.dart';
import 'package:trainit/presentation/shared/export/authentication_snackbar.dart';
import 'package:trainit/presentation/shared/export/unfocus_area.dart';

GlobalKey<NavigatorState> authenticationNavigatorKey =
    GlobalKey<NavigatorState>();

class MainAuthenticationScreen extends StatelessWidget {
  const MainAuthenticationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildNavigator(context);
  }

  bool checkForRebuild(
      AuthenticationState previous, AuthenticationState current) {
    return previous.screenStatus != current.screenStatus ||
        (previous.authenticationResult != current.authenticationResult &&
            previous.authenticationResult == null);
  }

  Widget _buildNavigator(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      buildWhen: checkForRebuild,
      builder: (c, state) => UnfocusArea(
        child: WillPopScope(
          onWillPop: () {
            if (authenticationNavigatorKey.currentState?.canPop() ?? false) {
              authenticationNavigatorKey.currentState!
                  .pop(authenticationNavigatorKey.currentContext);
            } else {
              SystemChannels.platform.invokeMethod<void>('SystemNavigator.pop');
            }
            return Future.value(false);
          },
          child: Scaffold(
            key: GlobalKey(),
            body: AuthenticationSnackbar(
              onShowSnackBar: () => context
                  .read<AuthenticationBloc>()
                  .add(ResetAuthenticationResul()),
              child: Navigator(
                key: authenticationNavigatorKey,
                pages: [
                  MaterialPage(
                    child: _buildLoginScreen(context),
                  ),
                  if (state.screenStatus.isRegisterScreen)
                    MaterialPage(
                      child: _buildRegisterScreen(context),
                    ),
                  if (state.screenStatus.isEmailNotVerified)
                    MaterialPage(
                      child: _buildVerificationScreen(context),
                    ),
                ],
                onPopPage: (route, result) {
                  if (state.screenStatus !=
                      AuthenticationStatus.emailNotVerified) {
                    context
                        .read<AuthenticationBloc>()
                        .add(NavigateBackToLogin());
                  }
                  return false;
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  EmailVerificationScreen _buildVerificationScreen(BuildContext context) {
    return EmailVerificationScreen(
      onSendVerificationMailClick: () =>
          context.read<AuthenticationBloc>().add(SendVerificationMail()),
      onCheckVerificationClick: () =>
          context.read<AuthenticationBloc>().add(CheckVerification()),
    );
  }

  RegisterScreen _buildRegisterScreen(BuildContext context) {
    return RegisterScreen(
      onLoginClick: (email, username, password) => context
          .read<AuthenticationBloc>()
          .add(CreateUserWithEmailAndPassword(
              email: email, password: password, username: username)),
      onGoToRegisterClick: () =>
          context.read<AuthenticationBloc>().add(GoToRegisterScreen()),
    );
  }

  LoginScreen _buildLoginScreen(BuildContext context) {
    return LoginScreen(
      onLoginClick: (email, password) => context
          .read<AuthenticationBloc>()
          .add(SignInWithEmailAndPassword(email: email, password: password)),
      onGoogleSignInClick: () =>
          context.read<AuthenticationBloc>().add(SignInWithGoogle()),
      onGoToRegisterClick: () =>
          context.read<AuthenticationBloc>().add(GoToRegisterScreen()),
    );
  }
}
