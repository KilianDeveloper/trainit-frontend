import 'package:trainit/data/model/dto/module.dart';

class NavigationState {
  NavigationState({this.selectedModule = AppModule.home});

  final AppModule selectedModule;

  List<Object?> get props => [selectedModule];

  NavigationState copyWith({
    AppModule? selectedModule,
  }) {
    return NavigationState(
      selectedModule: selectedModule ?? this.selectedModule,
    );
  }
}
