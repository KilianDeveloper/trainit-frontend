import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trainit/bloc/calendar/bloc.dart';
import 'package:trainit/bloc/calendar/event.dart';
import 'package:trainit/bloc/calendar/state.dart';
import 'package:trainit/bloc/data/cubit.dart';
import 'package:trainit/presentation/calendar/calendar_screen.dart';
import 'package:trainit/presentation/calendar/training_preview_screen.dart';

GlobalKey<NavigatorState> calendarNavigatorKey = GlobalKey<NavigatorState>();

class MainCalendarScreen extends StatefulWidget {
  const MainCalendarScreen({super.key});

  @override
  State<MainCalendarScreen> createState() => _MainCalendarScreenState();
}

class _MainCalendarScreenState extends State<MainCalendarScreen> {
  @override
  void initState() {
    context.read<CalendarBloc>().add(ResetScreenStatus());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildNavigator(context);
  }

  Widget _buildNavigator(BuildContext context) {
    return BlocBuilder<CalendarBloc, CalendarState>(
      builder: (c, state) {
        final injectedScreens =
            state.injectedScreens.map((e) => MaterialPage(child: e()));
        return Navigator(
          key: calendarNavigatorKey,
          pages: [
            _buildCalendar(context),
            if (state.selected != null) _buildTrainingPreview(state),
            ...injectedScreens
          ],
          onPopPage: (route, result) {
            context.read<CalendarBloc>().add(
                  SelectCalendarTraining(
                    selected: null,
                  ),
                );
            return false;
          },
        );
      },
    );
  }

  MaterialPage<dynamic> _buildCalendar(BuildContext context) {
    return MaterialPage(
        child: CalendarScreen(
      previewCalendarTraining: (calendarTraining) =>
          context.read<CalendarBloc>().add(
                SelectCalendarTraining(
                  selected: calendarTraining,
                ),
              ),
      refreshData: () async {
        final bloc = context.read<DataCubit>();
        await bloc.reloadData();
      },
    ));
  }

  MaterialPage<dynamic> _buildTrainingPreview(CalendarState state) {
    return MaterialPage(
      child: CalendarTrainingPreview(
        calendarTraining: state.selected!,
      ),
    );
  }
}
