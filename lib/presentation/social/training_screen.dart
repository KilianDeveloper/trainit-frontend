import 'package:flutter/material.dart';
import 'package:trainit/data/model/account.dart';
import 'package:trainit/data/model/training.dart';
import 'package:trainit/presentation/shared/export/page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:trainit/presentation/social/widget/immutable_training_form.dart';

class TrainingScreen extends StatelessWidget {
  final Training training;
  final Account account;

  const TrainingScreen({
    super.key,
    required this.training,
    required this.account,
  });

  @override
  Widget build(BuildContext context) {
    return ContentPage(
      title: AppLocalizations.of(context)!.training_title(training.name),
      content: ImmutableTrainingForm(
        training: training,
        account: account,
      ),
    );
  }
}
