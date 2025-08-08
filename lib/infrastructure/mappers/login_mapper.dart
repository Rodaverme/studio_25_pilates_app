import 'package:studio_25_pilates_app/domain/entities/users.dart';
import 'package:studio_25_pilates_app/infrastructure/models/auth/login_response.dart';

class LoginMapper {
  static Users logintoEntity(Client client) => Users(
    id: client.id,
    name: client.name,
    email: client.email,
    avatarUrl: client.avatarUrl,
  );
}
