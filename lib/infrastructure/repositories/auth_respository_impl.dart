


import 'package:studio_25_pilates_app/domain/datasources/auth_datasource.dart';
import 'package:studio_25_pilates_app/domain/repositories/auth_repository.dart';
import 'package:studio_25_pilates_app/infrastructure/models/auth/login_response.dart';



class AuthRespositoryImpl extends AuthRepository {
  final AuthDatasource datasource;

  AuthRespositoryImpl({required this.datasource});



  @override
  Future<LoginResponse> login(String email, String password) {
    return datasource.login(email, password);
  }

  @override
  Future<String> recoverPassword(String email) {
  return datasource.recoverPassword(email);
  }

  @override
  Future<String> register(String name, String email, String password) {
    return datasource.register(name, email, password);
  }
  
  @override
  Future<Client> getCurrentClient() {
    return datasource.getCurrentClient();
  }
  
}