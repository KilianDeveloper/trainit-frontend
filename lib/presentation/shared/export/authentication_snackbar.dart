import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trainit/bloc/authentication/bloc.dart';
import 'package:trainit/bloc/authentication/event.dart';
import 'package:trainit/bloc/authentication/state.dart';

class AuthenticationSnackbar extends StatelessWidget {
  final Widget child;
  final Function()? onShowSnackBar;

  const AuthenticationSnackbar({
    super.key,
    required this.child,
    this.onShowSnackBar,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) =>
          _buildAlerts(context: context, state: state, child: child),
    );
  }

  Widget _buildAlerts({
    required BuildContext context,
    required AuthenticationState state,
    required Widget child,
  }) {
    if (state.authenticationResult != null) {
      if (onShowSnackBar != null) onShowSnackBar!();
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.authenticationResult!.toUIString())));
      });
      context.read<AuthenticationBloc>().add(ResetAuthenticationResult());
    }
    return child;
  }
}
