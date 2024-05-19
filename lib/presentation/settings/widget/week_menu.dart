import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future<int?> showWeekMenu(BuildContext context, Offset offset) async {
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
        child: Text(AppLocalizations.of(context)!.monday),
      ),
      PopupMenuItem(
        value: 1,
        child: Text(AppLocalizations.of(context)!.tuesday),
      ),
      PopupMenuItem(
        value: 2,
        child: Text(AppLocalizations.of(context)!.wednesday),
      ),
      PopupMenuItem(
        value: 3,
        child: Text(AppLocalizations.of(context)!.thursday),
      ),
      PopupMenuItem(
        value: 4,
        child: Text(AppLocalizations.of(context)!.friday),
      ),
      PopupMenuItem(
        value: 5,
        child: Text(AppLocalizations.of(context)!.saturday),
      ),
      PopupMenuItem(
        value: 6,
        child: Text(AppLocalizations.of(context)!.sunday),
      ),
    ],
  );
}
