import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:trainit/data/model/training.dart';
import 'package:trainit/data/model/training_plan.dart';

class ProfileTrainingDayCard extends StatelessWidget {
  final TrainingPlan trainingPlan;
  final int index;
  final Function(Training) onClick;
  ProfileTrainingDayCard({
    super.key,
    required this.trainingPlan,
    required this.index,
    required this.onClick,
  });

  final monday = DateTime(2024, 1, 1);
  final weekdayFormat = DateFormat('EEEE');

  @override
  Widget build(BuildContext context) {
    final trainings = trainingPlan.days.atIndex(index);
    if (trainings.isEmpty) {
      return const SizedBox();
    }
    final widgets = trainings.map((e) => _buildTrainingCard(context, e));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(weekdayFormat.format(monday.add(Duration(days: index)))),
        Row(
          children: [...widgets],
        )
      ],
    );
  }

  Widget _buildTrainingCard(BuildContext context, Training training) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
      color: Theme.of(context).colorScheme.secondary,
      child: InkWell(
        splashColor: Theme.of(context).colorScheme.secondaryContainer,
        highlightColor: Theme.of(context).colorScheme.secondaryContainer,
        onTap: () {
          onClick(training);
        },
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: 160,
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Text(
                training.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Symbols.exercise_rounded,
                    size: 30,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    training.exercises.length.toString(),
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.w600),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
