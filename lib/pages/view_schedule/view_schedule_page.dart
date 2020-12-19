import 'package:flutter/material.dart';
import 'package:pczplan/pages/view_schedule/widgets/schedule_day.dart';
import 'package:pczplan/scraper/models/group.dart';
import 'package:pczplan/scraper/models/schedule.dart';
import 'package:pczplan/scraper/wimii_repo.dart';
import 'package:pczplan/widgets/loading_indicator.dart';

class ViewSchedulePage extends StatefulWidget {
  final Group _group;

  const ViewSchedulePage(this._group);

  @override
  _ViewSchedulePageState createState() => _ViewSchedulePageState();
}

class _ViewSchedulePageState extends State<ViewSchedulePage> {
  bool _isLoading = true;

  final WimiiRepo _repo = WimiiRepo();
  Schedule _schedule;

  Future<void> init() async {
    final schedule = await _repo.getSchedule(widget._group);
    setState(() {
      _isLoading = false;
      _schedule = schedule;
    });
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _schedule?.days?.length ?? 0,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget._group.name),
          bottom: !_isLoading
              ? TabBar(
                  isScrollable: true,
                  tabs:
                      _schedule.days.map((day) => Tab(text: day.name)).toList(),
                )
              : null,
        ),
        body: !_isLoading
            ? TabBarView(
                children:
                    _schedule.days.map((day) => ScheduleDay(day)).toList(),
              )
            : const LoadingIndicator('Wczytuję plan'),
      ),
    );
  }

  @override
  void dispose() {
    _repo.dispose();
    super.dispose();
  }
}
