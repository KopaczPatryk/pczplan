import 'package:flutter/material.dart';
import 'package:pczplan/scraper/models/activity.dart';
import 'package:pczplan/scraper/models/subject_type.dart';
import 'package:pczplan/style.dart';

class ActivityView extends StatelessWidget {
  final Activity _activity;

  const ActivityView(this._activity);
  TextStyle get _textStyle => TextStyle(color: textColor);
  // TextStyle get _boldStyle =>
  //     TextStyle(color: textColor, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: background,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: SizedBox(
              width: 75,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _activity.beginning ?? '',
                    style: _textStyle,
                    textAlign: TextAlign.center,
                  ),
                  Container(
                    color: subjectExe,
                    child: Text(
                      _typeString(_activity.type),
                      style: _textStyle,
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    _activity.subjectName ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.clip,
                    softWrap: true,
                    style: _textStyle,
                  ),
                  Text(
                    _activity.teacher ?? '',
                    style: _textStyle,
                  ),
                  Text(
                    _activity.room ?? '',
                    style: _textStyle,
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  String _typeString(SubjectType type) {
    switch (type) {
      case SubjectType.laboratory:
        return 'Lab.';
        break;
      case SubjectType.lecture:
        return 'Wyk.';
        break;
      case SubjectType.exercise:
        return 'Ćw.';
        break;
      case SubjectType.seminary:
        return 'Sem.';
        break;
      case SubjectType.groupProject:
        return 'Proj.';
        break;
      case SubjectType.lang:
        return 'Jęz.';
        break;
      case SubjectType.freiheit:
        return 'Wolne';
        break;
      case SubjectType.unknownSubject:
        return '???';
        break;
      case SubjectType.elearning:
        return 'E-learn.';
        break;
      case SubjectType.gap:
        return 'Okno';
        break;
    }
    return '';
  }
}
