import 'dart:io';

import 'package:flutter/material.dart';
import 'package:trainit/bloc/calendar/state.dart';
import 'package:trainit/presentation/calendar/widget/today_overview_card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CalendarAppBar extends StatelessWidget {
  final CalendarState state;
  final Function() refreshData;
  final Function() showHelpSheet;
  const CalendarAppBar({
    super.key,
    required this.state,
    required this.refreshData,
    required this.showHelpSheet,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      title: Text(
        AppLocalizations.of(context)!.calendar_title,
        style: Theme.of(context).textTheme.titleLarge,
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.help_rounded),
          onPressed: showHelpSheet,
        ),
        IconButton(
          icon: const Icon(Icons.refresh_rounded),
          onPressed: () async => await refreshData(),
        )
      ],
      centerTitle: Platform.isIOS ? true : false,
      expandedHeight: 160,
      collapsedHeight: 100,
      flexibleSpace: Stack(
        children: [
          _buildCollapsedTitle(),
          FlexibleSpaceBar(
            background: Column(
              children: [
                const Spacer(),
                TodayOverviewCard(
                  amountOfTrainings: state.calendar.day0.length,
                ),
              ],
            ),
            expandedTitleScale: 1,
          ),
        ],
      ),
      foregroundColor: Theme.of(context).colorScheme.onSurface,
      backgroundColor: Theme.of(context).colorScheme.surface,
      pinned: true,
      snap: true,
      floating: true,
    );
  }

  LayoutBuilder _buildCollapsedTitle() {
    return LayoutBuilder(builder: (context, cons) {
      return cons.maxHeight < 170
          ? Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 0, 16),
              child: Column(
                children: [
                  const Spacer(),
                  Text(
                    AppLocalizations.of(context)!
                        .today_collapsed(state.calendar.day0.length),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            )
          : const SizedBox();
    });
  }
}
