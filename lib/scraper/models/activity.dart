import 'package:pczplan/scraper/models/subject_type.dart';

class Activity {
  final String beginning;
  final String subjectName;
  final String teacher;
  final SubjectType type;
  final String room;

  const Activity(
    this.beginning,
    this.subjectName,
    this.teacher,
    this.type,
    this.room,
  );
}
