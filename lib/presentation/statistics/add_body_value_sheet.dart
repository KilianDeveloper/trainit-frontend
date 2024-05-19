import 'package:flutter/material.dart';
import 'package:trainit/data/model/body_value.dart';
import 'package:trainit/data/model/dto/body_value_collection.dart';
import 'package:trainit/presentation/shared/export/bottom_sheet_page.dart';
import 'package:trainit/presentation/statistics/widget/body_value_form.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future<BodyValue?> showBodyValueSheet(
  BuildContext givenContext,
  BodyValueCollection bodyValues,
) async {
  return await showModalBottomSheet<BodyValue?>(
    context: givenContext,
    useRootNavigator: true,
    isDismissible: false,
    isScrollControlled: true,
    constraints: BoxConstraints(
      maxHeight: MediaQuery.of(givenContext).size.height - 60,
    ),
    builder: (context) {
      return BottomSheetPage(
        title: AppLocalizations.of(context)!.create_body_value_title,
        child: BodyValueForm(
          bodyValues: bodyValues,
          onCreateClick: (type, value) {
            Navigator.pop(
              context,
              BodyValue(
                type: type,
                value: value,
                date: DateTime.now(),
              ),
            );
          },
        ),
      );
    },
  );
}
