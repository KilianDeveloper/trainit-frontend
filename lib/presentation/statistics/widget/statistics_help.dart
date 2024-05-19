import 'package:flutter/material.dart';
import 'package:trainit/presentation/shared/style.dart';
import 'package:trainit/presentation/shared/export/help_page.dart';
import 'package:trainit/presentation/shared/export/help_page_manager.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future<void> showStatisticsHelp(BuildContext context) async {
  return showModalBottomSheet(
    context: context,
    useRootNavigator: true,
    isDismissible: true,
    isScrollControlled: true,
    constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height - 60,
        minWidth: MediaQuery.of(context).size.width),
    builder: (context) {
      return Padding(
        padding: screenPadding.add(
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom)),
        child: const StatisticsHelp(),
      );
    },
  );
}

class StatisticsHelp extends StatefulWidget {
  const StatisticsHelp({super.key});

  @override
  State<StatisticsHelp> createState() => _StatisticsHelpState();
}

class _StatisticsHelpState extends State<StatisticsHelp> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return HelpPageManager(
      title: "Help",
      pages: [
        HelpPage(
          name: AppLocalizations.of(context)!.statistics_help_1_title,
          content: AppLocalizations.of(context)!.statistics_help_1_message,
        ),
        HelpPage(
          name: AppLocalizations.of(context)!.statistics_help_2_title,
          content: AppLocalizations.of(context)!.statistics_help_2_message,
        ),
        HelpPage(
          name: AppLocalizations.of(context)!.statistics_help_3_title,
          content: AppLocalizations.of(context)!.statistics_help_3_message,
        ),
      ],
    );
  }
}
