import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pczplan/pages/view_schedule_page.dart';
import 'package:pczplan/scraper/models/group.dart';
import 'package:pczplan/scraper/models/study_type.dart';
import 'package:pczplan/scraper/wimii_repo.dart';
import 'package:pczplan/widgets/loading_indicator.dart';

class SelectStudyGroupPage extends StatefulWidget {
  final StudyType _studyType;

  const SelectStudyGroupPage(this._studyType);

  @override
  SelectStudyGroupPageState createState() => SelectStudyGroupPageState();
}

class SelectStudyGroupPageState extends State<SelectStudyGroupPage> {
  bool _isLoading = true;

  final WimiiRepo _repo = WimiiRepo();
  final _groups = <Group>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Wybierz grupę')),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        child: _isLoading
            ? const LoadingIndicator('Pobieram grupy...')
            : ListView.builder(
                itemCount: _groups.length,
                itemBuilder: (BuildContext ctx, int index) {
                  final item = _groups[index];
                  return ListTile(
                    title: Text(item.name),
                    onTap: () {
                      Navigator.push<MaterialPageRoute>(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ViewSchedulePage(item),
                        ),
                      );
                    },
                  );
                },
              ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 1), init);
  }

  Future<void> init() async {
    final groups = await _repo.getGroups(widget._studyType);
    if (mounted) {
      setState(() {
        _isLoading = false;
        _groups.addAll(groups);
      });
    }
  }

  @override
  void dispose() {
    _repo.dispose();
    super.dispose();
  }
}
