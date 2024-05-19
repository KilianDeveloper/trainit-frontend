import 'package:flutter/widgets.dart';
import 'package:trainit/presentation/shared/export/validation_error_card.dart';

class ValidationErrorView extends StatelessWidget {
  final String? errorText;
  final Widget child;
  const ValidationErrorView({
    super.key,
    required this.child,
    required this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (errorText != null) ValidationErrorCard(errorText!),
        Expanded(child: child),
      ],
    );
  }
}
