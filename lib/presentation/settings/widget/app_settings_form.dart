import 'package:flutter/material.dart';
import 'package:trainit/data/model/account.dart';
import 'package:trainit/data/model/dto/authentication_user.dart';
import 'package:trainit/presentation/shared/export/form_components.dart';
import 'package:trainit/presentation/shared/export/validators.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AppSettingsForm extends StatefulWidget {
  final ThemeMode theme;
  final Account account;
  final AuthenticationUser user;
  final String supportMail;
  final String version;
  final String termsOfServiceLink;
  final String privacyPolicyLink;
  final Function(ThemeMode) onThemeChange;
  final Function() onSignOutClick;

  const AppSettingsForm({
    super.key,
    required this.account,
    required this.user,
    required this.theme,
    required this.supportMail,
    required this.version,
    required this.termsOfServiceLink,
    required this.privacyPolicyLink,
    required this.onThemeChange,
    required this.onSignOutClick,
  });

  @override
  State<AppSettingsForm> createState() => _AppSettingsFormState();
}

class _AppSettingsFormState extends State<AppSettingsForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _buildDesignCard(context),
          const SizedBox(height: 32),
          _buildDocumentsCard(context),
          const SizedBox(height: 32),
          _buildContactCard(context),
          const SizedBox(height: 32),
          _buildAccountCard(context),
          const SizedBox(height: 32),
          _buildAboutCard(context),
          const SizedBox(height: 32),
        ]),
      ),
    );
  }

  Widget _buildDesignCard(BuildContext context) {
    return FormGroup(
      AppLocalizations.of(context)!.design_label,
      children: [
        FormItem(
          title: AppLocalizations.of(context)!.theme_label,
          content: Expanded(
            child: DropdownButtonFormField<ThemeMode>(
              decoration: InputDecoration(
                fillColor: Theme.of(context).colorScheme.surface,
                filled: true,
                border: const UnderlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  borderSide: BorderSide.none,
                ),
              ),
              style: Theme.of(context).textTheme.bodyLarge,
              isExpanded: true,
              borderRadius: const BorderRadius.all(Radius.circular(16)),
              validator: (value) => Validators.validateTheme(value, context),
              items: [
                DropdownMenuItem(
                  value: ThemeMode.light,
                  child: Text(AppLocalizations.of(context)!.theme_light),
                ),
                DropdownMenuItem(
                  value: ThemeMode.dark,
                  child: Text(AppLocalizations.of(context)!.theme_dark),
                ),
                DropdownMenuItem(
                  value: ThemeMode.system,
                  child: Text(AppLocalizations.of(context)!.theme_system),
                )
              ],
              value: widget.theme,
              onChanged: (data) {
                if (data != null) {
                  widget.onThemeChange(data);
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDocumentsCard(BuildContext context) {
    return FormGroup(
      AppLocalizations.of(context)!.documents_label,
      children: [
        FormItem(
          title: AppLocalizations.of(context)!.terms_label,
          content: TextButton(
            onPressed: () async {
              final uri = widget.termsOfServiceLink;
              if (await canLaunchUrlString(uri)) {
                await launchUrlString(uri);
              }
            },
            child: Text(AppLocalizations.of(context)!.view_browser),
          ),
        ),
        FormItem(
          title: AppLocalizations.of(context)!.privacy_label,
          content: TextButton(
            onPressed: () async {
              final uri = Uri.parse(widget.privacyPolicyLink);
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri);
              }
            },
            child: Text(AppLocalizations.of(context)!.view_browser),
          ),
        ),
      ],
    );
  }

  Widget _buildContactCard(BuildContext context) {
    return FormGroup(
      AppLocalizations.of(context)!.contact_label,
      children: [
        FormItem(
          title: AppLocalizations.of(context)!.email_label,
          content: SelectableText(
            widget.supportMail,
          ),
        ),
      ],
    );
  }

  String _buildMailString(BuildContext context) {
    final baseMail = widget.user.email ?? AppLocalizations.of(context)!.unknown;
    final splitted =
        (widget.user.email ?? AppLocalizations.of(context)!.unknown).split("@");
    return splitted.length == 2
        ? "${splitted[0][0]}...${splitted[0][splitted[0].length - 1]}@${splitted[1]}"
        : baseMail;
  }

  Widget _buildAccountCard(BuildContext context) {
    final mail = _buildMailString(context);
    return FormGroup(AppLocalizations.of(context)!.account_label, children: [
      FormItem(
        title: AppLocalizations.of(context)!.username_label,
        content: SelectableText(
          widget.account.username,
        ),
      ),
      FormItem(
        title: AppLocalizations.of(context)!.email_label,
        content: SelectableText(mail),
      ),
      Center(
        child: TextButton.icon(
          icon: const Icon(Icons.logout_rounded),
          label: Text(AppLocalizations.of(context)!.sign_out),
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.error,
          ),
          onPressed: () async {
            final result = await _showSignOutDialog(context);
            if (result == true) widget.onSignOutClick();
          },
        ),
      )
    ]);
  }

  Widget _buildAboutCard(BuildContext context) {
    return FormGroup(
      AppLocalizations.of(context)!.about_label,
      children: [
        FormItem(
          title: AppLocalizations.of(context)!.version_label,
          content: SelectableText(widget.version),
        ),
      ],
    );
  }

  Future<bool?> _showSignOutDialog(BuildContext context) {
    return showDialog<bool?>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.sign_out),
          content:
              Text(AppLocalizations.of(context)!.sign_out_confirmation_message),
          actions: [
            FilledButton(
              child: Text(AppLocalizations.of(context)!.no),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.error),
              child: Text(AppLocalizations.of(context)!.yes),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );
  }
}
