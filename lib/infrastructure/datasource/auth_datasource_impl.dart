import 'package:dio/dio.dart';
import 'package:studio_25_pilates_app/config/dio/dio_client.dart';
import 'package:studio_25_pilates_app/domain/datasources/auth_datasource.dart';
import 'package:studio_25_pilates_app/infrastructure/models/auth/login_response.dart';
import 'package:studio_25_pilates_app/presentation/services/Auth/token_service.dart';

class AuthDatasourceImpl extends AuthDatasource {
  final Dio dio = DioClient.Dio_create(); 

  @override
  Future<bool> login(String email, String password) async {
    try {
    final response = await dio.post(
      '/api/client/login',
      data: {"email": email, "password": password},
    );

    if (response.statusCode == 200 && response.data != null ) {
      final user = LoginResponse.fromJson(response.data);
      //TODO GUARDAR EL TOKEN PARA UTILIZARLO EN LA APP
       await TokenService.saveToken(user.token);
      print('Bienvenida ${user.client.name} Token ${user.token}');
      return true;
    }
    
    return false;
    }on DioException catch (e){
      print('Erro en el Login : ${e.response?.data ?? e.message}');
      return false;
      
    }catch(e){
      print('Error inseperado: $e');
      return false;
    }
  }

  @override
  Future<String> recoverPassword(String email) {
    throw UnimplementedError();
  }

  @override
  Future<String> register(String name, String email, String password) {
    throw UnimplementedError();
  }
}
