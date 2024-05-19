import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trainit/bloc/authentication/bloc.dart';
import 'package:trainit/bloc/authentication/state.dart';
import 'package:trainit/bloc/navigation/bloc.dart';
import 'package:trainit/bloc/navigation/state.dart';
import 'package:trainit/data/model/dto/module.dart';
import 'package:trainit/presentation/bloc.dart';
import 'package:trainit/presentation/shared/export/authentication_snackbar.dart';
import 'package:trainit/presentation/shared/export/bottom_navigation.dart';
import 'package:trainit/presentation/shared/export/tutorial.dart';
import 'package:trainit/presentation/shared/export/unfocus_area.dart';

class PageStack extends StatefulWidget {
  final AppModule selectedModule;
  final List<Widget> children;
  final List<GlobalKey<NavigatorState>> moduleNavigatorKeys;
  final Function(AppModule) navigateModule;
  const PageStack({
    super.key,
    required this.children,
    required this.selectedModule,
    required this.moduleNavigatorKeys,
    required this.navigateModule,
  });
  @override
  State createState() => _PageStackState();
}

class _PageStackState extends State<PageStack> with TickerProviderStateMixin {
  AnimationController? _animationController;
  Animation? animation;

  Map<int, GlobalKey<NavigatorState>> navigatorKeys = {};

  List<Widget> _widgetOptions = [];

  final GlobalKey scaffoldKey = GlobalKey();

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      value: 1.0,
      duration: const Duration(milliseconds: 200),
    );
    for (int i = 0; i < widget.children.length; i++) {
      navigatorKeys[i] = GlobalKey<NavigatorState>();
    }

    super.initState();

    if (_animationController == null) {
      return;
    }
    animation = Tween(begin: 0.0, end: 1.0).animate(_animationController!);
    _widgetOptions = widget.children
        .map(
          (e) => PageTransitionAnimation(
            animation: animation,
            child: e,
          ),
        )
        .toList();
  }

  Future<bool> _systemBackButtonPressed() {
    final selectedModuleCanPop = widget
        .moduleNavigatorKeys[widget.selectedModule.moduleIndex].currentState
        ?.canPop();
    if (selectedModuleCanPop ?? false) {
      widget
          .moduleNavigatorKeys[widget.selectedModule.moduleIndex].currentState!
          .pop(widget.moduleNavigatorKeys[widget.selectedModule.moduleIndex]
              .currentContext);
    } else {
      SystemChannels.platform.invokeMethod<void>('SystemNavigator.pop');
    }
    return Future.value(false);
  }

  _handleTabSelection(BuildContext context, int index) {
    if (index == widget.selectedModule.navigationBarIndex) return;
    setState(() {
      widget.navigateModule(AppModule.byIndex(index));
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<NavigationBloc, NavigationState>(
      listener: (context, state) {
        _animationController?.reset();
        _animationController?.forward();
      },
      listenWhen: (previous, current) =>
          previous.selectedModule != current.selectedModule,
      child: WillPopScope(
        onWillPop: _systemBackButtonPressed,
        child: UnfocusArea(
          child: AuthenticatedBlocProvider(
            child: Tutorial(
              child: Builder(builder: (context) {
                return Scaffold(
                  key: scaffoldKey,
                  body: AuthenticationSnackbar(
                    child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
                      builder: (context, state) => IndexedStack(
                        index: widget.selectedModule.moduleIndex,
                        children: _widgetOptions,
                      ),
                    ),
                  ),
                  bottomNavigationBar: bottomNavigationBar(
                    context,
                    widget.selectedModule.navigationBarIndex,
                    (p0) => _handleTabSelection(context, p0),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

class PageTransitionAnimation extends AnimatedWidget {
  const PageTransitionAnimation({key, required animation, required this.child})
      : super(
          key: key,
          listenable: animation,
        );

  final Widget child;

  @override
  Widget build(BuildContext context) {
    Animation<double> animation = listenable as Animation<double>;
    return Opacity(
      opacity: animation.value,
      child: child,
    );
  }
}
