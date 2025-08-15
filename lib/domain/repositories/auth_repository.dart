import 'package:studio_25_pilates_app/domain/entities/user.dart';


abstract class AuthRepository{
  Future<User> login(String email, String password);
  Future<void> register(String name, String email, String password, String confirmedPassword);
  Future<String> recoverPassword(String email);
  Future<User> getCurrentClient();
  Future<void> logOut();
}
