import 'package:flutter/material.dart';
import 'package:pczplan/scraper/models/subject_type.dart';

class Style {
  static Color get background => const Color(0xFF363636);
  static Color get textColor => const Color(0xFFeaeaea);
  static Color get accent => const Color(0xFFC0FDFB);
  static Color get ripple => const Color(0xFF505050);

  static Color get subjectLec => const Color(0xFF558564);
  static Color get subjectSem => const Color(0xFF558564);
  static Color get subjectLab => const Color(0xFF56638a);
  static Color get subjectExe => const Color(0xFF56638a);
  static Color get subjectProj => const Color(0xFF9B9743);
  static Color get subjectLang => const Color(0xFF802222);
  static Color get subjectGap => const Color(0xFF99dd00);
  static Color get subjectUnknown => Colors.grey;

  static Color subjectFlairColor(SubjectType type) {
    switch (type) {
      case SubjectType.elearning:
        return Style.accent;
      case SubjectType.laboratory:
        return Style.subjectLab;
      case SubjectType.lecture:
        return Style.subjectLec;
      case SubjectType.exercise:
        return Style.subjectExe;
      case SubjectType.seminary:
        return Style.subjectSem;
      case SubjectType.groupProject:
        return Style.subjectProj;
      case SubjectType.lang:
        return Style.subjectLang;
      case SubjectType.freiheit:
      case SubjectType.gap:
        return Style.subjectGap;
      case SubjectType.unknownSubject:
        return Style.subjectUnknown;
      default:
        return Colors.black;
    }
  }
}
