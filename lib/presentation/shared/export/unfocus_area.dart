import 'package:flutter/material.dart';

class UnfocusArea extends StatelessWidget {
  final Widget child;
  const UnfocusArea({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => FocusScope.of(context).unfocus(),
      child: child,
    );
  }
}
