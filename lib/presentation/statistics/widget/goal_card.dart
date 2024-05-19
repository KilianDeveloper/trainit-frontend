import 'package:flutter/material.dart';
import 'package:trainit/data/model/goal.dart';
import 'package:trainit/presentation/shared/export/strings.dart';

class GoalCard extends StatelessWidget {
  final Goal goal;
  final double? currentValue;
  const GoalCard({super.key, required this.currentValue, required this.goal});

  @override
  Widget build(BuildContext context) {
    final difference = (goal.to - goal.from).abs();
    final currentDifference2 =
        currentValue != null ? (goal.from - currentValue!).abs() : 0;

    double progress = currentDifference2 / difference;
    if (progress < 0) progress = 0;
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Now",
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    Text(
                      currentValue != null
                          ? "${currentValue.toString()} ${EnumStringProvider.getUnitName(goal.unit, context)}"
                          : "unknown",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold),
                      softWrap: true,
                    ),
                  ],
                ),
                if (currentValue != null)
                  Expanded(
                    child: SizedBox(
                      height: 56,
                      width: 56,
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: CircularProgressIndicator(
                              value: progress,
                              strokeWidth: 6,
                            ),
                          ),
                          Align(
                            child: Text(
                              "${(progress * 100).toInt()}%",
                              style: Theme.of(context).textTheme.labelSmall,
                            ),
                          )
                        ],
                      ),
                    ),
                  )
              ],
            ),
            const Spacer(),
            Text(
              goal.name ?? "unknown",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              "${goal.to.toString()} ${EnumStringProvider.getUnitName(goal.unit, context)}",
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
