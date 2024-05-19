import 'package:flutter/material.dart';
import 'package:trainit/data/model/training_plan.dart';

class TrainingPlanCard extends StatelessWidget {
  final TrainingPlan trainingPlan;
  final Widget bottomButton;
  const TrainingPlanCard({
    super.key,
    required this.trainingPlan,
    required this.bottomButton,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.fromLTRB(0, 8, 0, 8),
      child: Container(
        padding: const EdgeInsets.all(20),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              trainingPlan.name,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: trainingPlan.days.activeDays.entries
                  .map<Widget>(
                      (value) => _buildDay(context, value.key, value.value))
                  .toList(),
            ),
            Center(child: bottomButton)
          ],
        ),
      ),
    );
  }

  Widget _buildDay(BuildContext context, String key, bool value) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        color: value
            ? Theme.of(context).colorScheme.primaryContainer
            : Colors.transparent,
      ),
      child: Center(
        child: Text(
          key,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: value
                  ? Theme.of(context).colorScheme.onPrimaryContainer
                  : Theme.of(context).colorScheme.onBackground),
        ),
      ),
    );
  }
}
