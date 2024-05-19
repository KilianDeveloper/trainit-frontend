import 'package:trainit/data/repository/authentication_repository.dart';

enum AuthenticationStatus {
  login,
  authenticated,
  unauthenticated,
  register,
  emailNotVerified
}

extension AuthenticationStatusX on AuthenticationStatus {
  bool get isInitial => this == AuthenticationStatus.login;
  bool get isAuthenticated => this == AuthenticationStatus.authenticated;
  bool get isRegisterScreen => this == AuthenticationStatus.register;
  bool get isEmailNotVerified => this == AuthenticationStatus.emailNotVerified;

  static AuthenticationStatus forState(bool isSignedIn, bool isVerified) {
    if (!isSignedIn) {
      return AuthenticationStatus.unauthenticated;
    } else if (!isVerified) {
      return AuthenticationStatus.emailNotVerified;
    } else {
      return AuthenticationStatus.authenticated;
    }
  }
}

class AuthenticationState {
  AuthenticationState(
      {this.screenStatus = AuthenticationStatus.login,
      this.authenticationResult,
      this.authenticatedInCurrentSession = false});
  AuthenticationState.bloc(
      {required bool isSignedIn,
      required bool isUserVerified,
      this.authenticationResult,
      this.authenticatedInCurrentSession = false})
      : screenStatus =
            AuthenticationStatusX.forState(isSignedIn, isUserVerified);

  final AuthenticationStatus screenStatus;
  final FirebaseAuthenticationResult? authenticationResult;
  final bool authenticatedInCurrentSession;

  List<Object?> get props => [screenStatus];

  AuthenticationState copyWith({
    AuthenticationStatus? screenStatus,
    FirebaseAuthenticationResult? authenticationResult,
  }) {
    return AuthenticationState(
      screenStatus: screenStatus ?? this.screenStatus,
      authenticationResult: authenticationResult ?? this.authenticationResult,
    );
  }

  AuthenticationState copyWithAuthenticationResult(
    FirebaseAuthenticationResult? authenticationResult, {
    bool authenticatedInSession = true,
  }) {
    return AuthenticationState(
      screenStatus: screenStatus,
      authenticatedInCurrentSession: authenticatedInSession,
      authenticationResult: authenticationResult,
    );
  }
}
