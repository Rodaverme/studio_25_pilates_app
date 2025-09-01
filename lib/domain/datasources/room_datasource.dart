import 'package:studio_25_pilates_app/domain/entities/entities.dart';

abstract class RoomDatasource {
  Future<List<Room>> getAllRoom();
  Future<Room> getRoomById(String id);
}
