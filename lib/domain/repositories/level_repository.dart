import 'package:studio_25_pilates_app/domain/entities/entities.dart';

abstract class LevelRepository {
  Future <List<Nivel>> getAllLevels();
  Future <Nivel> getLevelById(String id);
}
