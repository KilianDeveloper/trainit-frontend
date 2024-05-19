import 'package:flutter/material.dart';
import 'package:trainit/presentation/authentication/widgets/email_not_verified_placeholder.dart';
import 'package:trainit/presentation/shared/export/page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EmailVerificationScreen extends StatelessWidget {
  final Function() onSendVerificationMailClick;
  final Function() onCheckVerificationClick;

  const EmailVerificationScreen({
    super.key,
    required this.onSendVerificationMailClick,
    required this.onCheckVerificationClick,
  });

  @override
  Widget build(BuildContext context) {
    return ContentPage(
      title: AppLocalizations.of(context)!.email_verification_title,
      content: EmailNotVerifiedPlaceholder(
        onCheckVerificationClick: onCheckVerificationClick,
        onSendVerificationMailClick: onSendVerificationMailClick,
      ),
    );
  }
}
