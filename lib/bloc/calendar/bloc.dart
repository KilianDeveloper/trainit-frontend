import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trainit/bloc/calendar/event.dart';
import 'package:trainit/bloc/calendar/state.dart';
import 'package:trainit/data/repository/calendar_repository.dart';
import 'package:trainit/data/repository/account_repository.dart';
import 'package:trainit/main.dart';

class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  final AccountRepository accountRepository;
  final CalendarRepository calendarRepository;

  CalendarBloc({
    required this.accountRepository,
    required this.calendarRepository,
  }) : super(CalendarState()) {
    on<SelectCalendarTraining>(_mapSelectCalendarTrainingEventToState);
    on<LoadLocalData>(_mapLoadLocalData);
    on<ResetScreenStatus>(_mapResetScreenStatus);
    on<PushScreen>(_handlePushScreen);
    on<PopScreen>(_handlePopScreen);
    add(LoadLocalData());

    dataChangeBus.on<bool>().listen((event) {
      if (event == true && !isClosed) add(LoadLocalData());
    });
  }

  void _mapResetScreenStatus(
      ResetScreenStatus event, Emitter<CalendarState> emit) async {
    emit(state.copyWith(status: CalendarStatus.initial));
  }

  void _handlePushScreen(PushScreen event, Emitter<CalendarState> emit) async {
    emit(
      state.copyWithInjected(
        injectedScreens: state.injectedScreens.toList()..add(event.widget),
      ),
    );
  }

  void _handlePopScreen(PopScreen event, Emitter<CalendarState> emit) async {
    emit(
      state.copyWithInjected(
        injectedScreens: state.injectedScreens..removeLast(),
      ),
    );
  }

  void _mapLoadLocalData(
      LoadLocalData event, Emitter<CalendarState> emit) async {
    emit(state.copyWith(
      account: await accountRepository.readLocalAuthenticated(),
      calendar: await calendarRepository.readLocal(),
    ));
  }

  void _mapSelectCalendarTrainingEventToState(
      SelectCalendarTraining event, Emitter<CalendarState> emit) async {
    emit(
      state
          .copyWithSelection(value: event.selected)
          .copyWithInjected(injectedScreens: []),
    );
  }
}
