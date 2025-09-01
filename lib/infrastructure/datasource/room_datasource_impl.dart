import 'package:dio/dio.dart';
import 'package:studio_25_pilates_app/config/dio/dio_client.dart';
import 'package:studio_25_pilates_app/domain/datasources/room_datasource.dart';
import 'package:studio_25_pilates_app/domain/entities/room.dart';
import 'package:studio_25_pilates_app/infrastructure/mappers/level_mapper.dart';
import 'package:studio_25_pilates_app/infrastructure/models/class/room/room_response.dart';

class RoomDatasourceImpl extends RoomDatasource {
  final Dio dio = DioClient.Dio_create();
  @override
  Future<List<Room>> getAllRoom() async {
    try {
      final response = await dio.get('/api/rooms');
      if (response.statusCode == 200 && response.data != null) {
        
        final List<Room> rooms = response.data
            .map(
              (json) => RoomMapper.roomApitoEntity(RoomResponse.fromJson(json)),
            )
            .toList();

        print('Estos son los instructores que existen ${rooms.first}');
        return rooms;
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
  Future<Room> getRoomById(String id) async {
    try {
      final response = await dio.get('/api/rooms/$id');

      if (response.statusCode == 200 && response.data != null) {
        final List<dynamic> data = response.data;

        final room = data.map((e) => RoomResponse.fromJson(e)).toList();

        final cuarto = RoomMapper.roomApitoEntity(room.first);
        print('Un instructor es  ${cuarto.name}');

        return cuarto;
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
