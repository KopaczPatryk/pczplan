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

  test('scraper recognises laboratory', () async {
    final matches = [
      scraper.laboratoryPattern.hasMatch('lab'),
      scraper.laboratoryPattern.hasMatch('Lab'),
      scraper.laboratoryPattern.hasMatch('Lab.'),
    ];

    expect(matches, everyElement(true));
  });
  test('scraper recognises lecture', () async {
    final matches = [
      scraper.lecturePattern.hasMatch('lecture'),
      scraper.lecturePattern.hasMatch('lec.'),
      scraper.lecturePattern.hasMatch('wyk'),
      scraper.lecturePattern.hasMatch('Wyk.'),
    ];

    expect(matches, everyElement(true));
  });

  test('scraper recognises exercises', () async {
    final matches = [
      scraper.exercisePattern.hasMatch('exe.'),
      scraper.exercisePattern.hasMatch('exercise'),
      scraper.exercisePattern.hasMatch('cw'),
      scraper.exercisePattern.hasMatch('Ćw'),
      scraper.exercisePattern.hasMatch('Ćwiczenia.'),
    ];

    expect(matches, everyElement(true));
  });

  test('scraper recognises group project', () async {
    final matches = [
      scraper.gprojPattern.hasMatch('proj.'),
      scraper.gprojPattern.hasMatch('proj'),
      scraper.gprojPattern.hasMatch('project.'),
      scraper.gprojPattern.hasMatch('project'),
    ];

    expect(matches, everyElement(true));
  });

  test('scraper recognises seminary', () async {
    final matches = [
      scraper.seminaryPattern.hasMatch('sem.'),
      scraper.seminaryPattern.hasMatch('sem'),
    ];

    expect(matches, everyElement(true));
  });

  test('scraper recognises language lesson', () async {
    final matches = [
      scraper.langPattern.hasMatch('sjo.'),
      scraper.langPattern.hasMatch('sjo'),
    ];

    expect(matches, everyElement(true));
  });

  test('scraper recognises elearning', () async {
    final matches = [
      scraper.elearningPattern.hasMatch('E-learning'),
      scraper.elearningPattern.hasMatch('e-learning'),
      scraper.elearningPattern.hasMatch('e-lear.'),
    ];

    expect(matches, everyElement(true));
  });

  test('getActivityTeacher', () async {
    final document = await scraper.getScheduleDocument('blah');
    // Architektura systemów komputerowych ćw
    // Gałkowski Tomasz Dr inż. /KISI/
    // E-learning
    // body > table:nth-child(7) > tbody:nth-child(1)
    // > tr:nth-child(7) > td:nth-child(8)
    final element = document.querySelectorAll('tr')[6].children[7];
    final String teacher = scraper.getActivityTeacher(element);

    expect(teacher, contains('Galkowski Tomasz'));
  });
}
