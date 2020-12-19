import 'package:flutter/material.dart';
import 'package:pczplan/pages/select_study_type_page.dart';
import 'package:pczplan/style.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark().copyWith(accentColor: Style.accent),
      home: SelectStudyTypePage(),
    );
  }
}
