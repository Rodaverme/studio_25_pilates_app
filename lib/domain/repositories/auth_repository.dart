import 'package:studio_25_pilates_app/infrastructure/models/auth/login_response.dart';

abstract class AuthRepository{
  Future<LoginResponse> login(String email, String password);
  Future<void> register(String name, String email, String password, String confirmedPassword);
  Future<String> recoverPassword(String email);
  Future<Client> getCurrentClient();
  Future<void> logOut();
}
