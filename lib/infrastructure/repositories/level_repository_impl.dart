
import 'package:studio_25_pilates_app/domain/entities/nivel.dart';
import 'package:studio_25_pilates_app/domain/repositories/level_repository.dart';
import 'package:studio_25_pilates_app/infrastructure/datasource/level_datasource_impl.dart';

class LevelRepositoryImpl extends LevelRepository {
  final LevelDatasourceImpl datasource;

  LevelRepositoryImpl({required this.datasource});
  @override
  Future<List<Nivel>> getAllLevels() {
    return datasource.getAllLevels();
  }

  @override
  Future<Nivel> getLevelById(String id) {
    return datasource.getLevelById(id);
  }
}
