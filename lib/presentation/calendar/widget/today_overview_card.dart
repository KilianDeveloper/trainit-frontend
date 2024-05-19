import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TodayOverviewCard extends StatelessWidget {
  final int amountOfTrainings;
  const TodayOverviewCard({super.key, required this.amountOfTrainings});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.today,
              style: Theme.of(context)
                  .textTheme
                  .titleSmall
                  ?.copyWith(color: Theme.of(context).colorScheme.onSurface),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              AppLocalizations.of(context)!.trainings(amountOfTrainings),
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(color: Theme.of(context).colorScheme.primary),
            )
          ],
        ),
        const Spacer(),
        SvgPicture.asset(
          amountOfTrainings == 0
              ? "assets/chilling.svg"
              : "assets/training.svg",
          height: 72,
        ),
      ]),
    );
  }
}
