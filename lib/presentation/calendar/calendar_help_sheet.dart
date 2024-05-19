import 'package:flutter/material.dart';
import 'package:trainit/presentation/calendar/widget/calendar_help.dart';
import 'package:trainit/presentation/shared/export/bottom_sheet_page.dart';

Future<void> showCalendarHelpSheet(BuildContext context) async {
  return await showModalBottomSheet(
    context: context,
    useRootNavigator: true,
    isDismissible: true,
    isScrollControlled: true,
    constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height - 60,
        minWidth: MediaQuery.of(context).size.width),
    builder: (context) {
      return const BottomSheetPage(
        child: CalendarHelp(),
      );
    },
  );
}
