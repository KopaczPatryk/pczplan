import 'package:html/dom.dart';
import 'package:http/http.dart';

import 'package:pczplan/scraper/models/activity.dart';
import 'package:pczplan/scraper/wimii_schedule_scraper.dart';

class StationaryScraper extends WimiiScheduleScraper {
  StationaryScraper(Client client) : super(client);

  @override
  int getDayCount(Document document) =>
      (document.querySelector('tr').children.length - 1) ~/ 2;

  @override
  String getDayName(Document document, int dayIndex) {
    final dayFrame = 1 + 2 * dayIndex + 1;
    final dayTd = document.querySelector('tr').children[dayFrame];

    return dayTd.innerHtml;
  }

  @override
  List<Activity> getActivities(Document document, int dayIndex) {
    final activities = <Activity>[];
    final allRows = document.querySelectorAll('tr').sublist(1);
    final hourElements = <Element>[];
    final activityElements = <Element>[];

    allRows.forEach((final Element row) {
      final hourElement = row.children[1 + (dayIndex * 2)];
      final activityElement = row.children[1 + (dayIndex * 2) + 1];

      hourElements.add(hourElement);
      activityElements.add(activityElement);
    });

    var counter = 0;
    activityElements.forEach((element) {
      final activity = getActivity(
        hourElements[counter],
        activityElements[counter],
        counter,
      );
      activities.add(activity);
      counter++;
    });

    return activities;
  }
}
