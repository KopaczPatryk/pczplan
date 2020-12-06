import 'package:flutter/material.dart';
import 'package:pczplan/scraper/models/day.dart';
import 'package:pczplan/widgets/activity_view.dart';

class SchedulePage extends StatelessWidget {
  final Day _day;

  const SchedulePage(this._day);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(_day.name ?? ''),
        Expanded(
          child: ListView.builder(
            itemBuilder: (ctx, pos) {
              return ActivityView(_day.activities[pos]);
            },
            itemCount: _day.activities.length,
            shrinkWrap: true,
          ),
        )
      ],
    );
  }
}
