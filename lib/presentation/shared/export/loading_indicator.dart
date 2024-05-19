import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoadingIndicator extends StatelessWidget {
  final bool isLoading;
  final String? text;
  const LoadingIndicator({
    super.key,
    required this.isLoading,
    this.text,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (child, animation) {
        const begin = Offset(0.0, -.3);
        const end = Offset.zero;
        final tween = Tween(begin: begin, end: end)
            .chain(CurveTween(curve: Curves.easeInOutCubicEmphasized));
        final tween2 = Tween(begin: 0.0, end: 1.0)
            .chain(CurveTween(curve: Curves.easeInOut));
        final offsetAnimation2 = animation.drive(tween2);
        final offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: FadeTransition(opacity: offsetAnimation2, child: child),
        );
      },
      child: isLoading
          ? Align(
              alignment: Alignment.center,
              child: Container(
                key: const Key("loading"),
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceVariant,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(30),
                        blurRadius: 2,
                        offset: const Offset(1, 1),
                      ),
                    ]),
                child: SizedBox(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        LoadingAnimationWidget.waveDots(
                          color: Theme.of(context).colorScheme.primary,
                          size: 32,
                        ),
                        if (text != null) const SizedBox(height: 12),
                        if (text != null)
                          Text(
                            text!,
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          : null,
    );
  }
}
