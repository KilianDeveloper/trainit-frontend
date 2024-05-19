import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:trainit/data/model/personal_record.dart';

Future<bool?> showDeletePersonalRecordDialog(
  BuildContext context,
  PersonalRecord personalRecord,
) async {
  return await showDialog<bool?>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(AppLocalizations.of(context)!.delete_personal_record_title),
        content: Text(
          AppLocalizations.of(context)!
              .delete_personal_record_message(personalRecord.name),
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: Text(AppLocalizations.of(context)!.no),
            onPressed: () {
              Navigator.of(context).pop(null);
            },
          ),
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: Text(AppLocalizations.of(context)!.yes),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          ),
        ],
      );
    },
  );
}
