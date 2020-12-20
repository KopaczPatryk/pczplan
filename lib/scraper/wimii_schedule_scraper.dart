import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart';
import 'package:pczplan/extensions.dart';
import 'package:pczplan/scraper/models/activity.dart';
import 'package:pczplan/scraper/models/day.dart';

import 'package:pczplan/scraper/models/group.dart';
import 'package:pczplan/scraper/models/schedule.dart';
import 'package:pczplan/scraper/models/subject_type.dart';

abstract class WimiiScheduleScraper {
  final Client _client;

  final laboratoryPattern = RegExp('lab[. ]?', caseSensitive: false);

  final lecturePattern =
      RegExp('(?:lec(?:ture)?|wyk)[. ]?', caseSensitive: false);
  final exercisePattern =
      RegExp('(?:exe(?:rcise)?|[cć]w(?:iczenia)?)[. ]?', caseSensitive: false);

  final gprojPattern = RegExp('proj[. ]?', caseSensitive: false);
  final seminaryPattern = RegExp('sem[. ]?', caseSensitive: false);
  final langPattern = RegExp('sjo[. ]?', caseSensitive: false);
  final elearningPattern = RegExp('e-lear[. ]?', caseSensitive: false);

  WimiiScheduleScraper(this._client);

  Future<Document> getScheduleDocument(String link) async {
    final response = await _client.get(link);

    if (response.statusCode == 200) {
      return parse(response.body);
    } else {
      throw Exception('Request failed');
    }
  }

  String getDayName(Document document, int dayIndex);

  String getActivityBeginning(Element element) {
    final startHourPattern = RegExp('(\\d+[.:;]\\d+)', caseSensitive: false);
    return startHourPattern.stringMatch(element.innerHtml);
  }

  List<Node> stripBreaks(Element element) {
    return element.nodes
        .where((element) => element.nodeType == Node.TEXT_NODE)
        .toList();
  }

  String getActivityName(Element activityElement) {
    final rows = stripBreaks(activityElement);
    return rows.first.text ?? '';
  }

  String getActivityTeacher(Element activityElement) {
    try {
      final rows = stripBreaks(activityElement);
      return rows[1].text ?? '';
      // ignore: avoid_catching_errors
    } on RangeError {
      return activityElement.nodes.last.text;
    }
  }

  SubjectType getActivityType(Element activityElement) {
    final name = activityElement.text;

    if (laboratoryPattern.hasMatch(name)) {
      return SubjectType.laboratory;
    } else if (lecturePattern.hasMatch(name)) {
      return SubjectType.lecture;
    } else if (exercisePattern.hasMatch(name)) {
      return SubjectType.exercise;
    } else if (gprojPattern.hasMatch(name)) {
      return SubjectType.groupProject;
    } else if (seminaryPattern.hasMatch(name)) {
      return SubjectType.seminary;
    } else if (langPattern.hasMatch(name)) {
      return SubjectType.lang;
    } else if (name.isEmpty || name.isBlank) {
      return SubjectType.gap;
    } else if (elearningPattern.hasMatch(name)) {
      return SubjectType.elearning;
    } else {
      return SubjectType.unknownSubject;
    }
  }

  String getActivityLocation(Element activityElement) {
    try {
      final rows = stripBreaks(activityElement);
      return rows.last.text ?? '';
      // ignore: avoid_catching_errors
    } on RangeError {
      return activityElement.nodes.last.text;
    }
  }

  Activity getActivity(Element element, Element activityElement, int index) {
    final beginning = getActivityBeginning(element);
    final subjectName = getActivityName(activityElement);
    final teacher = getActivityTeacher(activityElement);
    final type = getActivityType(activityElement);
    final room = getActivityLocation(activityElement);

    return Activity(beginning, subjectName, teacher, type, room);
  }

  List<Activity> getActivities(Document document, int dayIndex);

  Day getDay(Document document, int dayIndex) {
    final dayName = getDayName(document, dayIndex);
    final activities = getActivities(document, dayIndex);
    return Day(dayName, activities);
  }

  int getDayCount(Document document);

  Schedule getSchedule(Document document) {
    final days = <Day>[];

    final dayCount = getDayCount(document);
    for (var i = 0; i < dayCount; i++) {
      days.add(getDay(document, i));
    }
    return Schedule(days);
  }

  Future<Schedule> scrapSchedule(Group group) async {
    final document = await getScheduleDocument(group.link);
    return getSchedule(document);
  }

  void dispose() {
    _client.close();
  }
}
