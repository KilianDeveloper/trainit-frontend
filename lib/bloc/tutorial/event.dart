import 'dart:math';

class TutorialEvent {
  List<Object?> get props => [];
}

class Initialize extends TutorialEvent {
  Initialize();

  @override
  List<Object?> get props => [];
}

class StartTutorial extends TutorialEvent {
  StartTutorial();

  @override
  List<Object?> get props => [];
}

class StopTutorial extends TutorialEvent {
  StopTutorial();

  @override
  List<Object?> get props => [];
}

class NextTutorial extends TutorialEvent {
  NextTutorial();

  @override
  List<Object?> get props => [];
}

class PushPointer extends TutorialEvent {
  PushPointer(this.tutorialId, this.point);

  final String tutorialId;
  final Point point;

  @override
  List<Object?> get props => [];
}
