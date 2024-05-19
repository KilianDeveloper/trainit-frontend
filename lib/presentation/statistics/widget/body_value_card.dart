import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:trainit/data/model/account.dart';
import 'package:trainit/data/model/body_value.dart';
import 'package:trainit/data/model/dto/statistic_body_value_collection.dart';
import 'package:trainit/data/model/personal_record_type.dart';
import 'package:trainit/data/model/units.dart';
import 'package:trainit/presentation/shared/export/strings.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BodyValueCard extends StatefulWidget {
  final StatisticBodyValueCollection value;
  final Account account;
  final Function(int) onDurationChange;
  final Function() onCreateClick;
  const BodyValueCard({
    super.key,
    required this.value,
    required this.account,
    required this.onCreateClick,
    required this.onDurationChange,
  });

  @override
  State<BodyValueCard> createState() => _BodyValueCardState();
}

class _BodyValueCardState extends State<BodyValueCard> {
  final dashSize = 16.0;
  final graphWidth = 8.0;

  int durationValue = 0;
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final color1Highlight = Theme.of(context).colorScheme.onTertiary;
    final color2Highlight = Theme.of(context).colorScheme.onTertiaryContainer;
    final color1 = Theme.of(context).colorScheme.tertiary;
    final color2 = Theme.of(context).colorScheme.tertiaryContainer;
    return Card(
      margin: const EdgeInsets.fromLTRB(0, 8, 0, 8),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(
              context: context,
              color1: color1,
              color2: color2,
            ),
            const SizedBox(height: 12),
            _buildChart(
              context: context,
              color1: color1,
              color1Highlight: color1Highlight,
              color2: color2,
              color2Highlight: color2Highlight,
            ),
            const SizedBox(height: 12),
            _buildCurrentValue(
              context: context,
              color1: color1,
              color2: color2,
            ),
            const SizedBox(height: 12),
            _buildSelectedValue(
              context: context,
              color1: color1,
              color2: color2,
            ),
            const SizedBox(height: 20),
            _buildButton(context)
          ],
        ),
      ),
    );
  }

  Widget _buildHeader({
    required BuildContext context,
    required Color color1,
    required Color color2,
  }) {
    return Row(
      children: [
        Text(
          "Body Weight",
          style:
              Theme.of(context).textTheme.titleSmall?.copyWith(color: color1),
        ),
        const SizedBox(width: 12),
        Text(
          "Body Fat",
          style:
              Theme.of(context).textTheme.titleSmall?.copyWith(color: color2),
        ),
        const Spacer(),
        SizedBox(
          height: 32,
          child: DropdownButton(
            items: [
              DropdownMenuItem(
                value: 0,
                child: Text(AppLocalizations.of(context)!.week),
              ),
              DropdownMenuItem(
                value: 1,
                child: Text(AppLocalizations.of(context)!.month),
              ),
              DropdownMenuItem(
                value: 2,
                child: Text(AppLocalizations.of(context)!.year),
              ),
            ],
            borderRadius: BorderRadius.circular(12),
            style: Theme.of(context).textTheme.titleSmall,
            underline: const SizedBox(),
            value: durationValue,
            onChanged: (value) => setState(() {
              durationValue = value ?? 0;
              var duration = 8;
              if (value == 1) {
                duration = 31;
              } else if (value == 2) {
                duration = 366;
              }
              widget.onDurationChange(duration);
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildChart({
    required BuildContext context,
    required Color color1,
    required Color color2,
    required Color color1Highlight,
    required Color color2Highlight,
  }) {
    const padding = 24;
    return SizedBox(
      height: 170,
      child: LayoutBuilder(
        builder: (context, constraints) {
          int itemCount = widget.value.weight.length;

          if (widget.value.weight.isEmpty || widget.value.fat.isEmpty) {
            return Text(AppLocalizations.of(context)!.loading);
          }

          final maxWeight = widget.value.weight.reduce((curr, next) =>
              (curr?.value ?? 0) > (next?.value ?? 0) ? curr : next);
          final minWeight = widget.value.weight.reduce((curr, next) =>
              (curr?.value ?? 19999999) < (next?.value ?? 19999999)
                  ? curr
                  : next);

          final maxFat = widget.value.fat.reduce((curr, next) =>
              (curr?.value ?? 0) > (next?.value ?? 0) ? curr : next);
          final minFat = widget.value.fat.reduce((curr, next) =>
              (curr?.value ?? 19999999) < (next?.value ?? 19999999)
                  ? curr
                  : next);

          final itemWidth = (constraints.maxWidth - padding) / (itemCount - 1);

          final List<int> indexes = [];

          for (int i = 0; i < itemCount; i++) {
            indexes.add(i);
          }
          return Stack(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  padding / 2,
                  padding / 2,
                  padding / 2,
                  0,
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: indexes
                            .getRange(0, indexes.length - 1)
                            .map(
                              (e) => Container(
                                color: e.isEven
                                    ? Theme.of(context).colorScheme.surface
                                    : Colors.transparent,
                                width: itemWidth,
                                height: 120,
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 12,
                left: itemWidth * selectedIndex + padding / 2 - 1.5,
                child: Container(
                  height: 128,
                  width: 3,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ),
              if (maxFat != null && minFat != null)
                ..._buildStatistic(
                  context: context,
                  values: widget.value.fat,
                  max: BodyValue(value: maxFat.value * 1.05, date: maxFat.date),
                  min: BodyValue(value: minFat.value * .95, date: minFat.date),
                  padding: padding,
                  itemWidth: itemWidth,
                  verticalOffset: -2,
                  color: color2,
                  colorHighlight: color2Highlight,
                ),
              if (maxWeight != null && minWeight != null)
                ..._buildStatistic(
                  context: context,
                  values: widget.value.weight,
                  max: BodyValue(
                      value: maxWeight.value * 1.05, date: maxWeight.date),
                  min: BodyValue(
                      value: minWeight.value * .95, date: minWeight.date),
                  padding: padding,
                  itemWidth: itemWidth,
                  verticalOffset: 0,
                  color: color1,
                  colorHighlight: color1Highlight,
                ),
              ...indexes.map((e) {
                final text = widget.value.xAxisValues.length - 1 >= e
                    ? (widget.value.xAxisValues[e] ?? "u")
                    : "u";
                return Positioned(
                  top: 128,
                  left: itemWidth * e + padding / 2 - 24,
                  height: 48,
                  width: 48,
                  child: Stack(
                    children: [
                      Center(
                        child: CircleAvatar(
                          radius: 12,
                          backgroundColor: selectedIndex == e
                              ? Theme.of(context).colorScheme.secondary
                              : Colors.transparent,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            selectedIndex = e;
                          });
                        },
                        color: selectedIndex == e
                            ? Theme.of(context).colorScheme.secondary
                            : Colors.transparent,
                        icon: Text(
                          text,
                          style: TextStyle(fontSize: text.length > 2 ? 10 : 18),
                        ),
                      ),
                    ],
                  ),
                );
              })
            ],
          );
        },
      ),
    );
  }

  List<Widget> _buildStatistic({
    required BuildContext context,
    required List<BodyValue?> values,
    required BodyValue min,
    required BodyValue max,
    required int padding,
    required double itemWidth,
    required double verticalOffset,
    required Color color,
    required Color colorHighlight,
  }) {
    List<Offset> positions = [];

    List<Widget> items = [];
    for (var value in values) {
      if (value == null) {
        continue;
      }
      final index = values.indexOf(value);
      final difference = (max.value - min.value).abs();
      final currentDifference1 = (min.value - value.value).abs();
      final double progress = 1 - currentDifference1 / difference;

      positions.add(Offset(
        itemWidth * index + padding / 2,
        progress * 120 + padding / 2,
      ));
      items.add(
        Positioned(
          top: progress * 120 - (dashSize / 2) + padding / 2 + verticalOffset,
          left: itemWidth * index + padding / 2 - (dashSize / 2),
          child: Container(
            height: dashSize,
            width: dashSize,
            decoration: BoxDecoration(
              color: colorHighlight,
              shape: BoxShape.circle,
            ),
          ),
        ),
      );
    }
    items.insert(
      0,
      CustomPaint(
        size: const Size(double.infinity, 170),
        painter: GraphPainter(positions: positions, color: color),
      ),
    );
    return items;
  }

  Widget _buildCurrentValue({
    required BuildContext context,
    required Color color1,
    required Color color2,
  }) {
    return _buildValue(
      recentBodyWeight: widget.value.mostRecentWeight,
      recentBodyFat: widget.value.mostRecentFat,
      title: AppLocalizations.of(context)!.now_label,
      color1: color1,
      color2: color2,
    );
  }

  Widget _buildSelectedValue({
    required BuildContext context,
    required Color color1,
    required Color color2,
  }) {
    if (widget.value.weight.length - 1 < selectedIndex) {
      setState(() {
        selectedIndex = 0;
      });
      return const SizedBox();
    }
    final BodyValue? recentBodyWeight =
        widget.value.weight.isEmpty ? null : widget.value.weight[selectedIndex];
    final BodyValue? recentBodyFat =
        widget.value.weight.isEmpty ? null : widget.value.fat[selectedIndex];
    return _buildValue(
      recentBodyWeight: recentBodyWeight,
      recentBodyFat: recentBodyFat,
      title: AppLocalizations.of(context)!.selected_label,
      color1: color1,
      color2: color2,
    );
  }

  Widget _buildValue({
    required BodyValue? recentBodyWeight,
    required BodyValue? recentBodyFat,
    required String title,
    required Color color1,
    required Color color2,
  }) {
    double weightValue = convertBaseUnitTo(
        recentBodyWeight?.value ?? 0, widget.account.weightUnit);

    final fatValue = recentBodyFat?.value ?? 0;
    return Row(
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const Spacer(),
        Text(
          recentBodyWeight != null
              ? "${weightValue.toStringAsFixed(1)} ${widget.account.weightUnit.valueToString()}"
              : "--",
          style:
              Theme.of(context).textTheme.titleSmall?.copyWith(color: color1),
        ),
        const Spacer(),
        Text(
          recentBodyFat != null
              ? "${fatValue.toStringAsFixed(1)} ${EnumStringProvider.getUnitName(Unit.percent, context)}"
              : "--",
          style:
              Theme.of(context).textTheme.titleSmall?.copyWith(color: color2),
        ),
        const Spacer(),
      ],
    );
  }

  Widget _buildButton(BuildContext context) {
    return Center(
      child: FilledButton(
        onPressed: widget.onCreateClick,
        child: Text(AppLocalizations.of(context)!.add_today_value),
      ),
    );
  }
}

class GraphPainter extends CustomPainter {
  final List<Offset> positions;
  final Color color;

  GraphPainter({
    required this.positions,
    required this.color,
  });
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;
    canvas.drawPoints(PointMode.polygon, positions, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
