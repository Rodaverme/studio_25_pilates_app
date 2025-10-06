import 'package:studio_25_pilates_app/domain/entities/stats.dart';

abstract class StatsDatasource {
  Future<Stats> getStats(DateTime from, DateTime to);
}
