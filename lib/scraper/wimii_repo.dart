import 'package:html/parser.dart';
import 'package:http/http.dart';
import 'package:pczplan/scraper/models/group.dart';
import 'package:pczplan/scraper/models/schedule.dart';
import 'package:pczplan/scraper/models/study_mode.dart';
import 'package:pczplan/scraper/models/study_type.dart';
import 'package:pczplan/scraper/nonstationary_scraper.dart';
import 'package:pczplan/scraper/stationary_scraper.dart';
import 'package:pczplan/scraper/wimii_schedule_scraper.dart';

import 'package:pczplan/web_constants.dart' as web_constants;

class WimiiRepo {
  final Client _client = Client();

  ///stacjonarne/niestacjonarne
  Future<List<StudyType>> getStudyTypes() async {
    final response = await _client.get(web_constants.studyTypesPage);

    final document = parse(response.body);

    final elements = document
        .querySelectorAll('p')
        .where((element) => element.innerHtml.contains('zajęć'))
        .toList();

    final studyTypes = <StudyType>[];
    elements.forEach((p) {
      final link =
          web_constants.wimiiHomePage + p.querySelector('a').attributes['href'];
      final studyMode = p.text.contains('niestacjo')
          ? StudyMode.nonStationary
          : StudyMode.stationary;
      studyTypes.add(StudyType(p.text, link, studyMode));
    });
    studyTypes.sort((b, a) => a.name.compareTo(b.name));
    return studyTypes;
  }

  ///grupa 1/2/3/4
  Future<List<Group>> getGroups(StudyType st) async {
    final response = await _client.get(st.link);
    final document = parse(response.body);
    final groupElements = document.querySelectorAll('td > a').toList();

    final groups = <Group>[];
    groupElements.forEach((element) {
      final name = element.text;

      String link;
      switch (st.mode) {
        case StudyMode.stationary:
          link = web_constants.stationaryGroups;
          break;
        case StudyMode.nonStationary:
          link = web_constants.nonstationaryGroups;
          break;
      }
      link += element.attributes['href'];
      groups.add(Group(name, link, st.mode));
    });
    groups.sort((a, b) => a.name.compareTo(b.name));
    return groups;
  }

  ///plan konkretny dla grupy
  Future<Schedule> getSchedule(Group group) async {
    Schedule schedule;
    WimiiScheduleScraper scraper;
    switch (group.mode) {
      case StudyMode.stationary:
        scraper = StationaryScraper(Client());
        break;
      case StudyMode.nonStationary:
        scraper = NonstationaryScraper(Client());
        break;
    }
    schedule = await scraper.scrapSchedule(group);
    scraper.dispose();
    return schedule;
  }

  void dispose() {
    _client.close();
  }
}
