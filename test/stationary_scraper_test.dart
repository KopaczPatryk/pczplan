import 'package:diacritic/diacritic.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:pczplan/scraper/models/subject_type.dart';
import 'package:pczplan/scraper/stationary_scraper.dart';

import 'stationary_site.dart';

// https://wimii.pcz.pl/download/plan/studia_stacjonarne/o68v.html

void main() {
  final Client mockClient = MockClient((request) async {
    final clean = removeDiacritics(stationary_site);

    return await Response(clean, 200);
  });

  final scraper = StationaryScraper(mockClient);

  test('diacritics is ok', () async {
    const text = 'Każdy';

    final clean = removeDiacritics(text);
    expect(clean, equals('Kazdy'));
  });

  test('getScheduleDocument is ok', () async {
    final document = await scraper.getScheduleDocument('blah');
    expect(document, isNotNull);
  });

  test('daycount returns valid count', () async {
    final document = await scraper.getScheduleDocument('blah');
    final count = scraper.getDayCount(document);
    expect(count, 16 * 5 - 2);
    // Wtorek and środa is missing once
  });

  test('scraper return proper day name -> Pon', () async {
    final document = await scraper.getScheduleDocument('blah');
    final value = scraper.getDayName(document, 0);
    expect(value, contains('Pon'));
  });

  test('scraper return proper day name -> środa', () async {
    final document = await scraper.getScheduleDocument('blah');
    final value = scraper.getDayName(document, 2);
    expect(value, contains('Sro'));
  });

  test('populated day 0 returns 12 activities', () async {
    final document = await scraper.getScheduleDocument('blah');
    final day = scraper.getDay(document, 0);
    expect(day.activities.length, 12);
  });

  test('day 0 returns 12 activities', () async {
    final document = await scraper.getScheduleDocument('blah');
    final value = scraper.getActivities(document, 0);
    expect(value.length, 12);
  });

  test('day 1 returns 12 activities', () async {
    final document = await scraper.getScheduleDocument('blah');
    final day = scraper.getDay(document, 1);
    expect(day.activities.length, 12);
  });

  test('day 09.10.2020 begins with Olas', () async {
    final document = await scraper.getScheduleDocument('blah');
    final day = scraper.getDay(document, 9);

    expect(
      day.activities
          .where((activity) =>
              activity.type != SubjectType.freiheit &&
              activity.type != SubjectType.gap)
          .first
          .teacher,
      contains('Olas'),
    );
  });

  test('scraper returns proper activity name', () async {
    final document = await scraper.getScheduleDocument('blah');
    // Prog. urządzeń mobilnych wyk.
    // Grosser Andrzej Dr inż. /KI/
    // E-learning

    final element = document.querySelectorAll('tr')[7].children[12];
    final activity = scraper.getActivityName(element);

    expect(activity, contains('Prog. urzadzen'));
  });

  test('scraper returns proper activity teacher', () async {
    final document = await scraper.getScheduleDocument('blah');
    //Eksploatacja instalacji energetycznych
    final element = document.querySelectorAll('tr')[7].children[12];
    final teacher = scraper.getActivityTeacher(element);

    expect(teacher, contains('Grosser Andrzej'));
  });

  test('scraper returns proper activity type -> lect', () async {
    final document = await scraper.getScheduleDocument('blah');
    // Prog. urządzeń mobilnych wyk.
    // Grosser Andrzej Dr inż. /KI/
    // E-learning
    // body > table:nth-child(12) > tbody:nth-child(1) > tr:nth-child(8) > td:nth-child(13)
    final element = document.querySelectorAll('tr')[7].children[12];
    final type = scraper.getActivityType(element);

    expect(type, equals(SubjectType.lecture));
  });

  test('scraper returns proper activity type -> group project', () async {
    final document = await scraper.getScheduleDocument('blah');
    // Projekt zespołowy proj.
    // Olas Tomasz Dr inż. /KI/
    // E-learning
    // body > table:nth-child(12) > tbody:nth-child(1) > tr:nth-child(8) > td:nth-child(15)
    final element = document.querySelectorAll('tr')[7].children[14];
    final type = scraper.getActivityType(element);

    expect(type, equals(SubjectType.groupProject));
  });

  test('scraper returns proper activity location', () async {
    final document = await scraper.getScheduleDocument('blah');
    // Prog. urządzeń mobilnych wyk.
    // Grosser Andrzej Dr inż. /KI/
    // E-learning
    // body > table:nth-child(12) > tbody:nth-child(1) > tr:nth-child(8) > td:nth-child(13)
    final element = document.querySelectorAll('tr')[7].children[12];
    final location = scraper.getActivityLocation(element);

    expect(location, contains('learning'));
  });

  test('scraper returns proper hour', () async {
    // 14.00 - 15.00
    // body > table:nth-child(12) > tbody:nth-child(1) > tr:nth-child(8) > td:nth-child(12)
    final document = await scraper.getScheduleDocument('blah');
    final element = document.querySelectorAll('tr')[7].children[11];
    final value = scraper.getActivityBeginning(element);

    expect(value, contains('14.00'));
  });
}
