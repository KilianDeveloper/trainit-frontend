import 'package:flutter/material.dart';
import 'package:trainit/presentation/shared/export/svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EmailNotVerifiedPlaceholder extends StatelessWidget {
  const EmailNotVerifiedPlaceholder({
    super.key,
    required this.onCheckVerificationClick,
    required this.onSendVerificationMailClick,
  });

  final Function() onCheckVerificationClick;
  final Function() onSendVerificationMailClick;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CenterSvg(path: "assets/mail.svg"),
            const SizedBox(height: 32),
            Text(
              AppLocalizations.of(context)!.check_inbox,
              style: Theme.of(context).textTheme.titleLarge,
            )
          ],
        )),
        Expanded(
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            ElevatedButton(
                onPressed: onCheckVerificationClick,
                child: Text(AppLocalizations.of(context)!.check_verification)),
            TextButton(
                onPressed: onSendVerificationMailClick,
                child: Text(AppLocalizations.of(context)!.send_again))
          ]),
        ),
      ],
    );
  }
}
