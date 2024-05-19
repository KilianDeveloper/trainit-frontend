import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trainit/bloc/calendar/bloc.dart';
import 'package:trainit/bloc/calendar/state.dart';
import 'package:trainit/data/model/calendar_training.dart';
import 'package:trainit/presentation/calendar/widget/calendar_training_form.dart';
import 'package:trainit/presentation/calendar/widget/calendar_training_preview_header.dart';
import 'package:trainit/presentation/shared/export/page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CalendarTrainingPreview extends StatefulWidget {
  final CalendarTraining calendarTraining;
  const CalendarTrainingPreview({super.key, required this.calendarTraining});

  @override
  State<CalendarTrainingPreview> createState() =>
      _CalendarTrainingPreviewState();
}

class _CalendarTrainingPreviewState extends State<CalendarTrainingPreview> {
  final ScrollController _scrollController = ScrollController();
  int duration = 10;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CalendarBloc, CalendarState>(
      buildWhen: (previous, current) => current.selected != null,
      builder: (context, state) => SliverContentPage(
        controller: _scrollController,
        appBar: SliverAppBar(
          title: Text(
            AppLocalizations.of(context)!
                .training_title(widget.calendarTraining.name),
            style: Theme.of(context).textTheme.titleLarge,
          ),
          expandedHeight: 140,
          collapsedHeight: 72,
          flexibleSpace: FlexibleSpaceBar(
            background: Align(
              alignment: Alignment.bottomCenter,
              child: CalendarTrainingPreviewHeader(
                calendarTraining: widget.calendarTraining,
                account: state.account,
              ),
            ),
            expandedTitleScale: 1,
          ),
          foregroundColor: Theme.of(context).colorScheme.onSurface,
          backgroundColor: Theme.of(context).colorScheme.surface,
          pinned: true,
          snap: true,
          floating: true,
        ),
        sliver: CalendarTrainingForm(
          calendarTraining: state.selected!,
          account: state.account,
        ),
      ),
    );
  }
}
