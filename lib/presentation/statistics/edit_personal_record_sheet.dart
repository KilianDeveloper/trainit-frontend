import 'package:flutter/material.dart';
import 'package:trainit/data/model/dto/personal_record_creation.dart';
import 'package:trainit/data/model/personal_record.dart';
import 'package:trainit/presentation/shared/export/bottom_sheet_page.dart';
import 'package:trainit/presentation/statistics/widget/personal_record_form.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future<PersonalRecordCreation?> showPersonalRecordSheet(
    BuildContext givenContext, PersonalRecord? personalRecord) async {
  return await showModalBottomSheet<PersonalRecordCreation?>(
    context: givenContext,
    useRootNavigator: true,
    isDismissible: false,
    isScrollControlled: true,
    constraints: BoxConstraints(
      maxHeight: MediaQuery.of(givenContext).size.height -
          60, // here increase or decrease in width
    ),
    builder: (context) {
      return BottomSheetPage(
        title: personalRecord == null
            ? AppLocalizations.of(context)!.create_personal_record_title
            : AppLocalizations.of(context)!.edit_personal_record_title,
        child: PersonalRecordForm(
          name: personalRecord?.name,
          value: personalRecord?.value,
          unit: personalRecord?.unit,
          onCreateClick: (name, value, unit) {
            Navigator.pop(
              context,
              PersonalRecordCreation(
                name: name,
                value: value,
                unit: unit,
              ),
            );
          },
        ),
      );
    },
  );
}
