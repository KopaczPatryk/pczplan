import 'package:diacritic/diacritic.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:pczplan/scraper/models/subject_type.dart';
import 'package:pczplan/scraper/nonstationary_scraper.dart';

import 'source/nonstationary_site.dart';

void main() {
  final Client mockClient = MockClient((request) async {
    final clean = removeDiacritics(nonstationarySite);

    return Response(clean, 200);
  });

  final scraper = NonstationaryScraper(mockClient);

  test('getScheduleDocument is ok', () async {
    final document = await scraper.getScheduleDocument('blah');
    expect(document, isNotNull);
  });

  test('daycount returns valid count', () async {
    final document = await scraper.getScheduleDocument('blah');
    final count = scraper.getDayCount(document);
    expect(count, 24);
  });

  test('scraper return proper day name', () async {
    final document = await scraper.getScheduleDocument('blah');
    final value = scraper.getDayName(document, 1);
    expect(value, contains('Nie'));
  });

  test('day 0 has proper activity count', () async {
    final document = await scraper.getScheduleDocument('blah');
    final day = scraper.getDay(document, 0);
    expect(day.activities.length, 15);
  });

  test('scraper returns proper activity name', () async {
    final document = await scraper.getScheduleDocument('blah');
    // Architektura systemów komputerowych ćw
    // Gałkowski Tomasz Dr inż. /KISI/
    // E-learning
    // body > table:nth-child(7) > tbody:nth-child(1)
    // > tr:nth-child(7) > td:nth-child(8)
    final element = document.querySelectorAll('tr')[6].children[7];
    final activity = scraper.getActivityName(element);

    expect(activity, contains('Architektura systemow'));
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
