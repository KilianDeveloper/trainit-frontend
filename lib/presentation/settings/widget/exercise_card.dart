import 'package:flutter/material.dart';
import 'package:trainit/data/model/exercise.dart';
import 'package:trainit/data/model/training_set.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:trainit/presentation/shared/export/dialogs.dart';

class ExerciseCard extends StatefulWidget {
  final Exercise exercise;
  final bool isSuperset;
  final bool isSelected;
  final bool canToggleSuperset;
  final void Function(Exercise?, bool) onChange;
  final void Function() onTrailingClick;
  final String saveName;
  ExerciseCard({
    super.key,
    required this.exercise,
    required this.isSelected,
    required this.onChange,
    required this.onTrailingClick,
    required this.isSuperset,
    required this.canToggleSuperset,
  }) : saveName = exercise.name;

  @override
  State<ExerciseCard> createState() => _ExerciseCardState();
}

class _ExerciseCardState extends State<ExerciseCard> {
  TextEditingController? nameController;

  @override
  void dispose() {
    nameController?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.exercise.name);
    nameController!.addListener(() => rename(nameController!.value.text));
  }

  void changeSet(int index, int value) {
    final sets = widget.exercise.sets;
    sets[index] = TrainingSet(repetitions: value);
    widget.onChange(
      Exercise(
        id: widget.exercise.id,
        name: widget.exercise.name,
        sets: sets,
      ),
      widget.isSuperset,
    );
  }

  void addSet() {
    final newSets = widget.exercise.sets;
    newSets.add(TrainingSet(repetitions: 10));
    widget.onChange(
      Exercise(
        id: widget.exercise.id,
        name: widget.exercise.name,
        sets: newSets,
      ),
      widget.isSuperset,
    );
  }

  void removeSet() {
    final newSets = widget.exercise.sets;
    newSets.removeLast();
    widget.onChange(
      Exercise(
        id: widget.exercise.id,
        name: widget.exercise.name,
        sets: newSets,
      ),
      widget.isSuperset,
    );
  }

  void removeSelf() async {
    final shouldDelete = await showDeleteDialog(
      context,
      AppLocalizations.of(context)!.delete_exercise_confirmation_title,
      AppLocalizations.of(context)!
          .delete_exercise_confirmation_message(widget.exercise.name),
    );
    if (shouldDelete == true) widget.onChange(null, false);
  }

  void rename(String name) {
    widget.onChange(
      Exercise(
        id: widget.exercise.id,
        name: name,
        sets: widget.exercise.sets,
      ),
      widget.isSuperset,
    );
  }

  void toggleSuperset(bool? value) {
    widget.onChange(
      widget.exercise,
      value ?? false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final sets = widget.exercise.sets.asMap().entries.map<Widget>((entry) =>
        _buildSet(context, entry.value, (p0) => changeSet(entry.key, p0)));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          contentPadding: const EdgeInsets.all(0),
          /*leading: IconButton(
            icon: const Icon(Icons.drag_indicator_rounded),
            onPressed: () {},
          ),*/ //TODO drag
          title: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(widget.exercise.name),
              const SizedBox(width: 8),
              Chip(
                label: Text(
                  AppLocalizations.of(context)!.number_sets_short(sets.length),
                ),
              ),
              if (widget.isSuperset) const SizedBox(width: 8),
            ],
          ),
          trailing: AnimatedRotation(
            turns: widget.isSelected ? 0 : .25,
            duration: const Duration(milliseconds: 100),
            child: IconButton(
              icon: const Icon(Icons.expand_more_rounded),
              onPressed: widget.onTrailingClick,
            ),
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 200),
          child: Container(
            height: widget.isSelected ? null : 0,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ..._buildHeader(context),
                _buildNumberOfSets(context),
                ...sets,
                _buildSuperset(context),
                const SizedBox(height: 8),
                _buildDelete(context),
                const SizedBox(height: 16),
              ],
            ),
          ),
        )
      ],
    );
  }

  Align _buildDelete(BuildContext context) {
    return Align(
      child: TextButton(
        onPressed: removeSelf,
        style: TextButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.onError,
          foregroundColor: Theme.of(context).colorScheme.error,
        ),
        child: Text(
          (AppLocalizations.of(context)!.remove),
        ),
      ),
    );
  }

  Widget _buildSet(
      BuildContext context, TrainingSet s, Function(int) onChange) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 72,
          child: Text(
              AppLocalizations.of(context)!.set_label(s.visibleRepetitions)),
        ),
        Expanded(
            child: Slider(
          value: s.visibleRepetitions.toDouble(),
          onChanged: (val) {
            onChange(val.toInt() != 0 ? val.toInt() : -1);
          },
          min: 0,
          max: 30,
          activeColor: Theme.of(context).colorScheme.secondary,
          inactiveColor: Theme.of(context).colorScheme.background,
          thumbColor: Theme.of(context).colorScheme.primary,
        )),
      ],
    );
  }

  Widget _buildSuperset(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(AppLocalizations.of(context)!.label_superset),
        const Spacer(),
        Checkbox(
          value: widget.isSuperset,
          onChanged: widget.canToggleSuperset ? toggleSuperset : null,
        ),
      ],
    );
  }

  Widget _buildName(BuildContext context) {
    return TextFormField(
      key: ValueKey(widget.exercise.id),
      controller: nameController,
      decoration: InputDecoration(
        filled: true,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
          borderSide: BorderSide.none,
        ),
        hintText: AppLocalizations.of(context)!.name_placeholder,
        hintStyle: Theme.of(context)
            .textTheme
            .titleMedium
            ?.copyWith(color: Theme.of(context).colorScheme.onSurface),
      ),
    );
  }

  List<Widget> _buildHeader(BuildContext context) {
    return [
      Text(
        AppLocalizations.of(context)!.name_label,
        style: Theme.of(context).textTheme.labelMedium,
      ),
      _buildName(context),
    ];
  }

  Widget _buildNumberOfSets(BuildContext context) {
    return Row(
      children: [
        Text(
          AppLocalizations.of(context)!
              .number_sets_label(widget.exercise.sets.length),
        ),
        const Spacer(),
        IconButton(
          onPressed: widget.exercise.sets.length > 1 ? removeSet : null,
          color: Theme.of(context).colorScheme.primary,
          icon: const Icon(Icons.remove_circle_rounded),
        ),
        IconButton(
          onPressed: widget.exercise.sets.length < 10 ? addSet : null,
          color: Theme.of(context).colorScheme.primary,
          icon: const Icon(Icons.add_circle_rounded),
        ),
      ],
    );
  }
}
