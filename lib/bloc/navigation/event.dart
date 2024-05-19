import 'package:trainit/data/model/dto/module.dart';

class NavigationEvent {
  List<Object?> get props => [];
}

class LoadLocalData extends NavigationEvent {
  final Function()? onFinish;
  LoadLocalData({this.onFinish});
  @override
  List<Object?> get props => [];
}

class NavigateModule extends NavigationEvent {
  NavigateModule(this.module);

  final AppModule module;

  @override
  List<Object?> get props => [];
}
