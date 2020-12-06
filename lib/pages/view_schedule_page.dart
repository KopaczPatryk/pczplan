import 'package:flutter/material.dart';
import 'package:pczplan/scraper/models/group.dart';
import 'package:pczplan/scraper/models/schedule.dart';
import 'package:pczplan/scraper/wimii_repo.dart';
import 'package:pczplan/widgets/loading_indicator.dart';
import 'package:pczplan/widgets/schedule_view.dart';

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

  void init() async {
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
    return Scaffold(
      appBar: AppBar(title: Text(widget._group.name)),
      body: _isLoading
          ? const LoadingIndicator('Wczytuję plan')
          : ScheduleView(_schedule),
    );
  }

  @override
  void dispose() {
    _repo.dispose();
    super.dispose();
  }
}
