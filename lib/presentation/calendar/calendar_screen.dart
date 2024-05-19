import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trainit/bloc/calendar/bloc.dart';
import 'package:trainit/bloc/calendar/state.dart';
import 'package:trainit/bloc/data/cubit.dart';
import 'package:trainit/bloc/data/state.dart';
import 'package:trainit/data/model/calendar_training.dart';
import 'package:trainit/presentation/calendar/calendar_help_sheet.dart';
import 'package:trainit/presentation/calendar/widget/calendar_app_bar.dart';
import 'package:trainit/presentation/calendar/widget/calendar_list.dart';
import 'package:trainit/presentation/shared/export/page.dart';
import 'package:trainit/presentation/shared/export/tutorial_dialog.dart';

class CalendarScreen extends StatefulWidget {
  final Function(CalendarTraining) previewCalendarTraining;
  final Function() refreshData;
  const CalendarScreen(
      {super.key,
      required this.previewCalendarTraining,
      required this.refreshData});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  late ScrollController _scrollController;
  var showTitle = false;

  bool get _isAppBarExpanded {
    return _scrollController.hasClients;
  }

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController()
      ..addListener(() => setState(() => showTitle = _isAppBarExpanded));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CalendarBloc, CalendarState>(
      builder: (context, state) => TutorialEmbed(
        tutorialId: "calendar",
        child: SliverContentPage(
          controller: _scrollController,
          appBar: CalendarAppBar(
            state: state,
            refreshData: widget.refreshData,
            showHelpSheet: () async => await showCalendarHelpSheet(context),
          ),
          sliver: BlocListener<DataCubit, DataState>(
            listener: (context, state) async {
              if (state.status.isLoading) {
                await _refreshIndicatorKey.currentState?.show();
              }
            },
            child: CalendarList(
              calendar: state.calendar,
              account: state.account,
              onCalendarTrainingClick: widget.previewCalendarTraining,
            ),
          ),
        ),
      ),
    );
  }
}
