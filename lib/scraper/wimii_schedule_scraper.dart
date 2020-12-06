import 'package:pczplan/scraper/models/group.dart';
import 'package:pczplan/scraper/models/schedule.dart';

abstract class WimiiScheduleScraper {
  Future<Schedule> scrapSchedule(Group group);
  void dispose();
}
