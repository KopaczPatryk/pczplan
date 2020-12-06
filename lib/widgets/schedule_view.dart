import 'package:flutter/material.dart';
import 'package:pczplan/scraper/models/schedule.dart';
import 'package:pczplan/widgets/schedule_page_view.dart';

class ScheduleView extends StatelessWidget {
  final Schedule _schedule;

  const ScheduleView(this._schedule);

  Widget _buildSchedulePage(int pos) {
    return SchedulePage(_schedule.days[pos]);
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      itemBuilder: (context, pos) {
        return _buildSchedulePage(pos);
      },
      itemCount: _schedule.days.length,
    );
  }
}
