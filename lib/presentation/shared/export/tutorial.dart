import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trainit/bloc/tutorial/bloc.dart';
import 'package:trainit/bloc/tutorial/event.dart';
import 'package:trainit/bloc/tutorial/state.dart';
import 'package:trainit/presentation/shared/export/tutorial_dialog.dart';

class Tutorial extends StatefulWidget {
  final Widget child;
  const Tutorial({
    super.key,
    required this.child,
  });

  @override
  State<Tutorial> createState() => _TutorialState();
}

class _TutorialState extends State<Tutorial> {
  OverlayEntry? currentEntry;
  String? currentId;

  @override
  void dispose() {
    currentEntry?.remove();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TutorialBloc, TutorialState>(
      listenWhen: listenWhen,
      builder: (context, state) => widget.child,
      listener: (context, state) {
        if (state.tutorialStack.isEmpty ||
            state.status != TutorialStatus.pending) {
          try {
            currentEntry?.remove();
          } catch (_) {}

          currentEntry = null;
          if (state.status != TutorialStatus.ended) {
            context.read<TutorialBloc>().add(StopTutorial());
          }
          return;
        }

        final currentTutorialElement = state.tutorialStack.last;
        var newEntry = OverlayEntry(
          builder: (b) => BlocProvider<TutorialBloc>.value(
            value: context.read<TutorialBloc>(),
            child: const EmptyTutorialDialog(),
          ),
        );
        if (currentTutorialElement != null) {
          final currentTutorialPointer =
              state.tutorialElementPointers[currentTutorialElement.id];

          if (currentTutorialPointer == null &&
              currentTutorialElement.isPositioned == true) {
            return;
          }

          if (currentId == currentTutorialElement.id) return;
          newEntry = OverlayEntry(
            builder: (b) => BlocProvider<TutorialBloc>.value(
              value: context.read<TutorialBloc>(),
              child: TutorialDialog(
                title: currentTutorialElement.title(context),
                contentText: currentTutorialElement.content(context),
                primaryButton: currentTutorialElement.primaryButton,
                secondaryButton: currentTutorialElement.secondaryButton,
                skipsOnClick: currentTutorialElement.hasSkipOnClick,
                pointTo: currentTutorialElement.isPositioned
                    ? currentTutorialPointer
                    : null,
              ),
            ),
          );
        }

        setState(() {
          currentId = currentTutorialElement?.id;
          currentEntry?.remove();
          currentEntry = newEntry;
        });
        WidgetsBinding.instance.addPostFrameCallback(
          (_) => Overlay.of(context).insert(newEntry),
        );
      },
    );
  }

  bool listenWhen(TutorialState previous, TutorialState current) => true;
}
