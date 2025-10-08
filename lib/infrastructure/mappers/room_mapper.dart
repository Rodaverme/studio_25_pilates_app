 


import 'package:studio_25_pilates_app/domain/entities/entities.dart';

import 'package:studio_25_pilates_app/infrastructure/models/class/nivel/class_nivel_response.dart';

class LevelMapper {
  static Nivel levelApitoEntity(ClassLevelResponse nivel) => Nivel(
    id: nivel.id ?? 1,
    nombre: nivel.name ?? ''
    
    
  );
}
