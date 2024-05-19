class AuthenticationEvent {
  List<Object?> get props => [];
}

class SignInWithEmailAndPassword extends AuthenticationEvent {
  SignInWithEmailAndPassword({required this.email, required this.password});
  final String email;
  final String password;
  @override
  List<Object?> get props => [];
}

class SignInWithGoogle extends AuthenticationEvent {
  SignInWithGoogle();
  @override
  List<Object?> get props => [];
}

class CreateUserWithEmailAndPassword extends AuthenticationEvent {
  CreateUserWithEmailAndPassword(
      {required this.email, required this.password, required this.username});
  final String email;
  final String password;
  final String username;
  @override
  List<Object?> get props => [];
}

class SignOut extends AuthenticationEvent {
  SignOut();
  @override
  List<Object?> get props => [];
}

class GoToRegisterScreen extends AuthenticationEvent {
  GoToRegisterScreen();
  @override
  List<Object?> get props => [];
}

class NavigateBackToLogin extends AuthenticationEvent {
  NavigateBackToLogin();
  @override
  List<Object?> get props => [];
}

class UserChange extends AuthenticationEvent {
  UserChange({
    required this.isUserVerified,
    required this.isSignedIn,
  });
  final bool isSignedIn;
  final bool isUserVerified;

  @override
  List<Object?> get props => [];
}

class ResetAuthenticationResult extends AuthenticationEvent {
  ResetAuthenticationResult();
  @override
  List<Object?> get props => [];
}

class SendVerificationMail extends AuthenticationEvent {
  SendVerificationMail();
  @override
  List<Object?> get props => [];
}

class CheckVerification extends AuthenticationEvent {
  CheckVerification();
  @override
  List<Object?> get props => [];
}

class ResetAuthenticationResul extends AuthenticationEvent {
  ResetAuthenticationResul();
  @override
  List<Object?> get props => [];
}
