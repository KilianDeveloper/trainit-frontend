import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trainit/bloc/tutorial/bloc.dart';
import 'package:trainit/bloc/tutorial/event.dart';
import 'package:trainit/bloc/tutorial/state.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TutorialEmbed extends StatefulWidget {
  final String tutorialId;
  final Widget child;
  const TutorialEmbed({
    super.key,
    required this.tutorialId,
    required this.child,
  });

  @override
  State<TutorialEmbed> createState() => _TutorialEmbedState();
}

class _TutorialEmbedState extends State<TutorialEmbed> {
  Offset? offset;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TutorialBloc, TutorialState>(builder: (context, state) {
      if (state.status == TutorialStatus.pending) {
        return WidgetSize(
          onChange: (s, o) {
            if (o != offset && o != null) {
              context
                  .read<TutorialBloc>()
                  .add(PushPointer(widget.tutorialId, Point(o.dx, o.dy - 10)));
            }
          },
          child: widget.child,
        );
      } else {
        return widget.child;
      }
    });
  }
}

class EmptyTutorialDialog extends StatelessWidget {
  const EmptyTutorialDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SafeArea(
          child: Align(
            alignment: Alignment.topCenter,
            child: FilledButton.icon(
              onPressed: () => context.read<TutorialBloc>().add(NextTutorial()),
              icon: const Icon(Icons.skip_next_rounded),
              label: Text(AppLocalizations.of(context)!.next),
            ),
          ),
        ),
      ],
    );
  }
}

class TutorialDialog extends StatefulWidget {
  final String title;
  final String contentText;
  final Widget Function(BuildContext context)? primaryButton;
  final Widget Function(BuildContext context)? secondaryButton;
  final bool skipsOnClick;
  final Point? pointTo;
  const TutorialDialog({
    super.key,
    required this.title,
    required this.contentText,
    this.skipsOnClick = true,
    this.primaryButton,
    this.secondaryButton,
    this.pointTo = const Point(200, 500),
  });

  @override
  State<TutorialDialog> createState() => _TutorialDialogState();
}

class _TutorialDialogState extends State<TutorialDialog> {
  Size? size;
  @override
  Widget build(BuildContext context) {
    final backgroundColor = Theme.of(context).colorScheme.background;

    return LayoutBuilder(builder: (context, constraints) {
      const triangleHeight = 15.0;
      const triangleWidth = 25.0;
      const horizontalMargin = 16;

      final deviceHeight = constraints.maxHeight;
      final deviceWidth = constraints.maxWidth;
      final pointTo = widget.pointTo ??
          Point(60, deviceHeight / 2 - ((size?.height ?? 100) / 2));

      final triangleLeft = pointTo.x - horizontalMargin + triangleWidth / 2;

      final isTopHalf = pointTo.y < deviceHeight / 2;
      final isLeftHalf = pointTo.x < deviceWidth / 2;

      var boxTop = pointTo.y.toDouble() + triangleHeight;
      var triangleTop = pointTo.y.toDouble();
      var boxLeft = pointTo.x - horizontalMargin - 20.0;
      var boxWidth = deviceWidth - boxLeft - 20;

      if (!isTopHalf) {
        if (size != null) {
          boxTop -= triangleHeight + size!.height;
        }
      }
      if (!isLeftHalf) {
        boxLeft = 20;
        boxWidth = pointTo.x.toDouble() + 20 + triangleWidth / 2 + 2;
      }

      return Stack(
        children: [
          IgnorePointer(
            child: Container(
              height: double.infinity,
              width: double.infinity,
              color: Colors.black.withAlpha(20),
            ),
          ),
          if (widget.pointTo != null)
            Positioned(
              top: triangleTop,
              left: triangleLeft,
              child: ClipPath(
                clipper: CustomTriangleClipper(cornerOnTop: isTopHalf),
                child: Container(
                  width: triangleWidth,
                  height: triangleHeight,
                  decoration: BoxDecoration(
                    color: backgroundColor,
                  ),
                ),
              ),
            ),
          Positioned(
            top: boxTop,
            left: boxLeft,
            width: boxWidth,
            child: WidgetSize(
              onChange: (size, _) {
                setState(() {
                  this.size = size;
                });
              },
              child: GestureDetector(
                onTap: widget.skipsOnClick
                    ? () => context.read<TutorialBloc>().add(NextTutorial())
                    : null,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.title,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        widget.contentText,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: Wrap(
                          children: [
                            if (widget.secondaryButton != null)
                              widget.secondaryButton!(context),
                            const SizedBox(width: 6),
                            if (widget.primaryButton != null)
                              widget.primaryButton!(context)
                          ],
                        ),
                      ),
                      if (widget.skipsOnClick) ...[
                        const SizedBox(height: 16),
                        Align(
                          alignment: Alignment.topCenter,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.touch_app_rounded,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              Text(
                                AppLocalizations.of(context)!.click_to_skip,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ]
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}

class CustomTriangleClipper extends CustomClipper<Path> {
  final bool cornerOnTop;

  const CustomTriangleClipper({
    required this.cornerOnTop,
  });

  @override
  Path getClip(Size size) {
    final path = Path();
    if (cornerOnTop) {
      path.moveTo(size.width / 2, 0);
      path.lineTo(size.width, size.height);
      path.lineTo(0, size.height);
      return path;
    }

    path.lineTo(size.width, 0);
    path.lineTo(size.width / 2, size.height);
    path.lineTo(0, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class WidgetSize extends StatefulWidget {
  final Widget child;
  final Function(Size?, Offset?) onChange;

  const WidgetSize({
    super.key,
    required this.onChange,
    required this.child,
  });

  @override
  State<WidgetSize> createState() => _WidgetSizeState();
}

class _WidgetSizeState extends State<WidgetSize> {
  @override
  Widget build(BuildContext context) {
    SchedulerBinding.instance.addPostFrameCallback(postFrameCallback);
    return Container(
      key: widgetKey,
      child: widget.child,
    );
  }

  var widgetKey = GlobalKey();
  Size? oldSize;

  void postFrameCallback(_) {
    var context = widgetKey.currentContext;
    if (context == null) return;

    var newSize = context.size;
    final renderBox = context.findRenderObject() as RenderBox?;
    final offset = renderBox?.localToGlobal(Offset.zero);
    if (oldSize == newSize) return;

    oldSize = newSize;
    widget.onChange(newSize, offset);
  }
}
