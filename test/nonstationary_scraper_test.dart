import 'package:diacritic/diacritic.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
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
    // Architektura systemów komputerowych ćw
    // Gałkowski Tomasz Dr inż. /KISI/
    // E-learning
    // body > table:nth-child(7) > tbody:nth-child(1)
    // > tr:nth-child(7) > td:nth-child(8)
    final element = document.querySelectorAll('tr')[6].children[7];
    final teacher = scraper.getActivityTeacher(element);

    expect(teacher, contains('Galkowski'));
  });

  test('scraper returns proper activity location', () async {
    final document = await scraper.getScheduleDocument('blah');
    // Podstawy sieci komputerowych lab.
    // Różycki Wojciech Mgr /KI/
    // s. 141 /KI/
    // body > table:nth-child(7) > tbody:nth-child(1) >
    // tr:nth-child(8) > td:nth-child(12)
    final element = document.querySelectorAll('tr')[7].children[11];
    final location = scraper.getActivityLocation(element);
    expect(location, contains('141'));
  });

  test('scraper returns proper activity location on empty teacher field',
      () async {
    final document = await scraper.getScheduleDocument('blah');
    // Język Obcy
    //
    // SJO
    // body > table:nth-child(7) > tbody:nth-child(1) >
    // tr:nth-child(3) > td:nth-child(15)
    final element = document.querySelectorAll('tr')[2].children[14];
    final location = scraper.getActivityLocation(element);

    expect(location.contains('SJO'), true);
  });

  test('scraper returns proper beginning hour', () async {
    final document = await scraper.getScheduleDocument('blah');
    final hourTd = document.querySelectorAll('tr')[1].querySelector('td');
    final value = scraper.getActivityBeginning(hourTd);

    expect(value, anyOf(equals('8:00'), equals('8.00')));
  });
}
