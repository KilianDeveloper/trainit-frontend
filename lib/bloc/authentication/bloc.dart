import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trainit/bloc/authentication/event.dart';
import 'package:trainit/bloc/authentication/state.dart';
import 'package:trainit/data/repository/account_repository.dart';
import 'package:trainit/data/repository/authentication_repository.dart';
import 'package:trainit/data/repository/local_data_repository.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthenticationRepository authenticationRepository;
  final LocalDataRepository dataRepository = LocalDataRepository();
  final AccountRepository accountRepository = AccountRepository();

  AuthenticationBloc({required this.authenticationRepository})
      : super(
          AuthenticationState.bloc(
            isSignedIn: authenticationRepository.isSignedIn,
            isUserVerified: authenticationRepository.isVerified,
          ),
        ) {
    on<SignInWithEmailAndPassword>(_handleSignInWithEmailAndPassword);
    on<CreateUserWithEmailAndPassword>(_handleCreateUserWithEmailAndPassword);
    on<SignOut>(_handleSignOut);
    on<UserChange>(_handleUserChange);
    on<GoToRegisterScreen>(_handleGoToRegisterScreen);
    on<NavigateBackToLogin>(_handleNavigateBackToLogin);
    on<ResetAuthenticationResult>(_handleResetAuthenticationResult);
    on<SendVerificationMail>(_handleSendVerificationMail);
    on<CheckVerification>(_handleCheckVerification);
    on<SignInWithGoogle>(_handleSignInWithGoogle);
    on<ResetAuthenticationResul>(_handleResetAuthenticationResul);

    authenticationRepository.authStateChanges.listen((user) {
      add(UserChange(
        isSignedIn: user != null,
        isUserVerified: user?.emailVerified ?? false,
      ));
    });
  }

  void _handleSignInWithEmailAndPassword(SignInWithEmailAndPassword event,
      Emitter<AuthenticationState> emit) async {
    final result = await authenticationRepository.signInWithEmailAndPassword(
        email: event.email, password: event.password);
    if (authenticationRepository.isVerified) {
      await authenticationRepository.getToken(
        forceRefresh: true,
      );

      await accountRepository.createAccount(
        authenticationRepository.userData!.displayName ?? "New User",
        conflictValid: true,
      );
    }

    emit(state.copyWithAuthenticationResult(result));
  }

  void _handleResetAuthenticationResul(
      ResetAuthenticationResul event, Emitter<AuthenticationState> emit) async {
    emit(state.copyWithAuthenticationResult(null));
  }

  void _handleSignInWithGoogle(
      SignInWithGoogle event, Emitter<AuthenticationState> emit) async {
    await authenticationRepository.signInWithGoogle();

    if (authenticationRepository.isVerified) {
      await authenticationRepository.getToken(forceRefresh: true);
      await accountRepository.createAccount(
        authenticationRepository.userData!.displayName ?? "New User",
        conflictValid: true,
      );

      emit(state
          .copyWithAuthenticationResult(FirebaseAuthenticationResult.verified));
      add(UserChange(
        isSignedIn: authenticationRepository.isSignedIn,
        isUserVerified: authenticationRepository.isVerified,
      ));
    }
  }

  void _handleCreateUserWithEmailAndPassword(
      CreateUserWithEmailAndPassword event,
      Emitter<AuthenticationState> emit) async {
    final result =
        await authenticationRepository.createUserWithEmailAndPassword(
            email: event.email,
            password: event.password,
            username: event.username);
    authenticationRepository.sendVerficationMailIfSignedIn();

    emit(state.copyWithAuthenticationResult(result));
  }

  void _handleSignOut(SignOut event, Emitter<AuthenticationState> emit) async {
    await dataRepository.deleteAll();
    await authenticationRepository.signOut();
  }

  void _handleUserChange(
      UserChange event, Emitter<AuthenticationState> emit) async {
    final newStatus =
        AuthenticationStatusX.forState(event.isSignedIn, event.isUserVerified);
    emit(state.copyWith(screenStatus: newStatus));
  }

  void _handleGoToRegisterScreen(
      GoToRegisterScreen event, Emitter<AuthenticationState> emit) async {
    emit(state.copyWith(screenStatus: AuthenticationStatus.register));
  }

  void _handleNavigateBackToLogin(
      NavigateBackToLogin event, Emitter<AuthenticationState> emit) async {
    emit(state.copyWith(screenStatus: AuthenticationStatus.unauthenticated));
  }

  void _handleResetAuthenticationResult(ResetAuthenticationResult event,
      Emitter<AuthenticationState> emit) async {
    emit(state.copyWithAuthenticationResult(null));
  }

  void _handleSendVerificationMail(
      SendVerificationMail event, Emitter<AuthenticationState> emit) async {
    authenticationRepository.sendVerficationMailIfSignedIn();
  }

  void _handleCheckVerification(
      CheckVerification event, Emitter<AuthenticationState> emit) async {
    await authenticationRepository.reloadUser();
    if (authenticationRepository.isVerified) {
      await authenticationRepository.getToken(forceRefresh: true);

      await accountRepository.createAccount(
          authenticationRepository.userData!.displayName ?? "New User");
      emit(state
          .copyWithAuthenticationResult(FirebaseAuthenticationResult.verified));
    } else {
      emit(state.copyWithAuthenticationResult(
          FirebaseAuthenticationResult.stillNotVerified));
    }
    add(UserChange(
      isUserVerified: authenticationRepository.isVerified,
      isSignedIn: authenticationRepository.isSignedIn,
    ));
  }
}
