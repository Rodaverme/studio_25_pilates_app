import 'package:studio_25_pilates_app/domain/entities/stats.dart';
import 'package:studio_25_pilates_app/domain/repositories/stats_repository.dart';
import 'package:studio_25_pilates_app/infrastructure/datasource/stats_datasource_impl.dart';

class StatsRepositoryImpl extends StatsRepository {
  final StatsDatasourceImpl datasourceImpl;

  StatsRepositoryImpl({required this.datasourceImpl});
  @override
  Future<Stats> getStats(DateTime from, DateTime to) {
    return datasourceImpl.getStats(from, to);
  }
}
