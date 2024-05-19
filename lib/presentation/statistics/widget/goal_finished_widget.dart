import 'package:flutter/material.dart';
import 'package:trainit/data/model/dto/finished_goal.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GoalFinishedWidget extends StatelessWidget {
  final FinishedGoal goal;
  final Function() onShareClick;
  final Function() onCollapseClick;
  const GoalFinishedWidget({
    super.key,
    required this.goal,
    required this.onCollapseClick,
    required this.onShareClick,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(AppLocalizations.of(context)!.goal_finished_text),
        const SizedBox(height: 20),
        _buildCardImage(context),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            FilledButton.icon(
              onPressed: onShareClick,
              icon: const Icon(Icons.ios_share_rounded),
              label: Text(AppLocalizations.of(context)!.share),
            ),
            FilledButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
                foregroundColor: Theme.of(context).colorScheme.onSecondary,
                backgroundColor: Theme.of(context).colorScheme.secondary,
              ),
              child: Text(AppLocalizations.of(context)!.go_back),
            )
          ],
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildCardImage(BuildContext context) {
    final image = Image.memory(goal.imageBytes);
    return image;
  }
}
