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
  Future<String> login(String email, String password) async {
    try {
      final response = await dio.post(
        '/api/client/login',
        data: {"email": email, "password": password},
      );

      if (response.statusCode == 200) {
        // Imprimir para depuración
        

        // final token = response.data['token'];
        final clientData = response.data['client'];

        if (clientData != null) {
          final user = Client.fromJson(clientData);

          // Aquí podrías guardar el token para futuras peticiones
          // Ejemplo: await secureStorage.write(key: 'token', value: token);

          return 'Bienvenido ${user.name}';
        }
        throw Exception('Datos del cliente no encontrados');
      } else {
        throw Exception(response.data['message'] ?? 'Error en la solicitud');
      }
    } on DioException catch (e) {
      final errorMsg = e.response?.data['message'] ?? 'Error de conexión';
      throw Exception(errorMsg);
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
