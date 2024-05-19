import 'package:flutter/material.dart';
import 'package:trainit/data/model/account.dart';
import 'package:trainit/data/model/training.dart';
import 'package:trainit/data/model/training_days.dart';
import 'package:trainit/helper/date.dart';
import 'package:trainit/presentation/settings/edit_training_sheet.dart';
import 'package:trainit/presentation/settings/widget/edit_training_plan_header.dart';
import 'package:trainit/presentation/settings/widget/training_card.dart';
import 'package:trainit/presentation/settings/widget/week_menu.dart';
import 'package:trainit/presentation/shared/export/animations.dart';
import 'package:trainit/presentation/shared/export/validation_error_view.dart';
import 'package:trainit/presentation/shared/export/validators.dart';

class TrainingFormList extends FormField<TrainingDays> {
  TrainingFormList({
    super.key,
    required Widget header,
    required FormFieldSetter<TrainingDays> onSaved,
    required TrainingDays initialValue,
    required Account account,
    required BuildContext context,
    AutovalidateMode autovalidate = AutovalidateMode.always,
  }) : super(
          onSaved: onSaved,
          validator: (value) =>
              Validators.validateTrainingDays(value!, context),
          initialValue: initialValue,
          autovalidateMode: autovalidate,
          builder: (FormFieldState<TrainingDays> state) {
            final errorText = state.hasError && state.errorText != null
                ? state.errorText
                : null;
            return _TrainingAnimatedList(
              header: header,
              initialValue: initialValue,
              account: account,
              onUpdate: (value) => state.didChange(value),
              errorText: errorText,
            );
          },
        );
}

class _TrainingAnimatedList extends StatefulWidget {
  final Widget header;
  final TrainingDays initialValue;
  final Account account;
  final Function(TrainingDays) onUpdate;
  final String? errorText;
  const _TrainingAnimatedList(
      {required this.header,
      required this.initialValue,
      required this.account,
      required this.onUpdate,
      required this.errorText});

  @override
  State<_TrainingAnimatedList> createState() => _TrainingAnimatedListState();
}

class _TrainingAnimatedListState extends State<_TrainingAnimatedList> {
  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();

  TrainingDays _value = const TrainingDays.empty();
  int _initialCount = 0;

  @override
  void initState() {
    _value = widget.initialValue;
    _initialCount = _value.count + 8;
    super.initState();
  }

  void _addItem(TapUpDetails details) async {
    final dayIndex = await showWeekMenu(context, details.globalPosition);
    if (dayIndex == null) return;

    setState(() {
      final training = Training.empty();
      final value = _value.copyWithNew(dayIndex, training: training);
      final index = value.combineWithPlaceHolder().indexOf(training) + 1;
      listKey.currentState!
          .insertItem(index, duration: const Duration(milliseconds: 100));
      _value = value;
      widget.onUpdate(_value);
    });
  }

  void _deleteItem(Training training) async {
    setState(() {
      final index = _value.combineWithPlaceHolder().indexOf(training) + 1;
      final value = _value.copyWithDeleted(id: training.id);

      listKey.currentState!.removeItem(
        index,
        (_, animation) => buildListTransition(
          training.id,
          animation,
          child: TrainingCard(
            key: ValueKey(training.id),
            training: training,
            account: widget.account,
            onMove: (_) {},
            onDeleteClick: () {},
            onClick: () {},
          ),
        ),
        duration: const Duration(milliseconds: 100),
      );
      _value = value;
      widget.onUpdate(_value);
    });
  }

  void _moveItem(Training training, int toDayIndex) {
    setState(() {
      final deleteIndex = _value.combineWithPlaceHolder().indexOf(training) + 1;

      final value =
          _value.copyWithMoved(training: training, toIndex: toDayIndex);
      final addIndex = value.combineWithPlaceHolder().indexOf(training) + 1;

      listKey.currentState!.removeItem(
        deleteIndex,
        (_, animation) => buildListTransition(
          training.id,
          animation,
          child: TrainingCard(
            key: ValueKey(training.id),
            training: training,
            account: widget.account,
            onMove: (_) {},
            onDeleteClick: () {},
            onClick: () {},
          ),
        ),
        duration: const Duration(milliseconds: 100),
      );
      listKey.currentState!
          .insertItem(addIndex, duration: const Duration(milliseconds: 100));
      _value = value;

      widget.onUpdate(_value);
    });
  }

  void _updateValue(TrainingDays value) {
    setState(() {
      _value = value;
      widget.onUpdate(_value);
    });
  }

  @override
  Widget build(BuildContext context) {
    final items = _buildTrainingPlanDayList(context);
    return ValidationErrorView(
      errorText: widget.errorText,
      child: AnimatedList(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        key: listKey,
        initialItemCount: _initialCount,
        itemBuilder: (context, index, animation) {
          final entry = MapEntry(
            index,
            items[index],
          );

          return buildListTransition(
            entry.value.key!,
            animation,
            child: entry.value,
          );
        },
      ),
    );
  }

  List<Widget> _buildTrainingPlanDayList(BuildContext context) {
    final items = <Widget>[
      EditTrainingPlanHeader(
        key: const ValueKey("header_of_training_days"),
        header: widget.header,
        onAddItemClick: _addItem,
      )
    ];

    for (int i = 0; i < 7; i++) {
      items.addAll(_buildTrainings(
        context: context,
        name: "${DateHelpers.weekDayNameAtIndex(i)}:",
        dayIndex: i,
        items: _value.atIndex(i),
        onTrainingEditClick: (training) async {
          final result = await showEditTrainingSheet(
            context: context,
            training: training,
            account: widget.account,
          );
          if (result == null || result is! Training) return;

          final newDays =
              _value.copyWithReplaced(id: training.id, value: result);
          if (newDays != _value) {
            _updateValue(newDays);
          }
        },
      ));
    }
    return items;
  }

  List<Widget> _buildTrainings({
    required BuildContext context,
    required String name,
    required int dayIndex,
    required List<Training> items,
    required Function(Training) onTrainingEditClick,
  }) {
    final trainings = items;

    final widgets = trainings
        .map<Widget>(
          (training) => TrainingCard(
            key: ValueKey(training.id),
            training: training,
            account: widget.account,
            onMove: (index) => _moveItem(training, index),
            onDeleteClick: () => _deleteItem(training),
            onClick: () => onTrainingEditClick(training),
          ),
        )
        .toList();
    final double labelHeight = widgets.isEmpty ? 50 : 25;
    widgets.insert(0, _buildNameLabel(context, name, labelHeight, dayIndex));
    return widgets;
  }

  Widget _buildNameLabel(
      BuildContext context, String name, double height, int dayIndex) {
    return Column(
      key: ValueKey(name),
      children: [
        const SizedBox(height: 12),
        SizedBox(
          key: ValueKey(name),
          width: double.infinity,
          height: height,
          child: Text(name),
        ),
      ],
    );
  }
}
