import 'package:flutter/material.dart';
import 'package:pczplan/pages/select_study_type_page.dart';
import 'package:pczplan/style.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PCZ Plan',
      theme: ThemeData.dark().copyWith(accentColor: Style.accent),
      home: SelectStudyTypePage(),
    );
  }
}
