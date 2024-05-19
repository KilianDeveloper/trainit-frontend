import 'package:flutter/material.dart';
import 'package:trainit/data/model/account.dart';
import 'package:trainit/data/model/training.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:trainit/presentation/settings/widget/training_menu.dart';
import 'package:trainit/presentation/settings/widget/week_menu.dart';
import 'package:trainit/presentation/shared/export/dialogs.dart';

class TrainingCard extends StatelessWidget {
  final Training training;
  final Account account;
  final void Function() onClick;
  final void Function(int) onMove;
  final void Function() onDeleteClick;

  const TrainingCard({
    super.key,
    required this.training,
    required this.account,
    required this.onClick,
    required this.onDeleteClick,
    required this.onMove,
  });

  Future<void> _delete(BuildContext context) async {
    final shouldDelete = await showDeleteDialog(
      context,
      AppLocalizations.of(context)!.delete_training_confirmation_title,
      AppLocalizations.of(context)!
          .delete_training_confirmation_message(training.name),
    );
    if (shouldDelete == true) onDeleteClick();
  }

  Future<void> _move(BuildContext context, Offset displayOffset) async {
    final result2 = await showWeekMenu(context, displayOffset);
    if (result2 == null) return;
    onMove(result2);
  }

  Future<void> _showActionsMenu(BuildContext context, Offset offset) async {
    final result = await showTrainingMenu(context, offset);
    switch (result) {
      case 0:
        onClick();
        break;
      case 1:
        if (context.mounted) _move(context, offset);
        break;
      case 2:
        if (context.mounted) _delete(context);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: Card(
        key: key,
        margin: const EdgeInsets.fromLTRB(0, 8, 0, 8),
        child: Container(
          padding: const EdgeInsets.all(20),
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      training.name,
                      style: Theme.of(context).textTheme.titleMedium,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    Chip(
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      label: Text(
                        AppLocalizations.of(context)!
                            .exercises(training.exercises.length),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSecondary),
                      ),
                      elevation: 6.0,
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Align(
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTapUp: (details) =>
                            _showActionsMenu(context, details.globalPosition),
                        onTap: () {},
                        highlightColor: Theme.of(context)
                            .colorScheme
                            .secondary
                            .withAlpha(70),
                        splashColor: Theme.of(context)
                            .colorScheme
                            .secondary
                            .withAlpha(70),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(24)),
                        child: SizedBox(
                          height: 48,
                          width: 48,
                          child: Icon(
                            Icons.more_vert_rounded,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
