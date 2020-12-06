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
    expect(count, 5);
  });

  test('scraper return proper day name -> poniedizalek', () async {
    final document = await scraper.getScheduleDocument('blah');
    final value = scraper.getDayName(document, 0);
    expect(value.contains('Ponie'), true);
  });

  test('scraper return proper day name -> środa', () async {
    final document = await scraper.getScheduleDocument('blah');
    final value = scraper.getDayName(document, 2);
    expect(value.contains('roda'), true);
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

  test('day 2 returns 12 activities', () async {
    final document = await scraper.getScheduleDocument('blah');
    final day = scraper.getDay(document, 2);
    expect(day.activities.length, 12);
  });

  test('day 3 returns 12 activities', () async {
    final document = await scraper.getScheduleDocument('blah');
    final day = scraper.getDay(document, 3);
    expect(day.activities.length, 12);
  });

  test('day 4 returns 12 activities', () async {
    final document = await scraper.getScheduleDocument('blah');
    final day = scraper.getDay(document, 4);
    expect(day.activities.length, 12);
  });

  test('scraper returns proper activity name', () async {
    final document = await scraper.getScheduleDocument('blah');
    // obliczenia symboliczne
    final element = document.querySelectorAll('td')[19];
    final activity = scraper.getActivityName(element);

    final statement = activity.toLowerCase().contains('instalacji');

    expect(statement, true);
  });

  test('scraper returns proper activity teacher', () async {
    final document = await scraper.getScheduleDocument('blah');
    //Eksploatacja instalacji energetycznych
    final element = document.querySelectorAll('td')[19];
    final teacher = scraper.getActivityTeacher(element);

    expect(teacher.toLowerCase().contains('Artur'.toLowerCase()), true);
  });

  test('scraper returns proper activity type -> lab', () async {
    final document = await scraper.getScheduleDocument('blah');
    final element = document.querySelectorAll('td')[19];
    final type = scraper.getActivityType(element);

    expect(type == SubjectType.laboratory, true);
  });

  test('scraper returns proper activity type -> lang', () async {
    final document = await scraper.getScheduleDocument('blah');
    final element = document.querySelectorAll('td')[20];
    final type = scraper.getActivityType(element);

    expect(type == SubjectType.lang, true);
  });

  test('scraper returns proper activity location', () async {
    final document = await scraper.getScheduleDocument('blah');
    final element = document.querySelectorAll('td')[19];
    final location = scraper.getActivityLocation(element);

    expect(location.contains('KMC'), true);
  });

  test('scraper returns proper activity location on empty teacher field',
      () async {
    final document = await scraper.getScheduleDocument('blah');
    final element = document.querySelectorAll('td')[20];
    final location = scraper.getActivityLocation(element);

    expect(location.contains('SJO'), true);
  });

  test('scraper returns proper beginning hour', () async {
    final document = await scraper.getScheduleDocument('blah');
    final hourTd = document.querySelectorAll('tr')[1].querySelector('td');
    final value = scraper.getActivityBeginning(hourTd);

    expect(value, contains('8.00'));
  });

  test('scraper returns exact beginning hour', () async {
    final document = await scraper.getScheduleDocument('blah');
    final hourTd = document.querySelectorAll('tr')[1].querySelector('td');
    final value = scraper.getActivityBeginning(hourTd);

    expect(value, equals('8.00'));
  });
}
