import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trainit/bloc/navigation/event.dart';
import 'package:trainit/bloc/navigation/state.dart';
import 'package:trainit/main.dart';

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc() : super(NavigationState()) {
    on<NavigateModule>(_handleNavigateModule);
    on<LoadLocalData>(_handleLoadLocalData);
    add(LoadLocalData());

    dataChangeBus.on<bool>().listen((event) {
      if (event == true && !isClosed) add(LoadLocalData());
    });
  }

  void _handleLoadLocalData(
      LoadLocalData event, Emitter<NavigationState> emit) async {
    final newState = state.copyWith();
    emit(newState);

    if (event.onFinish != null) {
      event.onFinish!();
    }
  }

  void _handleNavigateModule(
      NavigateModule event, Emitter<NavigationState> emit) async {
    emit(state.copyWith(selectedModule: event.module));
  }
}
