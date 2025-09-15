 



import 'package:studio_25_pilates_app/domain/entities/entities.dart';
import 'package:studio_25_pilates_app/infrastructure/models/class/room/room_response.dart';

class RoomMapper {
  static Room roomApitoEntity(RoomResponse room) => Room(
    id: room.id,
    name: room.name,
    capacity: room.capacity ?? '',
    loation: room.location ?? ''
    
    
  );
}
