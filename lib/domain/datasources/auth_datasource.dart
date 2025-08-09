abstract class AuthDatasource {
  Future<bool> login(String email, String password);
  Future<String> register(String name, String email, String password);
  Future<String> recoverPassword(String email);
}
