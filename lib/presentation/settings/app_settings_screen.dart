import 'package:flutter/material.dart';
import 'package:trainit/data/model/account.dart';
import 'package:trainit/data/model/dto/authentication_user.dart';
import 'package:trainit/presentation/settings/widget/app_settings_form.dart';
import 'package:trainit/presentation/shared/export/page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AppSettingsScreen extends StatelessWidget {
  final ThemeMode theme;
  final Account account;
  final AuthenticationUser user;
  final String supportMail;
  final String version;
  final String termsOfServiceLink;
  final String privacyPolicyLink;
  final Function(ThemeMode) changeTheme;
  final Function() signOut;

  const AppSettingsScreen({
    super.key,
    required this.account,
    required this.version,
    required this.user,
    required this.theme,
    required this.supportMail,
    required this.termsOfServiceLink,
    required this.privacyPolicyLink,
    required this.changeTheme,
    required this.signOut,
  });

  @override
  Widget build(BuildContext context) {
    return ContentPage(
      title: AppLocalizations.of(context)!.settings_title,
      content: AppSettingsForm(
        account: account,
        user: user,
        theme: theme,
        supportMail: supportMail,
        version: version,
        termsOfServiceLink: termsOfServiceLink,
        privacyPolicyLink: privacyPolicyLink,
        onThemeChange: changeTheme,
        onSignOutClick: signOut,
      ),
    );
  }
}
