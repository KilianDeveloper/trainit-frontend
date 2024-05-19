import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EditTrainingPlanHeader extends StatelessWidget {
  final Widget header;
  final Function(TapUpDetails) onAddItemClick;
  const EditTrainingPlanHeader({
    super.key,
    required this.header,
    required this.onAddItemClick,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 24),
        header,
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppLocalizations.of(context)!.days_label,
              style: Theme.of(context).textTheme.labelMedium,
            ),
            GestureDetector(
              onTapUp: (x) => onAddItemClick(x),
              child: Container(
                height: 40,
                padding: const EdgeInsets.only(left: 12, right: 12),
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(10),
                        blurRadius: 2,
                      )
                    ]),
                child: Center(
                  child: Text(
                    AppLocalizations.of(context)!.add_new,
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ),
              ),
            )
          ],
        ),
      ],
    );
  }
}
