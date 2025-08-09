import 'package:dio/dio.dart';
import 'package:studio_25_pilates_app/domain/datasources/auth_datasource.dart';
import 'package:studio_25_pilates_app/infrastructure/models/auth/login_response.dart';

class AuthDatasourceImpl extends AuthDatasource {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://app.estudio25pilates.com',
      contentType: Headers.jsonContentType,
      responseType: ResponseType.json,
    ),
  );

  @override
  Future<bool> login(String email, String password) async {
    final response = await dio.post(
      '/api/client/login',
      data: {"email": email, "password": password},
    );

    if (response.statusCode == 200) {
      final user = LoginResponse.fromJson(response.data);
      print('Bienvenida ${user.client.name} Token ${user.token}');

      return true;
    }
    return true;
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
