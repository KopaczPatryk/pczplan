import 'package:html/dom.dart';

import 'package:http/http.dart';
import 'package:pczplan/scraper/models/activity.dart';
import 'package:pczplan/scraper/wimii_schedule_scraper.dart';

class NonstationaryScraper extends WimiiScheduleScraper {
  NonstationaryScraper(Client client) : super(client);

  @override
  int getDayCount(Document document) =>
      document.querySelector('tr').children.length - 1;

  @override
  String getDayName(Document document, int dayIndex) {
    return document.querySelector('tr').children[dayIndex + 1].innerHtml;
  }

  @override
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
