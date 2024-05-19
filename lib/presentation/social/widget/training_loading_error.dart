import 'package:flutter/material.dart';
import 'package:trainit/presentation/shared/export/svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TrainingLoadingError extends StatelessWidget {
  const TrainingLoadingError({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        const CenterSvg(path: "assets/not_found.svg"),
        Text(
          AppLocalizations.of(context)!.training_not_found,
          style: Theme.of(context).textTheme.titleMedium,
        )
      ],
    );
  }
}
