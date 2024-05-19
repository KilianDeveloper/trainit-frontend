import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EditPhotoActionSheet extends StatelessWidget {
  final Function() onUpdateClick;
  final Function() onDeleteClick;
  final bool canBeDeleted;
  const EditPhotoActionSheet({
    super.key,
    required this.canBeDeleted,
    required this.onDeleteClick,
    required this.onUpdateClick,
  });

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.error;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          AppLocalizations.of(context)!.edit_profile_photo_title,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: TextButton.icon(
            onPressed: onUpdateClick,
            icon: const Icon(Icons.add_a_photo_rounded),
            label: Text(AppLocalizations.of(context)!.add_profile_photo),
            style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.bodyLarge),
          ),
        ),
        if (!canBeDeleted)
          SizedBox(
            width: double.infinity,
            child: TextButton.icon(
              onPressed: onDeleteClick,
              icon: const Icon(Icons.delete),
              label: Text(AppLocalizations.of(context)!.delete_profile_photo),
              style: TextButton.styleFrom(
                  iconColor: color,
                  foregroundColor: color,
                  textStyle: Theme.of(context).textTheme.bodyLarge),
            ),
          ),
        const SizedBox(height: 8),
      ],
    );
  }
}
