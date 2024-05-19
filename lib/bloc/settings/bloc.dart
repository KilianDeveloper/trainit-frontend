import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:trainit/bloc/settings/event.dart';
import 'package:trainit/bloc/settings/state.dart';
import 'package:trainit/data/model/training_plan.dart';
import 'package:trainit/data/repository/account_repository.dart';
import 'package:trainit/data/repository/authentication_repository.dart';
import 'package:trainit/data/repository/trainingplan_repository.dart';
import 'package:trainit/main.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final AccountRepository accountRepository;
  final TrainingPlanRepository trainingPlanRepository;
  final AuthenticationRepository authenticationRepository;

  SettingsBloc({
    required this.accountRepository,
    required this.trainingPlanRepository,
    required this.authenticationRepository,
  }) : super(SettingsState()) {
    on<NavigateAppSettings>(_handleGoToNewAppSettings);
    on<NavigateBack>(_handleNavigateBack);
    on<SelectTrainingPlan>(_handleSelectTrainingPlan);
    on<SaveSelectedTrainingPlan>(_handleSaveSelectedTrainingPlan);
    on<LoadLocalData>(_handleLoadLocalData);
    on<SaveAccount>(_handleSaveAccount);
    on<SaveProfilePhoto>(_handleSaveProfilePhoto);
    on<SaveTheme>(_handleSaveTheme);
    on<ResetScreenStatus>(_handleResetScreenStatus);
    on<PushScreen>(_handlePushScreen);
    on<PopScreen>(_handlePopScreen);
    add(LoadLocalData());

    dataChangeBus.on<bool>().listen((event) {
      if (event == true && !isClosed) add(LoadLocalData());
    });
  }

  void _handleResetScreenStatus(
      ResetScreenStatus event, Emitter<SettingsState> emit) async {
    emit(state.copyWith(status: SettingsStatus.initial));
  }

  void _handleLoadLocalData(
      LoadLocalData event, Emitter<SettingsState> emit) async {
    final authenticatedAccount =
        await accountRepository.readLocalAuthenticated();
    final authenticatedUser = authenticationRepository.userData;
    final trainingPlans = await trainingPlanRepository.readAllLocal();
    if (authenticatedAccount == null) {
      return;
    }
    final currentTrainingPlan = trainingPlans.firstWhere(
      (element) => element.id == authenticatedAccount.trainingPlanId,
      orElse: () => throw "Users TrainingPlan not found",
    );
    final packageInfo = await PackageInfo.fromPlatform();
    final newState = state.copyWithProfilePhoto(
      account: authenticatedAccount,
      allTrainingPlans: await trainingPlanRepository.readAllLocal(),
      currentTrainingPlan: currentTrainingPlan,
      version: packageInfo.version,
      profilePhoto: await accountRepository.readLocalProfilePhoto(),
      theme: await accountRepository.readLocalTheme(),
      authenticationUser: authenticatedUser,
    );
    emit(newState);

    if (event.onFinish != null) {
      event.onFinish!();
    }
  }

  void _handleSaveAccount(
      SaveAccount event, Emitter<SettingsState> emit) async {
    emit(state.copyWith(isLoading: true));

    final account = await accountRepository.readLocalAuthenticated();
    if (account == null) {
      return null;
    }
    account.weightUnit = event.weightUnit;
    account.averageSetDuration = event.setDuration;
    account.averageSetRestDuration = event.restDuration;

    await accountRepository.writeLocalAuthenticated(account);
    await accountRepository.updateAccount();
    add(LoadLocalData());
    emit(state.copyWith(isLoading: false));
    dataChangeBus.fire(true);
  }

  void _handleSaveProfilePhoto(
      SaveProfilePhoto event, Emitter<SettingsState> emit) async {
    emit(state.copyWith(isLoading: true));
    await accountRepository.uploadProfilePhoto(event.data);
    add(LoadLocalData());
    emit(state.copyWith(isLoading: false));
  }

  void _handlePushScreen(PushScreen event, Emitter<SettingsState> emit) async {
    emit(
      state.copyWithInjected(
        injectedScreens: state.injectedScreens.toList()..add(event.widget),
      ),
    );
  }

  void _handlePopScreen(PopScreen event, Emitter<SettingsState> emit) async {
    emit(
      state.copyWithInjected(
        injectedScreens: state.injectedScreens..removeLast(),
      ),
    );
  }

  void _handleGoToNewAppSettings(
      NavigateAppSettings event, Emitter<SettingsState> emit) async {
    emit(state
        .copyWithSelection(
      status: SettingsStatus.appSettings,
      selection: null,
    )
        .copyWithInjected(injectedScreens: []));
  }

  void _handleNavigateBack(
      NavigateBack event, Emitter<SettingsState> emit) async {
    if (state.injectedScreens.isNotEmpty) {
      emit(state.copyWithInjected(
          injectedScreens: state.injectedScreens..removeLast()));
    } else if (state.status == SettingsStatus.editTrainingPlan) {
      emit(state.copyWithSelection(
        status: SettingsStatus.initial,
        selection: null,
      ));
    } else {
      emit(state.copyWith(status: SettingsStatus.initial));
    }
  }

  void _handleSelectTrainingPlan(
      SelectTrainingPlan event, Emitter<SettingsState> emit) async {
    emit(
      state
          .copyWithSelection(
              selection: event.selected,
              status: SettingsStatus.editTrainingPlan)
          .copyWithInjected(injectedScreens: []),
    );
  }

  void _handleSaveSelectedTrainingPlan(
      SaveSelectedTrainingPlan event, Emitter<SettingsState> emit) async {
    final trainingPlan = TrainingPlan(
      localId: state.selectedTrainingPlan!.localId,
      id: state.selectedTrainingPlan!.id,
      name: event.name,
      days: event.days,
      createdOn: state.selectedTrainingPlan!.createdOn,
      accountId: state.selectedTrainingPlan!.accountId,
    );
    await trainingPlanRepository.writeLocal(trainingPlan);
    await trainingPlanRepository.updateRemoteTrainingPlan(trainingPlan.id);
    emit(state.copyWithSelection(
        selection: null, status: SettingsStatus.initial));

    if (event.onFinish != null) {
      event.onFinish!();
    }
    add(LoadLocalData());
  }

  void _handleSaveTheme(SaveTheme event, Emitter<SettingsState> emit) async {
    accountRepository.writeLocalTheme(event.theme);
    dataChangeBus.fire(event.theme);
    emit(state.copyWith(theme: event.theme));
  }
}
