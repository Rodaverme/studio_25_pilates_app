
import 'package:studio_25_pilates_app/domain/entities/room.dart';
import 'package:studio_25_pilates_app/domain/repositories/room_repository.dart';
import 'package:studio_25_pilates_app/infrastructure/datasource/room_datasource_impl.dart';

class RoomRepositoryImpl extends RoomRepository {
  final RoomDatasourceImpl datasource;

  RoomRepositoryImpl({required this.datasource});
  @override
  Future<List<Room>> getAllRoom() {
    return datasource.getAllRoom();
  }

  @override
  Future<Room> getRoomById(String id) {
    return datasource.getRoomById(id);
  }
}
