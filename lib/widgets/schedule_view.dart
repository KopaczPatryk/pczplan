import 'package:flutter/material.dart';
import 'package:pczplan/scraper/models/schedule.dart';
import 'package:pczplan/widgets/schedule_page_view.dart';

class ScheduleView extends StatelessWidget {
  final Schedule _schedule;

  const ScheduleView(this._schedule);

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      itemBuilder: (context, pos) => SchedulePage(_schedule.days[pos]),
      itemCount: _schedule.days.length,
    );
  }
}
