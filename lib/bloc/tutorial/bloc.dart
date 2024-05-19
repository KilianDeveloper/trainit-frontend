import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trainit/bloc/tutorial/event.dart';
import 'package:trainit/bloc/tutorial/state.dart';
import 'package:trainit/data/repository/tutorial_repository.dart';

class TutorialBloc extends Bloc<TutorialEvent, TutorialState> {
  final TutorialRepository tutorialRepository;

  TutorialBloc({
    required this.tutorialRepository,
  }) : super(TutorialState()) {
    on<StartTutorial>(_handleStartTutorial);
    on<NextTutorial>(_handleNextTutorial);
    on<StopTutorial>(_handleStopTutorial);
    on<PushPointer>(_handlePushPointer);
    on<Initialize>(_handleInitialize);
    add(Initialize());
  }

  void _handleInitialize(Initialize event, Emitter<TutorialState> emit) async {
    final status = await tutorialRepository.readStatus();

    emit(state.copyWith(
      status: status == "u" ? TutorialStatus.pending : TutorialStatus.ended,
    ));
  }

  void _handleStartTutorial(
      StartTutorial event, Emitter<TutorialState> emit) async {
    emit(state.copyWith(status: TutorialStatus.pending));
  }

  void _handleStopTutorial(
      StopTutorial event, Emitter<TutorialState> emit) async {
    emit(state.copyWithReset(status: TutorialStatus.ended));
    await tutorialRepository.writeStatus("d");
  }

  void _handleNextTutorial(
      NextTutorial event, Emitter<TutorialState> emit) async {
    emit(state.copyWith(
      status: TutorialStatus.pending,
      tutorialStack: state.tutorialStack.toList()..removeLast(),
    ));
  }

  void _handlePushPointer(
      PushPointer event, Emitter<TutorialState> emit) async {
    final newPointers = Map.of(state.tutorialElementPointers);
    newPointers[event.tutorialId] = event.point;
    emit(
      state.copyWith(
        tutorialElementPointers: newPointers,
      ),
    );
  }
}
