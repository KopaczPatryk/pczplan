import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:pczplan/scraper/models/subject_type.dart';
import 'package:pczplan/scraper/nonstationary_scraper.dart';

void main() {
  final Client mockClient = MockClient((request) async {
    return Response(site, 200);
  });

  final scraper = NonstationaryScraper(mockClient);

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

//https://wimii.pcz.pl/download/plan/studia_stacjonarne/o21t.html
const site = '''<html><head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-2">
<meta http-equiv="Content-Language" content="pl">
<meta name="Description" content="Plan">
<title>www.wimii.pcz.pl</title>
<style type="text/css">
body {font:bold 10 verdana,sans-serif;background-color:#C0C0C0;color:#000000}
table {table-layout: fixed; width: 1920px; font:normal 8pt verdana,sans-serif; color:#080000; text-align=left; border: 1px solid black;}
td {overflow: hidden; white-space: nowrap}
</style>
</head>
<body>
Energetyka .I -go st. sem. 6  RSE<br>
Data publikacji: 2020-03-06<br><br>
<table cellspacing="0" cellpadding="1" rules=all>
<tr valign=top>
<td style="width:84px; background-color:#B0B0FF">&nbsp</td>
<td style="width:347px; background-color:#EBEB87">Poniedzia³ek</td>
<td style="width:371px; background-color:#EBEBEB">Wtorek</td>
<td style="width:399px; background-color:#87EB87">¦roda</td>
<td style="width:366px; background-color:#14DADA">Czwartek</td>
<td style="width:353px; background-color:#3535EB">Pi±tek</td>
</tr>
<tr valign=top>
<td style="background-color:#B0B0FF">1.<br>8.00 - 9.00</td>
<td>Eksploatacja instalacji energetycznych wyk.<br>Elsner Witold  Prof. dr hab. in¿. /KMC/<br>Dró¿d¿ Artur Dr in¿. /KMC/<br>s. 210 /KMC/ </td>
<td>Praca przej¶ciowa proj.<br>Otwinowski Henryk  Prof. dr hab. in¿. /KMC/<br>Górecka-Zbroñska Aleksandra Dr in¿. /KMC/<br>s. 210 /KMC/ </td>
<td>Uk³ady kogeneracyjne w energetyce rozproszonej wyk<br>Pyrc Micha³  Dr in¿. /KMC/<br>s. 12 /KMC/ </td>
<td>&nbsp</td>
<td>Eksploatacja silników spalinowych lab.<br>Grab-Rogaliñski Karol Dr in¿. /KMC/<br>s. 112 /KMC/ </td>
</tr>
<tr valign=top>
<td style="background-color:#B0B0FF">2.<br>9.00 - 10.00</td>
<td>Eksploatacja instalacji energetycznych wyk.<br>Elsner Witold  Prof. dr hab. in¿. /KMC/<br>Dró¿d¿ Artur Dr in¿. /KMC/<br>s. 210 /KMC/ </td>
<td>Praca przej¶ciowa proj.<br>Otwinowski Henryk  Prof. dr hab. in¿. /KMC/<br>Górecka-Zbroñska Aleksandra Dr in¿. /KMC/<br>s. 210 /KMC/ </td>
<td>Uk³ady kogeneracyjne w energetyce rozproszonej wyk<br>Pyrc Micha³  Dr in¿. /KMC/<br>s. 12 /KMC/ </td>
<td>&nbsp</td>
<td>Eksploatacja silników spalinowych lab.<br>Grab-Rogaliñski Karol Dr in¿. /KMC/<br>s. 112 /KMC/ </td>
</tr>
<tr valign=top>
<td style="background-color:#B0B0FF">3.<br>10.00 - 11.00</td>
<td>Eksploatacja instalacji energetycznych lab.<br>Dró¿d¿ Artur  Dr in¿. /KMC/<br>s. H-1-1- /KMC/ </td>
<td>Jêzyk Obcy<br><br>SJO</td>
<td>Uk³ady kogeneracyjne w energetyce rozproszonej lab<br>Pyrc Micha³  Dr in¿. /KMC/<br>s. 112 /KMC/ </td>
<td>&nbsp</td>
<td>Modelowanie procesów energetycznych  wyk.<br>Tyliszczak Artur  Dr hab. in¿. Prof. PCz  /KMC/<br>Maciej Marek Dr hab. in¿. /KMC/<br>s. 210 /KMC/ </td>
</tr>
<tr valign=top>
<td style="background-color:#B0B0FF">4.<br>11.00 - 12.00</td>
<td>Eksploatacja instalacji energetycznych lab.<br>Dró¿d¿ Artur  Dr in¿. /KMC/<br>s. H-1-1- /KMC/ </td>
<td>Jêzyk Obcy<br><br>SJO</td>
<td>Uk³ady kogeneracyjne w energetyce rozproszonej sem<br>Pyrc Micha³  Dr in¿. /KMC/<br>s. 112 /KMC/ </td>
<td>&nbsp</td>
<td>Modelowanie procesów energetycznych  wyk.<br>Tyliszczak Artur  Dr hab. in¿. Prof. PCz  /KMC/<br>Maciej Marek Dr hab. in¿. /KMC/<br>s. 210 /KMC/ </td>
</tr>
<tr valign=top>
<td style="background-color:#B0B0FF">5.<br>12.00 - 13.00</td>
<td>Eksploatacja silników spalinowych wyk.<br>Jamrozik Arkadiusz  Dr hab. in¿. /KMC/<br>s. 12 /KMC/ </td>
<td>Ogrzewnictwo, wentylacja i klimatyzacja wyk.<br>Moryñ-Kucharczyk El¿bieta Dr in¿. /KMC/<br>Szymanek Arkadiusz Dr hab. in¿. prof. PCz /KMC/<br>s. 210 /KMC/ </td>
<td>Modelowanie procesów energetycznych  lab.<br>Wawrzak Agnieszka  Dr in¿. /IMC/<br>s. 10 /KMC/ </td>
<td>&nbsp</td>
<td>&nbsp</td>
</tr>
<tr valign=top>
<td style="background-color:#B0B0FF">6.<br>13.00 - 14.00</td>
<td>Eksploatacja silników spalinowych wyk.<br>Jamrozik Arkadiusz  Dr hab. in¿. /KMC/<br>s. 12 /KMC/ </td>
<td>Ogrzewnictwo, wentylacja i klimatyzacja wyk.<br>Moryñ-Kucharczyk El¿bieta Dr in¿. /KMC/<br>Szymanek Arkadiusz Dr hab. in¿. prof. PCz /KMC/<br>s. 210 /KMC/ </td>
<td>Modelowanie procesów energetycznych  lab.<br>Wawrzak Agnieszka  Dr in¿. /IMC/<br>s. 10 /KMC/ </td>
<td>&nbsp</td>
<td>&nbsp</td>
</tr>
<tr valign=top>
<td style="background-color:#B0B0FF">7.<br>14.00 - 15.00</td>
<td>&nbsp</td>
<td>Ogrzewnictwo, wentylacja i klimatyzacja lab.<br>Moryñ-Kucharczyk El¿bieta Dr in¿. /KMC/<br>Dariusz Urbaniak Dr in¿. /KMC/<br>s. 110 /KMC/ </td>
<td>Modelowanie procesów energetycznych  lab.<br>Wawrzak Agnieszka  Dr in¿. /IMC/<br>s. 10 /KMC/ </td>
<td>&nbsp</td>
<td>&nbsp</td>
</tr>
<tr valign=top>
<td style="background-color:#B0B0FF">8.<br>15.00 - 16.00</td>
<td>&nbsp</td>
<td>Ogrzewnictwo, wentylacja i klimatyzacja lab.<br>Moryñ-Kucharczyk El¿bieta Dr in¿. /KMC/<br>Dariusz Urbaniak Dr in¿. /KMC/<br>s. 110 /KMC/ </td>
<td>&nbsp</td>
<td>&nbsp</td>
<td>&nbsp</td>
</tr>
<tr valign=top>
<td style="background-color:#B0B0FF">9.<br>16.00 - 17.00</td>
<td>&nbsp</td>
<td>&nbsp</td>
<td>&nbsp</td>
<td>&nbsp</td>
<td>&nbsp</td>
</tr>
<tr valign=top>
<td style="background-color:#B0B0FF">10.<br>17.00 - 18.00</td>
<td>&nbsp</td>
<td>&nbsp</td>
<td>&nbsp</td>
<td>&nbsp</td>
<td>&nbsp</td>
</tr>
<tr valign=top>
<td style="background-color:#B0B0FF">11.<br>18.00-19.00</td>
<td>&nbsp</td>
<td>&nbsp</td>
<td>&nbsp</td>
<td>&nbsp</td>
<td>&nbsp</td>
</tr>
<tr valign=top>
<td style="background-color:#B0B0FF">12.<br>19.00-20.00</td>
<td>&nbsp</td>
<td>&nbsp</td>
<td>&nbsp</td>
<td>&nbsp</td>
<td>&nbsp</td>
</tr>
</table>
wimii.pcz.pl<p><br>
</body>
</html>''';
