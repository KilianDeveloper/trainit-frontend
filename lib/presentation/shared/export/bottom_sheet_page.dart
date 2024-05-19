import 'package:flutter/material.dart';
import 'package:trainit/presentation/shared/style.dart';
import 'package:trainit/presentation/shared/export/bottom_sheet_indicator.dart';

class BottomSheetPage extends StatelessWidget {
  final String? title;
  final Widget child;
  const BottomSheetPage({
    super.key,
    this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: screenPadding.add(
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom)),
      child: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            const BottomSheetIndicator(),
            if (title != null)
              Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  title!,
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}
