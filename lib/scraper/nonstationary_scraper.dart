import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart';
import 'package:pczplan/scraper/models/activity.dart';
import 'package:pczplan/scraper/models/day.dart';
import 'package:pczplan/scraper/models/group.dart';
import 'package:pczplan/scraper/models/schedule.dart';
import 'package:pczplan/scraper/models/subject_type.dart';
import 'package:pczplan/scraper/wimii_schedule_scraper.dart';

class NonstationaryScraper implements WimiiScheduleScraper {
  final Client _client;

  NonstationaryScraper(this._client);

  @override
  Future<Schedule> scrapSchedule(Group group) async {
    final document = await getScheduleDocument(group.link);

    final days = <Day>[];

    final dayCount = getDayCount(document);
    for (var i = 0; i < dayCount; i++) {
      days.add(getDay(document, i));
    }
    return Schedule(days);
  }

  Future<Document> getScheduleDocument(String link) async {
    final response = await _client.get(link);
    if (response.statusCode == 200) {
      return parse(response.body);
    } else {
      throw Exception('Not found');
    }
  }

  int getDayCount(Document document) {
    return document.querySelector('tr').children.length - 1;
  }

  Day getDay(Document document, int dayIndex) {
    final dayName = getDayName(document, dayIndex);

    final activities = getActivities(document, dayIndex);
    return Day(dayName, activities);
  }

  String getDayName(Document document, int dayIndex) {
    return document.querySelector('tr').children[dayIndex + 1].innerHtml;
  }

  List<Activity> getActivities(Document document, int dayIndex) {
    final activities = <Activity>[];
    final allRows = document.querySelectorAll('tr').sublist(1);
    final hourElements = <Element>[];
    final activityElements = <Element>[];

    allRows.forEach((tr) {
      var colIndex = 0;
      tr.children.forEach((td) {
        if (colIndex == 0) {
          hourElements.add(td);
        }
        if (colIndex == dayIndex + 1) {
          activityElements.add(td);
        }
        colIndex++;
      });
    });
    var counter = 0;
    activityElements.forEach((element) {
      final activity = getActivity(
          hourElements[counter], activityElements[counter], counter);
      activities.add(activity);
      counter++;
    });

    return activities;
  }

  Activity getActivity(Element element, Element activityElement, int index) {
    final beginning = getActivityBeginning(element);
    final subjectName = getActivityName(activityElement);
    final teacher = getActivityTeacher(activityElement);
    final type = getActivityType(activityElement);
    final room = getActivityLocation(activityElement);

    return Activity(beginning, subjectName, teacher, type, room);
  }

  String getActivityBeginning(Element element) {
    final startHourPattern = RegExp('(\\d+[.:;]\\d+)', caseSensitive: false);
    return startHourPattern.stringMatch(element.innerHtml);
  }

  String getActivityName(Element activityElement) {
    return activityElement.text.split('<br>').last ?? '';
  }

  String getActivityTeacher(Element activityElement) {
    try {
      return activityElement.nodes[2]?.text ?? activityElement.nodes.last.text;
    } on RangeError {
      return activityElement.nodes.last.text;
    }
  }

  SubjectType getActivityType(Element activityElement) {
    final laboratoryPattern = RegExp('lab[. ]?', caseSensitive: false);
    final lecturePattern = RegExp(
      '(?:lec(?:ture)?|wyk)[. ]?',
      caseSensitive: false,
    );

    final exercisePattern = RegExp(
      '(?:exe(?:rcise)?|[cć]w(?:iczenia)?)[. ]?',
      caseSensitive: false,
    );

    final gprojPattern = RegExp('proj[. ]?', caseSensitive: false);
    final seminaryPattern = RegExp('sem[. ]?', caseSensitive: false);
    final langPattern = RegExp('sjo[. ]?', caseSensitive: false);

//    final name = getActivityName(activityElement);
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
    } else {
      return SubjectType.gap;
    }
  }

  String getActivityLocation(Element activityElement) {
    try {
      return activityElement.nodes[4]?.text ?? activityElement.nodes.last.text;
    } on RangeError {
      return activityElement.nodes.last.text;
    }
  }

  void dispose() {
    _client.close();
  }
}
