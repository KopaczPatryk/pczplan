import 'package:flutter/material.dart';
import 'package:pczplan/scraper/models/schedule.dart';
import 'package:pczplan/pages/view_schedule/widgets/schedule_day.dart';

class ScheduleView extends StatelessWidget {
  final Schedule _schedule;

  const ScheduleView(this._schedule);

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      itemBuilder: (context, pos) => ScheduleDay(_schedule.days[pos]),
      itemCount: _schedule.days.length,
    );
  }
}
