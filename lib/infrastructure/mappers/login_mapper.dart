import 'package:studio_25_pilates_app/domain/entities/users.dart';
import 'package:studio_25_pilates_app/infrastructure/models/auth/login_response.dart';

class LoginMapper {
  static Users logintoEntity(LoginResponse response) => Users(
    id: response.client.id,
    name: response.client.name,
    email: response.client.email,
    avatarUrl: response.client.avatarUrl,
    token: response.token
  );
}
