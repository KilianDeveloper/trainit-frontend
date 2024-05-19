import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:trainit/data/model/account.dart';
import 'package:trainit/data/model/training_plan.dart';
import 'package:trainit/data/model/units.dart';
import 'package:trainit/presentation/settings/widget/account_form.dart';
import 'package:trainit/presentation/shared/export/page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AccountScreen extends StatelessWidget {
  final Account account;
  final TrainingPlan trainingPlan;
  final Uint8List? profilePhoto;
  final Function(TrainingPlan) selectTrainingPlan;
  final Function() signOut;
  final Function() navigateToSettings;
  final Function(WeightUnit, int, int) saveAccount;
  final Function(Uint8List?) saveProfilePhoto;
  final Function() showFriendList;
  final Function() loadProfileScreen;

  const AccountScreen({
    super.key,
    required this.account,
    required this.trainingPlan,
    required this.profilePhoto,
    required this.selectTrainingPlan,
    required this.signOut,
    required this.saveAccount,
    required this.navigateToSettings,
    required this.saveProfilePhoto,
    required this.showFriendList,
    required this.loadProfileScreen,
  });

  @override
  Widget build(BuildContext context) {
    return ContentPage(
      title: AppLocalizations.of(context)!.account_title,
      content: AccountForm(
        account: account,
        profilePhoto: profilePhoto,
        trainingPlan: trainingPlan,
        onSelectTrainingPlan: selectTrainingPlan,
        onSignOutClick: signOut,
        onSave: saveAccount,
        onSaveProfilePhoto: saveProfilePhoto,
        onShowFriendListClick: showFriendList,
        onLoadProfileClick: loadProfileScreen,
      ),
      appBarActions: [
        IconButton(
          onPressed: navigateToSettings,
          icon: const Icon(Icons.settings_rounded),
        )
      ],
    );
  }
}
