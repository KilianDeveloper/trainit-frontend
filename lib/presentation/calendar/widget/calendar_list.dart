import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trainit/data/model/account.dart';
import 'package:trainit/data/model/calendar.dart';
import 'package:trainit/data/model/calendar_training.dart';
import 'package:trainit/helper/date.dart';
import 'package:trainit/presentation/calendar/widget/calendar_training_card.dart';
import 'package:trainit/presentation/calendar/widget/empty_day.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CalendarList extends StatelessWidget {
  final WeekCalendar calendar;
  final Account account;
  final Function(CalendarTraining) onCalendarTrainingClick;
  CalendarList({
    super.key,
    required this.calendar,
    required this.account,
    required this.onCalendarTrainingClick,
  });

  final DateTime today = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final dates = <DateTime>[];
    for (int i = 0; i < 7; i++) {
      dates.add(today.add(Duration(days: i)));
    }
    return SliverList(
      key: const PageStorageKey("calendar"),
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ..._buildCalendarDate(context, index, dates[index]),
              const SizedBox(height: 16),
            ],
          );
        },
        childCount: dates.length,
      ),
    );
  }

  List<Widget> _buildCalendarDate(
      BuildContext context, int index, DateTime date) {
    final String title;
    final trainingList = calendar.atIndex(index);

    bool show = true;
    if (date.isAtSameMomentAs(today)) {
      title = AppLocalizations.of(context)!.today_trainings;
      if (trainingList.isEmpty) {
        show = false;
      }
    } else if (date.isAtSameMomentAs(today.add(const Duration(days: 1)))) {
      title = AppLocalizations.of(context)!.tomorrow;
    } else {
      title = "${DateFormat('EEEE').format(date)}:";
    }
    return _buildCalendarDayList(context, date, title, trainingList, show);
  }

  List<Widget> _buildCalendarDayList(BuildContext context, DateTime date,
      String title, List<CalendarTraining> trainingList, bool show) {
    if (!show) {
      return [];
    }
    final widgetList = <Widget>[
      if (!date.isSameDate(DateTime.now()))
        Text(
          title,
          style: Theme.of(context).textTheme.titleSmall,
        ),
    ];

    if (trainingList.isNotEmpty) {
      widgetList.addAll(
        trainingList.map(
          (e) => CalendarTrainingCard(
            calendarTraining: e,
            account: account,
            onClick: () => onCalendarTrainingClick(e),
          ),
        ),
      );
    } else {
      widgetList.add(const EmptyDay());
    }
    return widgetList;
  }
}
