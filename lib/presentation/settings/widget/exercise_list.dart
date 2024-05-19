import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:trainit/data/model/dto/exercise_list_value.dart';
import 'package:trainit/data/model/exercise.dart';
import 'package:trainit/presentation/settings/widget/exercise_card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:trainit/presentation/settings/widget/superset_divider.dart';
import 'package:trainit/presentation/shared/export/animations.dart';
import 'package:trainit/presentation/shared/export/validation_error_card.dart';
import 'package:trainit/presentation/shared/export/validators.dart';

class ExerciseFormList extends FormField<ExerciseList> {
  ExerciseFormList({
    super.key,
    required BuildContext context,
    required FormFieldSetter<ExerciseList> onSaved,
    ExerciseList initialValue = const ExerciseList(
      exercises: [],
      supersetIndexes: [],
    ),
    AutovalidateMode autovalidate = AutovalidateMode.always,
  }) : super(
          onSaved: onSaved,
          validator: (value) => Validators.validateExerciseList(value, context),
          initialValue: initialValue,
          autovalidateMode: autovalidate,
          builder: (FormFieldState<ExerciseList> state) {
            final errorText = state.hasError && state.errorText != null
                ? AppLocalizations.of(context)!.exercise_not_valid(state
                    .value!
                    .exercises[int.parse(state.errorText!.split("DATA")[0])]
                    .name)
                : null;
            return _ExerciseAnimatedList(
              errorText: errorText,
              items: state.value?.exercises,
              onUpdate: (e, s) => state.didChange(ExerciseList(
                exercises: e,
                supersetIndexes: s,
              )),
              supersetIndexes: state.value?.supersetIndexes,
            );
          },
        );
}

class _ExerciseAnimatedList extends StatefulWidget {
  final List<Exercise>? items;
  final List<int>? supersetIndexes;

  final Function(List<Exercise>, List<int>) onUpdate;
  final String? errorText;
  const _ExerciseAnimatedList({
    required this.items,
    required this.onUpdate,
    required this.errorText,
    required this.supersetIndexes,
  });

  @override
  State<_ExerciseAnimatedList> createState() => _ExerciseAnimatedListState();
}

class _ExerciseAnimatedListState extends State<_ExerciseAnimatedList> {
  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();
  List<Exercise> _items = [];
  List<int> _supersets = [];

  int? selectedIndex;

  @override
  void initState() {
    _items = widget.items ?? [];
    _supersets = widget.supersetIndexes ?? [];
    super.initState();
  }

  void addItem() {
    setState(() {
      final isEmpty = (widget.items?.length ?? 0) == 0;
      final index = isEmpty ? 0 : widget.items!.length;
      listKey.currentState!
          .insertItem(index, duration: const Duration(milliseconds: 100));
      _items.add(Exercise.newEntity());
      widget.onUpdate(_items, _supersets);
    });
  }

  void deleteItem(int index, MapEntry<int, Exercise> entry) {
    setState(() {
      listKey.currentState!.removeItem(
        0,
        (_, animation) => buildListTransition(
          entry.value.id,
          animation,
          child: ExerciseCard(
            exercise: entry.value,
            isSuperset: _supersets.contains(index),
            isSelected: selectedIndex == index,
            onChange: (_, __) {},
            onTrailingClick: () {},
            canToggleSuperset: false,
          ),
        ),
        duration: const Duration(milliseconds: 100),
      );
      _items.removeAt(index);

      _supersets = _supersets.where((element) => element != index).toList();
      widget.onUpdate(_items, _supersets);
    });
  }

  void updateItem(int index, Exercise value, bool isSuperset) {
    setState(() {
      _items[index] = value;
      if (!_supersets.contains(index) && isSuperset) {
        final newSupersets = _supersets;
        newSupersets.add(index);
        _supersets = newSupersets;
      } else if (_supersets.contains(index) && !isSuperset) {
        final newSupersets = _supersets;
        newSupersets.remove(index);
        _supersets = newSupersets;
      }

      widget.onUpdate(_items, _supersets);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          if (widget.errorText != null) ValidationErrorCard(widget.errorText!),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context)!.exercises(
                  widget.items?.length ?? 1,
                ),
                style: Theme.of(context).textTheme.labelMedium,
              ),
              FilledButton(
                onPressed: addItem,
                style: FilledButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  foregroundColor: Theme.of(context).colorScheme.onSecondary,
                ),
                child: Text(AppLocalizations.of(context)!.add_new),
              )
            ],
          ),
          Expanded(
            child: AnimatedList(
              key: listKey,
              initialItemCount: _items.length,
              itemBuilder: (context, index, animation) {
                final entry = MapEntry(
                  index,
                  _items[index],
                );
                final item = buildListTransition(
                  entry.value.id,
                  animation,
                  child: ExerciseCard(
                    exercise: entry.value,
                    isSelected: selectedIndex == index,
                    isSuperset: _supersets.contains(index),
                    canToggleSuperset: index < _items.length - 1,
                    onTrailingClick: () {
                      setState(() {
                        selectedIndex = selectedIndex == index ? null : index;
                      });
                    },
                    onChange: (value, isSuperset) {
                      if (value != null) {
                        updateItem(index, value, isSuperset);
                      } else {
                        deleteItem(index, entry);
                      }
                    },
                  ),
                );
                if (index == _items.length - 1) {
                  return item;
                } else {
                  return Column(
                    children: [
                      item,
                      SupersetDivider(
                        isSuperset: _supersets.contains(index),
                        onUnlinkClick: () {
                          updateItem(index, entry.value, false);
                          Fluttertoast.showToast(
                              msg: "Deleted Superset",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER);
                        },
                      ),
                    ],
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
