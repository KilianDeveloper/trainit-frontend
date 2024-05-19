import 'package:flutter/material.dart';
import 'package:trainit/presentation/shared/export/svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EmptyPersonalRecordList extends StatelessWidget {
  const EmptyPersonalRecordList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 32,
        ),
        const CenterSvg(path: "assets/empty.svg"),
        const SizedBox(
          height: 16,
        ),
        Text(
          AppLocalizations.of(context)!.empty_personal_records_title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        Text(
          AppLocalizations.of(context)!.empty_personal_records_message,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(
          height: 100,
        ),
      ],
    );
  }
}
