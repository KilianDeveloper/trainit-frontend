import 'package:flutter/material.dart';

class BottomSheetIndicator extends StatelessWidget {
  const BottomSheetIndicator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 4,
      width: 50,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onBackground.withAlpha(50),
        borderRadius: const BorderRadius.all(Radius.circular(2)),
      ),
    );
  }
}
