import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:trainit/presentation/shared/export/tutorial_dialog.dart';

Widget bottomNavigationBar(
    BuildContext context, int selectedIndex, void Function(int) onTap) {
  return Container(
    decoration: BoxDecoration(
      boxShadow: <BoxShadow>[
        BoxShadow(
          color: Colors.black.withAlpha(10),
          blurRadius: 10,
        ),
      ],
    ),
    child: NavigationBar(
      destinations: <NavigationDestination>[
        NavigationDestination(
          icon: Icon(
            Icons.bar_chart_rounded,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          label: AppLocalizations.of(context)!.statistics_title,
        ),
        NavigationDestination(
          icon: Icon(
            Icons.house_rounded,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          label: AppLocalizations.of(context)!.home_title,
        ),
        NavigationDestination(
          icon: TutorialEmbed(
            tutorialId: "navigate_account",
            child: Icon(
              Icons.person_rounded,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          label: AppLocalizations.of(context)!.account_title,
        ),
      ],
      onDestinationSelected: onTap,
      selectedIndex: selectedIndex,
    ),
  );
}
