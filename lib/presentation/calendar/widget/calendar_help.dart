import 'package:flutter/material.dart';
import 'package:trainit/presentation/shared/export/help_page.dart';
import 'package:trainit/presentation/shared/export/help_page_manager.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CalendarHelp extends StatefulWidget {
  const CalendarHelp({super.key});

  @override
  State<CalendarHelp> createState() => _CalendarHelpState();
}

class _CalendarHelpState extends State<CalendarHelp> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return HelpPageManager(
      title: AppLocalizations.of(context)!.help,
      pages: [
        HelpPage(
          name: AppLocalizations.of(context)!.calendar_help_1_title,
          content: AppLocalizations.of(context)!.calendar_help_1_message,
        ),
        HelpPage(
          name: AppLocalizations.of(context)!.calendar_help_2_title,
          content: AppLocalizations.of(context)!.calendar_help_2_message,
        ),
        HelpPage(
          name: AppLocalizations.of(context)!.calendar_help_3_title,
          content: AppLocalizations.of(context)!.calendar_help_3_message,
        ),
      ],
    );
  }
}
