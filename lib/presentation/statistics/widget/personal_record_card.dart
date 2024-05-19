import 'package:flutter/material.dart';
import 'package:trainit/data/model/personal_record.dart';
import 'package:trainit/data/model/units.dart';
import 'package:trainit/presentation/shared/export/strings.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:trainit/presentation/statistics/widget/delete_personal_record_dialog.dart';
import 'package:trainit/presentation/statistics/widget/personal_record_actions_menu.dart';

class PersonalRecordCard extends StatefulWidget {
  final PersonalRecord personalRecord;
  final WeightUnit displayWeightUnit;
  final bool canBecomeFavorite;
  final Function(String, bool) onFavoriteUpdate;
  final Function() onUpdateClick;
  final Function() onDeleteClick;

  const PersonalRecordCard({
    Key? key,
    required this.personalRecord,
    required this.onFavoriteUpdate,
    required this.displayWeightUnit,
    required this.canBecomeFavorite,
    required this.onUpdateClick,
    required this.onDeleteClick,
  }) : super(key: key);

  @override
  State<PersonalRecordCard> createState() => _PersonalRecordCardState();
}

class _PersonalRecordCardState extends State<PersonalRecordCard> {
  bool isClicked = false;
  _showPopupMenu(BuildContext context, Offset offset) async {
    int? selected = await showPersonalRecordActionsMenu(context, offset);
    _setFocus(false);
    if (selected == 0) {
      widget.onUpdateClick();
    } else if (selected == 1) {
      if (context.mounted) {
        final deleteConfirmation = await showDeletePersonalRecordDialog(
            context, widget.personalRecord);
        if (deleteConfirmation == true) {
          widget.onDeleteClick();
        }
      }
    }
  }

  _setFocus(bool value) {
    setState(() {
      isClicked = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final dayDifference =
        widget.personalRecord.date.difference(DateTime.now()).inDays.abs();
    return AnimatedScale(
      scale: isClicked ? .98 : 1,
      duration: const Duration(milliseconds: 150),
      child: Card(
        margin: const EdgeInsets.fromLTRB(0, 8, 0, 8),
        child: InkWell(
          onTapDown: (TapDownDetails details) {
            _showPopupMenu(context, details.globalPosition);
            _setFocus(true);
          },
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${widget.personalRecord.name}: ${widget.personalRecord.value} ${EnumStringProvider.getUnitName(widget.personalRecord.unit, context)}",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Chip(
                      label: Text(
                        AppLocalizations.of(context)!.days_ago(dayDifference),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSecondary),
                      ),
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      elevation: 6.0,
                    )
                  ],
                ),
                IconButton(
                  onPressed: widget.canBecomeFavorite ||
                          widget.personalRecord.isFavorite
                      ? () => widget.onFavoriteUpdate(
                          widget.personalRecord.name,
                          !widget.personalRecord.isFavorite)
                      : null,
                  icon: Icon(
                    widget.personalRecord.isFavorite
                        ? Icons.star_rounded
                        : Icons.star_border_rounded,
                  ),
                  color: Theme.of(context).colorScheme.primary,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
