import 'package:flutter/material.dart';
import 'package:pczplan/scraper/models/activity.dart';
import 'package:pczplan/scraper/models/subject_type.dart';
import 'package:pczplan/style.dart';

class ActivityView extends StatelessWidget {
  final Activity _activity;

  const ActivityView(this._activity);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Style.background,
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
                    textAlign: TextAlign.center,
                  ),
                  Container(
                    color: Style.subjectFlairColor(_activity.type),
                    child: Text(
                      _typeString(_activity.type),
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
                    softWrap: true,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _activity.teacher ?? '',
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _activity.room ?? '',
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
