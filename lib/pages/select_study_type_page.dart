import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pczplan/pages/select_study_group_page.dart';
import 'package:pczplan/scraper/models/study_type.dart';
import 'package:pczplan/scraper/wimii_repo.dart';
import 'package:pczplan/widgets/loading_indicator.dart';

class SelectStudyTypePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SelectStudyTypePageState();
}

class SelectStudyTypePageState extends State<SelectStudyTypePage> {
  bool _isLoading = true;

  final WimiiRepo _repo = WimiiRepo();
  final _items = <StudyType>[];

  Future<void> init() async {
    final value = await _repo.getStudyTypes();
    if (mounted) {
      setState(() {
        _items
          ..clear()
          ..addAll(value);
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    Timer(const Duration(seconds: 1), init);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Wybierz tryb studiów')),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        child: _isLoading
            ? const LoadingIndicator('Pobieram typy studiów...')
            : ListView.builder(
                itemCount: _items.length,
                itemBuilder: (BuildContext ctx, int index) {
                  final item = _items[index];
                  return ListTile(
                    title: Text(item.name),
                    onTap: () {
                      Navigator.push<MaterialPageRoute>(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SelectStudyGroupPage(item)),
                      );
                    },
                  );
                },
              ),
      ),
    );
  }

  @override
  void dispose() {
    _repo.dispose();
    super.dispose();
  }
}
