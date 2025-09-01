import 'package:dio/dio.dart';
import 'package:studio_25_pilates_app/config/dio/dio_client.dart';
import 'package:studio_25_pilates_app/domain/datasources/level_datasource.dart';
import 'package:studio_25_pilates_app/domain/entities/nivel.dart';

import 'package:studio_25_pilates_app/infrastructure/mappers/room_mapper.dart';
import 'package:studio_25_pilates_app/infrastructure/models/class/nivel/class_nivel_response.dart';

class LevelDatasourceImpl extends LevelDatasource {
  final Dio dio = DioClient.Dio_create();
  @override
  Future<List<Nivel>> getAllLevels() async {
    try {
      final response = await dio.get('/api/class-levels');
      if (response.statusCode == 200 && response.data != null) {
        final List<dynamic> data = response.data;
        final List<Nivel> niveles = data
            .map(
              (json) => LevelMapper.levelApitoEntity(
                ClassLevelResponse.fromJson(json),
              ),
            )
            .toList();

        print('Estos son los instructores que existen ${niveles.first}');
        return niveles;
      }
      throw Exception('Error al obtner los instructores');
    } on DioException catch (e) {
      throw Exception(
        'Error al obtener todos los planes: ${e.response?.data ?? e.message}',
      );
    } catch (e) {
      throw Exception('Error inesperado: $e');
    }
  }

  @override
  Future<Nivel> getLevelById(String id) async {
    try {
      final response = await dio.get('/api/class-levels/$id');

      if (response.statusCode == 200 && response.data != null) {
        final List<dynamic> data = response.data;

        final nivel = data.map((e) => ClassLevelResponse.fromJson(e)).toList();

        final level = LevelMapper.levelApitoEntity(nivel.first);
        print('Un instructor es  ${level.nombre}');

        return level;
      }
      throw Exception('Error al obtener el instructor');
    } on DioException catch (e) {
      throw Exception(
        'Error al obtener mi instructor: ${e.response?.data ?? e.message}',
      );
    } catch (e) {
      throw Exception('Error inesperado: $e');
    }
  }
}
