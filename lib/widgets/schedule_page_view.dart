import 'package:flutter/material.dart';
import 'package:pczplan/scraper/models/day.dart';
import 'package:pczplan/style.dart';
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
          child: ListView.separated(
            separatorBuilder: (_, __) =>
                Container(height: 1, color: Style.accent),
            itemBuilder: (_, index) => ActivityView(_day.activities[index]),
            itemCount: _day.activities.length,
            shrinkWrap: true,
          ),
        )
      ],
    );
  }
}
