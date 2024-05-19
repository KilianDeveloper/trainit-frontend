import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future<int?> showTrainingMenu(BuildContext context, Offset offset) async {
  return await showMenu<int>(
    context: context,
    position: RelativeRect.fromLTRB(
      offset.dx,
      offset.dy,
      MediaQuery.of(context).size.width - offset.dx,
      MediaQuery.of(context).size.height - offset.dy,
    ),
    items: [
      PopupMenuItem(
        value: 0,
        child: Text(AppLocalizations.of(context)!.edit),
      ),
      PopupMenuItem(
        value: 1,
        child: Text(AppLocalizations.of(context)!.move),
      ),
      PopupMenuItem(
        value: 2,
        child: Text(
          AppLocalizations.of(context)!.delete,
          style: Theme.of(context)
              .textTheme
              .labelLarge
              ?.copyWith(color: Theme.of(context).colorScheme.error),
        ),
      ),
    ],
  );
}
