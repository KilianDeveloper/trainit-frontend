import 'package:flutter/material.dart';

class ValidationErrorCard extends StatelessWidget {
  final String error;
  const ValidationErrorCard(this.error, {super.key});

  @override
  Widget build(BuildContext context) {
    final foregroundColor = Theme.of(context).colorScheme.onErrorContainer;
    final backgroundColor = Theme.of(context).colorScheme.errorContainer;

    return Card(
      color: backgroundColor,
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Row(
          children: [
            Icon(
              Icons.error_rounded,
              color: foregroundColor,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                error,
                style: TextStyle(color: foregroundColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
