import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future<int?> showPersonalRecordActionsMenu(
    BuildContext context, Offset offset) async {
  return showMenu(
    context: context,
    useRootNavigator: true,
    position: RelativeRect.fromLTRB(
      offset.dx,
      offset.dy,
      MediaQuery.of(context).size.width - offset.dx,
      MediaQuery.of(context).size.height - offset.dy,
    ),
    items: [
      PopupMenuItem<int>(
        value: 0,
        child: Text(AppLocalizations.of(context)!.update),
      ),
      PopupMenuItem<int>(
        value: 1,
        child: Text(
          AppLocalizations.of(context)!.delete,
          style: TextStyle(color: Theme.of(context).colorScheme.error),
        ),
      ),
    ],
    elevation: 8.0,
  );
}
